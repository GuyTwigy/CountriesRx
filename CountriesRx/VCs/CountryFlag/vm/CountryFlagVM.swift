//
//  CountryFlagVM.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
import RealmSwift

import RealmSwift

class CountryFlagVM {
    
    init(country: CountryData) {
        Task {
            await addCountry(newCountry: country)
        }
    }
            
    func addCountry(newCountry: CountryData) async {
        do {
            let favCountries = try await RealmManager.shared.fetchFavoriteCountries()
            if !favCountries.contains(newCountry) {
                do {
                    try await RealmManager.shared.addCountry(newCountry)
                    print("\(newCountry.name?.common ?? "") added successfully to saved list")
                } catch {
                    print("Fail to add country to fav list, error: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Fail to fetch fav list, error: \(error.localizedDescription)")
        }
    }
}
