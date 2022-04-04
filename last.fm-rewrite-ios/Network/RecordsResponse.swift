//
//  RecordsResponsw.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import Foundation

//MARK: - RecordsResponse

struct RecordsResponse: Codable {
    
    let records: TopRecordsResponse
    
    private enum CodingKeys: String, CodingKey {
        case records = "albums"
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        records = try container.decode(TopRecordsResponse.self, forKey: .records)
    }
}
     

