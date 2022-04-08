//
//  CollectionExtensions.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 06.04.2022..
//

import Foundation

//MARK: - Unique Elements

extension Array where Element: Equatable {
    func uniqueElements() -> [Element] {
        var out = [Element]()
        
        for element in self {
            if !out.contains(element) {
                out.append(element)
            }
        }
        
        return out
    }
}
