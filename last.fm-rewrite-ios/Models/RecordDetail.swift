//
//  RecordDetail.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 07.04.2022..
//

import Foundation


struct Wiki: Codable {
    let published: String
}

struct Track: Codable {
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

struct TopTracks: Codable {
    let track: [Track]
    
    private enum CodingKeys: String, CodingKey {
        case track
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.track = try container.decode([Track].self, forKey: .track)
    }
}

struct RecordDetail: Codable {
    
    let playCount: String
    let listeners: String
    let tracks: TopTracks?
    let wiki: Wiki?
    
    private enum CodingKeys: String, CodingKey {
        case playCount = "playcount"
        case tracks
        case wiki
        case listeners
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tracks = try container.decodeIfPresent(TopTracks.self, forKey: .tracks)
        self.wiki = try container.decodeIfPresent(Wiki.self, forKey: .wiki)
        self.playCount = try container.decode(String.self, forKey: .playCount)
        self.listeners = try container.decode(String.self, forKey: .listeners)
    }
}


