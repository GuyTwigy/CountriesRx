//
//  FetchCountriesProtocol.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
import RxSwift

protocol FetchCountriesProtocol {
    func fetchCountries() -> Single<[CountryData]>
}

extension NetworkManager: FetchCountriesProtocol {
    func fetchCountries() -> Single<[CountryData]> {
        var components = URLComponents(string: "\(NetworkBuilder.ApiUrls.countriesBaseUrl.description)")
        
        components?.queryItems = [
            URLQueryItem(name: "fields", value: "name,flag"),
        ]
        
        return getRequestData(components: components, type: [CountryData].self)
    }
}
