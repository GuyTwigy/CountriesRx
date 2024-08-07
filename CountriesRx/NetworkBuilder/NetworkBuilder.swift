//
//  NetworkBuilder.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation

class NetworkBuilder {
    
    enum ApiUrls {
        case countriesBaseUrl
        
        var description: String {
            switch self {
            case .countriesBaseUrl:
                return "https://restcountries.com/v3.1/all"
            }
        }
    }
    
    enum EndPoints {
        case querysCountries
        
        var description: String {
            switch self {
            case .querysCountries:
                return "?fields=name,flag"
            }
        }
    }
}
