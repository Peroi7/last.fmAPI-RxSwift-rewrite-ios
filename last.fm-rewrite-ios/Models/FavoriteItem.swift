//
//  FavoriteItem.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 10.04.2022..
//

import Foundation

//MARK: - FavoriteItem

struct FavoriteItem: Codable {
    
    let record: Record
    let details: RecordDetail?
    
    init(record: Record, details: RecordDetail?) {
        self.record = record
        self.details = details
    }
}

extension FavoriteItem: Equatable {
    
    static func == (lhs: FavoriteItem, rhs: FavoriteItem) -> Bool {
        return lhs.record == rhs.record && lhs.details == rhs.details
    }
}
