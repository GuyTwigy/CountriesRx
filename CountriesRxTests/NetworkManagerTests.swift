//
//  NetworkManagerTests.swift
//  CountriesRxTests
//
//  Created by Guy Twig on 11/08/2024.
//

import XCTest
@testable import CountriesRx

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager?
    var mockSession: MockURLSession?
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        networkManager = NetworkManager()
        if let mockSession {
            networkManager?.setSession(session: mockSession)
        }
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
        mockSession = nil
    }
    
    func testBadURL() {
        // Given
        
        // When & Then
        XCTAssertThrowsError(try networkManager?.getRequestData(components: nil, type: CountryData.self).toBlocking().single()) { error in
            XCTAssertEqual((error as? URLError)?.code, .badURL)
        }
    }
    
    func test_NetworkManager_BadServerResponse() {
        // Given
        mockSession?.response = URLResponse(url: URL(string: "\(NetworkBuilder.ApiUrls.countriesBaseUrl.description)")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        
        // When & Then
        XCTAssertThrowsError(try networkManager?.getRequestData(components: URLComponents(string: "\(NetworkBuilder.ApiUrls.countriesBaseUrl.description)?fields=name,flag"), type: CountryData.self).toBlocking().single()) { error in
            XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
        }
    }
    
    func test_NetworkManager_Non200StatusCode() {
        // Given
        mockSession?.response = HTTPURLResponse(url: URL(string: "\(NetworkBuilder.ApiUrls.countriesBaseUrl.description)")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        // When & Then
        XCTAssertThrowsError(try networkManager?.getRequestData(components: URLComponents(string: "\(NetworkBuilder.ApiUrls.countriesBaseUrl.description)?fields=name,flag"), type: CountryData.self).toBlocking().single()) { error in
            XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
        }
    }
    
    func test_NetworkManager_DataTaskError() {
        // Given
        mockSession?.error = URLError(.notConnectedToInternet)
        
        // When & Then
        XCTAssertThrowsError(try networkManager?.getRequestData(components: URLComponents(string: "\(NetworkBuilder.ApiUrls.countriesBaseUrl.description)?fields=name,flag"), type: CountryData.self).toBlocking().single()) { error in
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
    
    func test_NetworkManager_GetRequestDataSuccess() {
        // Given
        let country = CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString: Utils.generate24HexDigitString())
        let data = try! JSONEncoder().encode(country)
        let response = HTTPURLResponse(url: URL(string: "\(NetworkBuilder.ApiUrls.countriesBaseUrl.description)")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockSession?.data = data
        mockSession?.response = response
        
        // When
        let components = URLComponents(string: "\(NetworkBuilder.ApiUrls.countriesBaseUrl.description)?fields=name,flag")
        let result = try? networkManager?.getRequestData(components: components, type: CountryData.self).toBlocking().single()
        
        // Then
        XCTAssertEqual(result, country)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name?.common, country.name?.common)
    }
}
