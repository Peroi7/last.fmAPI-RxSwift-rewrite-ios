//
//  RecordTags.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 05.04.2022..
//

import Foundation

enum RecordTag: String, CaseIterable {
    case pop
    case hiphop
    case rock
    case indie
    case disco
    case dance
    case electronic
    case alternative
    case trap
    case rap
    //Available to fetch, but this time we I will leave it so
    
    static var usedTags: [RecordTag] = []
    
    static func generateNextTag() -> RecordTag? {
        let nextTag = RecordTag.allCases.filter{!RecordTag.usedTags.contains($0)}.randomElement()
        return usedTags.isEmpty ? .pop : nextTag
    }
    
}
