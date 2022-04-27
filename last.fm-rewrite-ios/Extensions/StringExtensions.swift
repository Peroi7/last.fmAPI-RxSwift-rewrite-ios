//
//  StringExtensions.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 08.04.2022..
//

import Foundation

extension String {
    
    var intValue: Int {
        return Int(self)!
    }
}

extension String {
    
    func isBlankOrEmpty() -> Bool {

      if self.isEmpty {
          return true
      }
      return (self.trimmingCharacters(in: .whitespaces) == "")
   }
    
    func cleanString() -> String {
        // api has bad formatted description text
        if let charachterIndex = description.firstIndex(where: {$0 == "<"}) {
            let filteredString  = description.prefix(upTo: charachterIndex)
            return String(filteredString)
        } else {
            return ""
        }
    }
    
}

extension Array where Element == Tag {
    
    func allJoined() -> String {
        return map { (tag) -> String in
            return String(tag.name)
        }.joined(separator: ", ")
    }

}
