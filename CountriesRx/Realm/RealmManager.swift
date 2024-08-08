//
//  RealmManager.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    private let realm: Realm? = {
        do {
            let rlm = try Realm()
            return rlm
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    private init() {}
    
    func addCountry(_ country: CountryData) async throws {
        let realmCountry = convertToRealmCountryData(country)
        
        do {
            if let realm {
                try realm.write {
                    realm.add(realmCountry)
                    print("\(realmCountry.name?.common ?? "") added successfully to saved list")
                }
            } else {
                print("Realm is nil")
            }
        } catch {
            print("\(realmCountry.name?.common ?? "") added successfully to saved list")
            throw error
        }
    }
    
    func fetchFavoriteCountries() async -> [CountryData] {
        do {
            guard let realmCountries = realm?.objects(CountryData.self) else {
                return []
            }
            
            let countriesArray = Array(realmCountries).map { convertToCodableCountryData($0) }
            return countriesArray
        }
    }
    
    private func convertToCodableCountryData(_ realmCountryData: CountryData) -> CountryData {
        let nameDetails = realmCountryData.name.map { NameDetails(common: $0.common) }
        return CountryData(name: nameDetails, flag: realmCountryData.flag)
    }
    
    private func convertToRealmCountryData(_ countryData: CountryData) -> CountryData {
        let realmCountryData = CountryData()
        realmCountryData.flag = countryData.flag
        
        if let nameDetails = countryData.name {
            let realmNameDetails = NameDetails()
            realmNameDetails.common = nameDetails.common
            realmCountryData.name = realmNameDetails
        }
        
        return realmCountryData
    }
}
