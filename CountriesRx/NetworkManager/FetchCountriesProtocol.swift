//
//  FetchCountriesProtocol.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation

protocol FetchCountriesProtocol {
    func fetchCountries() async throws -> [CountryData]
}

extension NetworkManager: FetchCountriesProtocol {
    func fetchCountries() async throws -> [CountryData] {
        var components = URLComponents(string: "\(NetworkBuilder.ApiUrls.countriesBaseUrl.description)")
        
        components?.queryItems = [
            URLQueryItem(name: "fields", value: "name,flag"),
        ]
        
        do {
            let countriesResponse = try await getRequestData(components: components, type: [CountryData].self)
            return countriesResponse
        } catch {
            throw error
        }
    }
}
