//
//  RealmManagerTests.swift
//  CountriesRxTests
//
//  Created by Guy Twig on 12/08/2024.
//

import XCTest
import RealmSwift
@testable import CountriesRx

@MainActor
final class RealmManagerTests: XCTestCase {

    var realmManager: RealmManager?
    var inMemoryRealm: Realm?

    override func setUpWithError() throws {
        inMemoryRealm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        realmManager = RealmManager(realm: inMemoryRealm)
    }

    override func tearDownWithError() throws {
        try inMemoryRealm?.write {
            inMemoryRealm?.deleteAll()
        }
        inMemoryRealm = nil
        realmManager = nil
    }

    func test_RealmManager_addCountry() async throws {
        // Given
        let newCountry = RealmCountryData()
        newCountry.realmName = "TestCountry"
        newCountry._id = try ObjectId(string: Utils.generate24HexDigitString())
        
        // When
        try await realmManager?.addCountry(newCountry: newCountry)
        
        // Then
        let countries = inMemoryRealm?.objects(RealmCountryData.self)
        XCTAssertEqual(countries?.count, 1)
    }
    
    func test_RealmManager_fetchRealmCountries() async throws {
        // Given
        let newCountry1 = RealmCountryData()
        newCountry1.identifierInt = "100"
        newCountry1._id = try ObjectId(string: Utils.generate24HexDigitString())
        let newCountry2 = RealmCountryData()
        newCountry2.identifierInt = "101"
        newCountry2._id = try ObjectId(string: Utils.generate24HexDigitString())
        
        try await realmManager?.addCountry(newCountry: newCountry1)
        try await realmManager?.addCountry(newCountry: newCountry2)
        
        // When
        let countries = try await realmManager?.fetchRealmCountries()
        
        // Then
        XCTAssertEqual(countries?.count, 2)
        XCTAssertEqual(countries?.first?.identifierInt, "101")
        XCTAssertEqual(countries?[1].identifierInt, "100")
    }
}
