//
//  Record.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import Foundation

//MARK: - Record

struct Record: Codable {
    
    let name: String
    let artist: Artist
    let image: [RecordImage]
    
    var imageURL: URL? {
        if let img = image.first(where: {$0.size == ImageSizeUrl.large.rawValue}) {
            return URL(string: img.url)
        } else {
            return nil
        }
    }
}

//MARK: - Equatable

extension Record: Equatable {
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.name == rhs.name && lhs.artist == rhs.artist && lhs.image == rhs.image
    }
}
