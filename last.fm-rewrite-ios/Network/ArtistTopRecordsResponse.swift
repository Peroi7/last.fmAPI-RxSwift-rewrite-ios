//
//  ArtistTopRecordsResponse.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 27.04.2022..
//

import Foundation

//MARK: - ArtistTopRecordsResponse

struct ArtistTopRecordsResponse: Codable {
    
    let topAlbums: TopRecordsResponse
    
    private enum CodingKeys: String, CodingKey {
        case topAlbums = "topalbums"
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        topAlbums = try container.decode(TopRecordsResponse.self, forKey: .topAlbums)
    }
}
