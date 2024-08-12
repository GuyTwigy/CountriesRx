//
//  CountryData.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation
import RealmSwift

class RealmCountryData: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId?
    @Persisted var identifierInt: String?
    @Persisted var flag: String? = nil
    @Persisted var realmName: String?
    
    convenience init(_id: ObjectId, identifierInt: String?, flag: String? = nil, realmName: String?) {
        self.init()
        self._id = _id
        self.identifierInt = identifierInt
        self.flag = flag
        self.realmName = realmName
    }
}

class CountryData: Codable, Equatable {
    static func == (lhs: CountryData, rhs: CountryData) -> Bool {
        return lhs.name?.common == rhs.name?.common
    }
    
    var name: NameDetails? = nil
    var flag: String? = nil
    var identifierInt: String?
    var objectIdString: String?
    
    init(flag: String?, name: NameDetails?, identifierInt: String?, objectIdString: String?) {
        self.name = name
        self.flag = flag
        self.identifierInt = identifierInt
        self.objectIdString = objectIdString
    }
}

class NameDetails: Codable, Equatable {
    static func == (lhs: NameDetails, rhs: NameDetails) -> Bool {
        return lhs.common == rhs.common
    }
    
    var common: String? = nil
    
    init(common: String? = nil) {
        self.common = common
    }
}
