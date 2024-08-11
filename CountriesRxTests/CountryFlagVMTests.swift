//
//  CountryFlagVMTests.swift
//  CountriesRxTests
//
//  Created by Guy Twig on 11/08/2024.
//

import XCTest
@testable import CountriesRx

final class CountryFlagVMTests: XCTestCase {

    var vm: CountryFlagVM?
    var mockCountry: CountryData?

    override func setUpWithError() throws {
        mockCountry = CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString: Utils.generate24HexDigitString())
    }

    override func tearDownWithError() throws {
        mockCountry = nil
        vm = nil
    }

    func test_CountryFlagVM_init_CountryNotNil() {
        XCTAssertNotNil(mockCountry)
        XCTAssertNotNil(mockCountry?.name?.common)
        XCTAssertNotNil(mockCountry?.flag)
        XCTAssertEqual("Israel", mockCountry?.name?.common)
        XCTAssertEqual("🇮🇱", mockCountry?.flag)
    }

    func test_CountryFlagVM_init_CountryNil() {
        // When
        mockCountry = nil
        
        // Then
        XCTAssertNil(mockCountry)
        XCTAssertNil(mockCountry?.name?.common)
        XCTAssertNil(mockCountry?.flag)
    }

    func test_CountryFlagVM_addCountrySuccessful() async throws {
        // Given
        mockCountry = CountryData(flag: "🇮🇱", name: NameDetails(common: "Israel"), identifierInt: "100", objectIdString: Utils.generate24HexDigitString())
        var countries: [CountryData] = []
        if let mockCountry {
            vm = CountryFlagVM(country: mockCountry)
        }

        // When
        let expectation = expectation(description: "Add country to Realm")
        do {
            countries = try await RealmManager.shared.fetchRealmCountries()
            expectation.fulfill()
            
            // Then
            await fulfillment(of: [expectation], timeout: 5.0, enforceOrder: true)
            XCTAssertFalse(countries.isEmpty)
            XCTAssertTrue(countries.contains(where: { $0.flag == mockCountry?.flag }))
            XCTAssertTrue(countries.contains(where: { $0.name?.common == mockCountry?.name?.common }))
            XCTAssertGreaterThan(countries.count, 0)
        } catch {
            XCTFail("Adding country failed with error: \(error)")
        }
    }
}
