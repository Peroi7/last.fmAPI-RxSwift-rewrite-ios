//
//  RecordDetailsResponse.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 07.04.2022..
//

import Foundation

//MARK: - RecordDetailsResponse

struct RecordDetailsResponse: Codable {
    
    let record: RecordDetail
    
    private enum CodingKeys: String, CodingKey {
        case record = "album"
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        record = try container.decode(RecordDetail.self, forKey: .record)
    }
}
    
