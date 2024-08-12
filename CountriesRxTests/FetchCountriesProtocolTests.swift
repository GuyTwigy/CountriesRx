//
//  FetchCountriesProtocolTests.swift
//  CountriesRxTests
//
//  Created by Guy Twig on 11/08/2024.
//

import XCTest
import RxSwift
import RxBlocking
@testable import CountriesRx

final class FetchCountriesProtocolTests: XCTestCase {
    
    var dataService: FetchCountriesProtocol?
    
    override func setUpWithError() throws {
        dataService = NetworkManager()
    }
    
    override func tearDownWithError() throws {
        dataService = nil
    }
    
    func test_FetchCountriesProtocolTests_fetchCountries() throws {
        // Given
        let expectation = self.expectation(description: "Fetch countries")
        
        // When
        var countriesResult: [CountryData]?
        do {
            countriesResult = try dataService?.fetchCountries().do(onSuccess: { _ in
                expectation.fulfill()
            }).toBlocking().single()
        } catch {
            XCTFail("Fetching countries failed with error: \(error)")
        }
        
        // Then
        XCTAssertNotNil(countriesResult)
        XCTAssertFalse(countriesResult?.isEmpty ?? true)
        XCTAssertGreaterThan(countriesResult?.count ?? 0, 1)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
