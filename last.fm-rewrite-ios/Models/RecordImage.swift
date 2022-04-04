//
//  RecordImage.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import Foundation

//MARK: - RecordsImage

struct RecordImage: Codable {
    
    fileprivate enum ImageSizeUrl: String {
        case small
        case medium
        case large
    }
    
    let url: String
    let size: String
    
    fileprivate enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        size = try container.decode(String.self, forKey: .size)
    }
}
