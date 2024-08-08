//
//  CountryData.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
import RealmSwift

class CountryData: Object, Codable {
    @objc dynamic var id: String? = nil
    @objc dynamic var name: NameDetails? = nil
    @objc dynamic var flag: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: NameDetails?, flag: String?) {
        self.init()
        self.name = name
        self.flag = flag
    }
}

class NameDetails: Object, Codable {
    @objc dynamic var id: String? = nil
    @objc dynamic var common: String? = nil
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(common: String? = nil) {
        self.init()
        self.common = common
    }
}
