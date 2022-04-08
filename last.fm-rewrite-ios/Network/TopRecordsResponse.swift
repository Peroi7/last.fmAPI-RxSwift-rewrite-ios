//
//  TopRecordsResponse.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import Foundation

//MARK: - TopRecordsResponse

struct TopRecordsResponse: Codable {
    
    let topRecords: [Record]
    
    private enum CodingKeys: String, CodingKey {
        case topRecords = "album"
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        topRecords = try container.decode([Record].self, forKey: .topRecords)
    }
}
   
