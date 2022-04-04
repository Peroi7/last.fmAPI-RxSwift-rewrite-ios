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
        
}

