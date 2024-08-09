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

class CountriesListVM {
    
    var countryList = PublishSubject<[CountryData]>()
    private var countryModifiedList: [CountryData] = []
    private var savedList: [CountryData] = []
    private var notFilteredCountryList: [CountryData] = []
    weak var delegate: CountriesListVMDelegete?
    
    var dataService = NetworkManager()
    private let disposeBag = DisposeBag()
    
    init() {
        fetchCountries()
    }
    
    func fetchCountries() {
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
                
                self.countryModifiedList = self.savedList.reversed()
                
                let filteredCountryList = countries.filter { country in
                    !self.countryModifiedList.contains { $0.name?.common == country.name?.common }
                }
                
                self.countryModifiedList.append(contentsOf: filteredCountryList)
                self.countryList.onNext(self.countryModifiedList)
                self.notFilteredCountryList = self.countryModifiedList
                self.delegate?.countriesFetched(error: nil)
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
    }
    
    func textFieldChanged(countries: [CountryData], text: String) {
        countryModifiedList.removeAll()
        countryModifiedList = countries
        if !text.isEmpty {
            countryModifiedList = filterCountries(with: text)
        } else {
            countryModifiedList = resetCountriesList()
        }
        countryList.onNext(countryModifiedList)
    }
    
    private func filterCountries(with searchText: String) -> [CountryData] {
        let filteredList = notFilteredCountryList.filter { country in
            return country.name?.common?.lowercased().contains(searchText.lowercased()) ?? false
        }
        return filteredList
    }
    
    private func resetCountriesList() -> [CountryData] {
        return notFilteredCountryList
    }
}
