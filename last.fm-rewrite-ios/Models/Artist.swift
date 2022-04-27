//
//  Artist.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit

//MARK: - Artist

struct Artist: Codable {
    
    let name: String
    let ident: String
    let image: [RecordImage]
    let info: ArtistInfo
    let artistBio: ArtistBio
    let tags: ArtistTag
    var topTracks: [Track] = []
    
    init() {
        name = ""
        ident = ""
        image = []
        info = .init()
        artistBio = .init()
        tags = .init()
    }
    
    private enum CodingKeys: String, CodingKey {
        case ident = "mbid"
        case name
        case image
        case info = "stats"
        case artistBio = "bio"
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ident = try container.decode(String.self, forKey: .ident)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decodeIfPresent([RecordImage].self, forKey: .image) ?? []
        self.info = try container.decodeIfPresent(ArtistInfo.self, forKey: .info) ?? .init()
        self.artistBio = try container.decodeIfPresent(ArtistBio.self, forKey: .artistBio) ?? .init()
        self.tags = try container.decodeIfPresent(ArtistTag.self, forKey: .tags) ?? .init()

    }
    
    var defaultArtistImage: UIImage {
        return UIImage(named: "lastfm") ?? .init()
    }
}

//MARK: - Hashable

extension Artist: Equatable {
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.name == rhs.name && lhs.ident == rhs.ident
    }
}

struct ArtistInfo: Codable {
    
    let listeners: String?
    let playcount: String?
    
    init() {
        listeners = nil
        playcount = nil
    }
    
}

struct ArtistBio: Codable {
    
    let published: String?
    let summary: String?
    let content: String?
    
    init() {
        published = ""
        summary = ""
        content = ""
    }
}

struct ArtistTag: Codable {
    
    let itemTags: [Tag]?
    
    init() {
        itemTags = []
    }
    
    private enum CodingKeys: String, CodingKey {
        case itemTags = "tag"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.itemTags = try container.decode([Tag].self, forKey: .itemTags)
    }
}

struct Tag: Codable {
    
    let name: String
}
