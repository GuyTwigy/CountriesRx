//
//  ErrorsHandlers.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation

enum ErrorsHandlers: Error {
    
    case requestError(RequestError)
    case serverError(ServerError)
    
    enum RequestError {
        case invalidRequest(URLRequest)
        case decodingError(String)
        case encodingError(EncodingError)
        case other(Error)
    }

    enum ServerError {
        case decodingError(DecodingError)
        case noInternetConnection
        case timeout
        case internalServerError
        case badResponse
        case invalidStatusCode(String)
        case other(statusCode: Int, response: HTTPURLResponse)
    }
}
