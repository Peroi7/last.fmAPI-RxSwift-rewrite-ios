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
}
