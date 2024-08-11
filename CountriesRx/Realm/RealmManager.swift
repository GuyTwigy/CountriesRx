//
//  RealmManager.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import RealmSwift
import Foundation

class RealmManager: ObservableObject {
    
    static let shared = RealmManager()
        
        private let app = App(id: "application-countriesrx-dlsznei")
        var realm: Realm?
        @Published var user: User?
        @Published var countries: Results<RealmCountryData>?
        
        private init() {
            Task {
                try await initialRealm()
            }
        }
        
    func initialRealm() async throws {
        do {
            if let currentUser = app.currentUser {
                user = currentUser
            } else {
                user = try? await app.login(credentials: .anonymous)
            }
            
            guard let _ = user else {
                throw NSError(domain: "RealmManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to log in or find a user"])
            }
            
            var config = Realm.Configuration()
            config.objectTypes = [RealmCountryData.self]
            realm = try await Realm(configuration: config)
            print("Successfully initialized local Realm")
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
            throw error
        }
    }
    
    func addCountry(newCountry: RealmCountryData) async throws {
        do {
            if let realm = realm {
                try realm.write {
                    realm.add(newCountry)
                    print("\(newCountry.realmName ?? "") added successfully to saved list")
                }
            } else {
                try await initialRealm()
                try await addCountry(newCountry: newCountry)
            }
        } catch {
            print("Failed to save \(newCountry.realmName ?? ""): \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchRealmCountries() async throws -> [CountryData] {
        do {
            if let realm = realm {
                countries = realm.objects(RealmCountryData.self).sorted(byKeyPath: "identifierInt")
                
                guard let countries = countries else { return [] }
                
                let newCountryArray = countries.map { CountryData(flag: $0.flag, name: NameDetails(common: $0.realmName), identifierInt: $0.identifierInt, objectIdString: $0._id?.stringValue) }
                
                let sortedCountryArray = newCountryArray.sorted { country1, country2 in
                    guard let id1 = Int(country1.identifierInt ?? ""),
                          let id2 = Int(country2.identifierInt ?? "") else {
                        return false
                    }
                    return id1 > id2
                }
                
                return sortedCountryArray
            } else {
                try await initialRealm()
                return try await fetchRealmCountries()
            }
        } catch {
            print("Failed to fetch countries: \(error.localizedDescription)")
            throw error
        }
    }
}
