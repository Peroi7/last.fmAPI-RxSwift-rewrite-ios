//
//  RecordDetail.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 07.04.2022..
//

import Foundation

//MARK: - Record Details

struct RecordDetail: Codable, Equatable {
    
    let playcount: String
    let listeners: String
    let topTracks: TopTracks?
    let wiki: Wiki?
    
    private enum CodingKeys: String, CodingKey {
        case topTracks = "tracks"
        case wiki
        case listeners
        case playcount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topTracks = try container.decodeIfPresent(TopTracks.self, forKey: .topTracks)
        self.wiki = try container.decodeIfPresent(Wiki.self, forKey: .wiki)
        self.playcount = try container.decode(String.self, forKey: .playcount)
        self.listeners = try container.decode(String.self, forKey: .listeners)
    }
    
}

struct Wiki: Codable, Equatable {
    let published: String
}

struct Track: Codable, Equatable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct TopTracks: Codable, Equatable {
    
    let tracks: [Track]
    
    private enum CodingKeys: String, CodingKey {
        case tracks = "track"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tracks = try container.decodeIfPresent([Track].self, forKey: .tracks) ?? []
    }
}

