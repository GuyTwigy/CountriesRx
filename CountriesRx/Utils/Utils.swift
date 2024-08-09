//
//  Utils.swift
//  CountriesRx
//
//  Created by Guy Twig on 09/08/2024.
//

import Foundation

class Utils {
    
    static func generate24HexDigitString() -> String {
        let length = 24
        let characters = "0123456789abcdef"
        var result = ""
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            result.append(character)
        }
        
        return result
    }
}
