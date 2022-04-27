//
//  SarchResultsResponse.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 20.04.2022..
//

import Foundation

//MARK: - SearchResultsResponse

struct SearchResultsResponse: Codable {
    
    let results: SearchResultsArtistResponse
}

struct SearchResultsArtistResponse: Codable {
    
    let artistResults: SearchResultsArtistEndResponse
    
    private enum CodingKeys: String, CodingKey {
        case artistResults = "artistmatches"
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        artistResults = try container.decode(SearchResultsArtistEndResponse.self, forKey: .artistResults)
    }
}

struct SearchResultsArtistEndResponse: Codable {
    
    let artist: [Artist]
}
