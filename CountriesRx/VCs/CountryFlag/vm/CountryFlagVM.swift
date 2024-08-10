//
//  CountryFlagVM.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
import RealmSwift

class CountryFlagVM {
    
    init(country: CountryData) {
        Task {
            await addCountry(newCountry: country)
        }
    }
    
    func addCountry(newCountry: CountryData) async {
        
        do {
            let realmCountries = try await RealmManager.shared.fetchRealmCountries()
            let newObjectId = try ObjectId(string: Utils.generate24HexDigitString())
            if !realmCountries.contains( where: { $0.name?.common == newCountry.name?.common }) && !realmCountries.contains( where: { $0.objectIdString == newObjectId.stringValue }) {
                let countryWithId = RealmCountryData(_id: newObjectId, identifierInt: "\((Int(realmCountries.last?.identifierInt ?? "0") ?? 0) + 1)", flag: newCountry.flag, realmName: newCountry.name?.common)
                
                do {
                    try await RealmManager.shared.addCountry(newCountry: countryWithId)
                    print("\(countryWithId.realmName ?? "") added successfully to saved list")
                } catch {
                    print("Fail to add country to fav list, error: \(error.localizedDescription)")
                }
            } else {
                print("\(newCountry.name?.common ?? "") Already added or same objectId")
            }
        } catch {
            print("Fail to fetch fav list, error: \(error.localizedDescription)")
        }
    }
}

