//
//  RealmManager.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import RealmSwift
import Foundation

@MainActor
class RealmManager: ObservableObject {

    static let shared = RealmManager()
    
    private let app = App(id: "application-countriesrx-dlsznei")
    private var realm: Realm?
    @Published var user: User?
    @Published var countries: Results<RealmCountryData>?

    init(realm: Realm? = nil) {
        self.realm = realm
    }
    
    func initializeUser() async throws {
        if let currentUser = app.currentUser {
            user = currentUser
        } else {
            user = try await app.login(credentials: .anonymous)
        }
        
        guard user != nil else {
            throw NSError(domain: "RealmManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to log in or find a user"])
        }
    }
    
    private func initializeRealm() async throws {
        try await initializeUser()
        if realm == nil {
            var config = Realm.Configuration()
            config.objectTypes = [RealmCountryData.self]
            realm = try await Realm(configuration: config)
            print("Successfully initialized local Realm")
        }
    }
    
    func fetchRealmCountries() async throws -> [CountryData] {
        try await initializeRealm()
        guard let realm else {
            return []
        }
        
        let fetchedCountries = realm.objects(RealmCountryData.self)
        let newCountryArray = fetchedCountries.map { CountryData(flag: $0.flag, name: NameDetails(common: $0.realmName), identifierInt: $0.identifierInt, objectIdString: $0._id?.stringValue) }
        let sortedCountryArray = newCountryArray.sorted { country1, country2 in
            guard let id1 = Int(country1.identifierInt ?? ""),
                  let id2 = Int(country2.identifierInt ?? "") else {
                return false
            }
            return id1 > id2
        }
        
        return sortedCountryArray
    }
    
    func addCountry(newCountry: RealmCountryData) async throws {
        try await initializeRealm()
        
        guard let realm else { 
            return
        }
        
        try realm.write {
            realm.add(newCountry)
            print("\(newCountry.realmName ?? "") added successfully to saved list")
        }
    }
}
