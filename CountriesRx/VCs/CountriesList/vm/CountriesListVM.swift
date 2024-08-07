//
//  CountriesListVM.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
         
protocol CountriesListVMDelegete: AnyObject {
    func countriesFetched(countries: [CountryData]?, error: Error?)
}

class CountriesListVM {
    
    private var countryList: [CountryData] = []
    private var savedList: [CountryData] = []
    weak var delegate: CountriesListVMDelegete?
    
    var dataService = NetworkManager()
    
    init() {
        Task {
            await fetchCountries()
        }
    }
    
    func fetchCountries() async {
        
        countryList.removeAll()
        
        do {
            let countries = try await dataService.fetchCountries()
            countryList = savedList.reversed()
            
            let filteredCountryList = countries.filter { country in
                !countryList.contains { $0.name?.common == country.name?.common }
            }
            
            countryList.append(contentsOf: filteredCountryList)
            delegate?.countriesFetched(countries: countryList, error: nil)
        } catch {
            delegate?.countriesFetched(countries: countryList, error: ErrorsHandlers.requestError(.other(error)))
        }
    }
}
