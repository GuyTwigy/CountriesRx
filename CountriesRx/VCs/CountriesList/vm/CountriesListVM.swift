//
//  CountriesListVM.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
import RxSwift
import RealmSwift
         
protocol CountriesListVMDelegete: AnyObject {
    func countriesFetched(error: Error?)
}

@MainActor
class CountriesListVM {
    
    var countryList = PublishSubject<[CountryData]>()
    private var countryModifiedList: [CountryData] = []
    private var savedList: [CountryData] = []
    private var notFilteredCountryList: [CountryData] = []
    weak var delegate: CountriesListVMDelegete?
    
    var dataService = NetworkManager()
    private let disposeBag = DisposeBag()
    
    init() {}
    
    func singleFetchCountries() async {
        do {
            let realmCountries = try await RealmManager.shared.fetchRealmCountries()
            savedList.removeAll()
            savedList = realmCountries
            countryModifiedList.removeAll()
            
            dataService.fetchCountries()
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] countries in
                    guard let self else {
                        self?.countryList.onNext(self?.countryModifiedList ?? [])
                        self?.countryList.onCompleted()
                        self?.delegate?.countriesFetched(error: ErrorsHandlers.requestError(.decodingError("Fail when try to subscribe")))
                        return
                    }
                    
                    handleResultOfCountries(countriesResult: countries)
                }, onFailure: { [weak self] error in
                    guard let self else {
                        self?.countryList.onNext(self?.countryModifiedList ?? [])
                        self?.countryList.onCompleted()
                        self?.delegate?.countriesFetched(error: ErrorsHandlers.requestError(.other(error)))
                        return
                    }
                    
                    self.countryList.onNext(countryModifiedList)
                    self.delegate?.countriesFetched(error: error)
                })
                .disposed(by: disposeBag)
        } catch {
            print("Fail to fetch fav list, error: \(error.localizedDescription)")
            delegate?.countriesFetched(error: error)
        }
    }
    
    func fetchCountries() async {
        do {
            let realmCountries = try await RealmManager.shared.fetchRealmCountries()
            savedList.removeAll()
            savedList = realmCountries
            countryModifiedList.removeAll()
            countryModifiedList = savedList

            let fetch1 = dataService.fetchCountries().asObservable()
            let fetch2 = dataService.fetchCountries().asObservable()
            let fetch3 = dataService.fetchCountries().asObservable()
            let fetch4 = dataService.fetchCountries().asObservable()

            Observable.zip(fetch1, fetch2, fetch3, fetch4)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] result1, result2, result3, result4 in
                    guard let self else { return }
                    
                    print("result1: num of countries \(result1.count)")
                    print("result2: num of countries \(result2.count)")
                    print("result3: num of countries \(result3.count)")
                    print("result4: num of countries \(result4.count)")
                    
                    handleResultOfCountries(countriesResult: result1)
                }, onError: { [weak self] error in
                    guard let self else {
                        self?.countryList.onNext(self?.countryModifiedList ?? [])
                        self?.countryList.onCompleted()
                        self?.delegate?.countriesFetched(error: ErrorsHandlers.requestError(.other(error)))
                        return
                    }
                    
                    self.countryList.onNext(self.countryModifiedList)
                    self.delegate?.countriesFetched(error: error)
                })
                .disposed(by: disposeBag)
        } catch {
            print("Failed to fetch fav list, error: \(error.localizedDescription)")
            delegate?.countriesFetched(error: error)
        }
    }
    
    func handleResultOfCountries(countriesResult: [CountryData]) {
        let missingCountries = savedList.filter { savedCountry in
            !countriesResult.contains { $0.name?.common == savedCountry.name?.common }
        }

        if !missingCountries.isEmpty {
            savedList.removeAll { savedCountry in
                missingCountries.contains { $0.name?.common == savedCountry.name?.common }
            }
        }
        
        countryModifiedList = savedList
        
        let filteredCountryList = countriesResult.filter { country in
            !countryModifiedList.contains { $0.name?.common == country.name?.common }
        }
        
        countryModifiedList.append(contentsOf: filteredCountryList)
        countryList.onNext(countryModifiedList)
        notFilteredCountryList = countryModifiedList
        delegate?.countriesFetched(error: nil)
    }
    
    func textFieldChanged(countries: [CountryData], text: String) {
        countryModifiedList.removeAll()
        countryModifiedList = countries
        if !text.isEmpty {
            countryModifiedList = filterCountries(searchText: text)
        } else {
            countryModifiedList = resetCountriesList()
        }
        countryList.onNext(countryModifiedList)
    }
    
    private func filterCountries(searchText: String) -> [CountryData] {
        let filteredList = notFilteredCountryList.filter { country in
            return country.name?.common?.lowercased().contains(searchText.lowercased()) ?? false
        }
        return filteredList
    }
    
    private func resetCountriesList() -> [CountryData] {
        return notFilteredCountryList
    }
}
