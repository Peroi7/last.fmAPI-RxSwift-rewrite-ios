//
//  Artist.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import Foundation

//MARK: - Artist

struct Artist: Codable {
    
    let name: String
    let ident: String
    
    private enum CodingKeys: String, CodingKey {
        case ident = "mbid"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ident = try container.decode(String.self, forKey: .ident)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

//MARK: - Hashable

extension Artist: Equatable {
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.name == rhs.name && lhs.ident == rhs.ident
    }
}


