//
//  RealmManager.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    
    static let shared = RealmManager()
    
    let app = App(id: "application-countriesrx-dlsznei")
    var realm: Realm?
    @Published var user: User?
    @Published var countries: Results<RealmCountryData>?
    @Published var configuration: Realm.Configuration?
    
    private init() {
        Task {
            try await initialRealm()
        }
    }
    
    func initialRealm() async throws {
        do {
            user = try? await app.login(credentials: Credentials.anonymous)
            configuration = user?.flexibleSyncConfiguration(initialSubscriptions: { subscriptions in
                if subscriptions.first(named: "all-Countries") == nil {
                    subscriptions.append(QuerySubscription<RealmCountryData>(name: "all-Countries"))
                }
                
            }, rerunOnOpen: true)
            if let configuration {
                realm = try await Realm(configuration: configuration, downloadBeforeOpen: .always)
                print("connected succesfuly realm")
            }
        } catch {
            print("Fail to connect with realm")
        }
    }
    
    func addCountry(newCountry: RealmCountryData) async throws {
        do {
            if let realm {
                try realm.write({
                    realm.add(newCountry)
                    print("\(newCountry.realmName ?? "") added successfully to saved list")
                })
            } else {
                try await initialRealm()
                try await addCountry(newCountry: newCountry)
            }
        } catch {
            print("\(newCountry.realmName ?? "") Fail to saved")
            throw error
        }
    }
    
    func fetchRealmCountries() async throws -> [CountryData] {
        do {
            if let realm {
                countries = realm.objects(RealmCountryData.self).sorted(byKeyPath: "identifierInt", ascending: false)
                if let countries {
                    var newCountryArray: [CountryData] = []
                    let countriesArray = Array(countries)
                    countriesArray.forEach { newCountryArray.append(CountryData(flag: $0.flag, name: NameDetails(common: $0.realmName), identifierInt: $0.identifierInt, objectIdString: $0._id?.stringValue))
                    }
                    return newCountryArray
                } else {
                    return []
                }
            } else {
                try await initialRealm()
                return try await fetchRealmCountries()
            }
        }
    }
}
