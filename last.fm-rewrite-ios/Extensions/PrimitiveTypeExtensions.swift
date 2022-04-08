//
//  PrimitiveTypeExtensions.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 08.04.2022..
//

import Foundation


extension Int {
    
    //MARK: - Rounded value
    
    var stringValue: String {
        return String(self)
    }
    
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
}
