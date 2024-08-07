//
//  CountriesListVM.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
import RxSwift
         
protocol CountriesListVMDelegete: AnyObject {
    func countriesFetched(countries: [CountryData]?, error: Error?)
}

class CountriesListVM {
    
    private var countryList: [CountryData] = []
    private var savedList: [CountryData] = []
    weak var delegate: CountriesListVMDelegete?
    
    var dataService = NetworkManager()
    private let disposeBag = DisposeBag()
    
    init() {
        fetchCountries()
    }
    
    func fetchCountries() {
        countryList.removeAll()
        
        dataService.fetchCountries()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] countries in
                guard let self else {
                    self?.delegate?.countriesFetched(countries: self?.countryList ?? [], error: ErrorsHandlers.requestError(.decodingError("Fail when try to subscribe")))
                    return
                }
                
                self.countryList = self.savedList.reversed()
                
                let filteredCountryList = countries.filter { country in
                    !self.countryList.contains { $0.name?.common == country.name?.common }
                }
                
                self.countryList.append(contentsOf: filteredCountryList)
                self.delegate?.countriesFetched(countries: self.countryList, error: nil)
            }, onFailure: { [weak self] error in
                guard let self else {
                    self?.delegate?.countriesFetched(countries: self?.countryList , error: ErrorsHandlers.requestError(.other(error)))
                    return
                }
                
                self.delegate?.countriesFetched(countries: self.countryList, error: error)
            })
            .disposed(by: disposeBag)
    }
}
