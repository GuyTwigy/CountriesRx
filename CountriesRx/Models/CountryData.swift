//
//  CountryData.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation

class CountryData: Codable {
    let name: NameDetails?
    let flag: String?
    var saved: Bool?
    
    init(name: NameDetails?, flag: String?, saved: Bool? = false) {
        self.name = name
        self.flag = flag
        self.saved = saved
    }
}

class NameDetails: Codable {
    let common: String?

    init(common: String?) {
        self.common = common
    }
}
