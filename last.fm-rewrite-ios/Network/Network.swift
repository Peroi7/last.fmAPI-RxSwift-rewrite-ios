//
//  ServerAPI.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import Foundation
import Moya


enum Network {
    
    //MARK: - Network
    
    case recordDetails(tag: String)
    case recordDetailsExtended(artist: String, album: String)
    
    fileprivate var apiKey: Any {
        return Bundle.main.propertyValue(resource: "NetworkData", key: "api_key")
    }
    
    static func api(type: Network) -> Network? {
        switch type {
        case .recordDetails(let tag):
            return recordDetails(tag: tag)
        case .recordDetailsExtended(let artist, let album):
            return recordDetailsExtended(artist: artist, album: album)
        }
    }
}

extension Network: TargetType {
    
    //MARK: - Network Configuration
    
    var baseURL: URL {
        switch self {
        case .recordDetails, .recordDetailsExtended:
            return URL.withQuery(baseURL: "http://ws.audioscrobbler.com/2.0/", queryName: "method", value: queryValue)
        }
    }
    
    var queryValue: String {
        switch self {
        case .recordDetails:
            return "tag.gettopalbums"
        case .recordDetailsExtended:
            return "album.getinfo"
        }
    }
    
    var path: String {
        switch self {
        case .recordDetails, .recordDetailsExtended:
            return ""
        }
    
    }
    
    var method: Moya.Method {
        switch self {
        case .recordDetails, .recordDetailsExtended:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case.recordDetails(let tag):
            let parameters = ["tag": tag,
                              "api_key" : apiKey,
                              "format" : FormatType.json,
                              "limit" : Constants.itemsPerPage
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .recordDetailsExtended(let artist, let album):
            let parameters = ["artist": artist,
                              "album" : album,
                              "api_key" : apiKey,
                              "format" : FormatType.json
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [String : String]()
    }
    
}

extension Network {
    
    //MARK: - Fetching
    
    fileprivate static let provider = MoyaProvider<Network>(plugins: [NetworkLoggerPlugin()])
        
    func fetch(completion:@escaping Moya.Completion) -> Cancellable {
        return Network.provider.request(self) { (result) in
            completion(result)
        }
    }
}

//MARK: - Response Types

extension Moya.Response {
    
    func mapRecordsResponse() throws -> RecordsResponse {
        return try JSONDecoder().decode(RecordsResponse.self, from: data)
    }
    
    func mapRecordDetailsExtended() throws -> RecordDetailsResponse {
        return try JSONDecoder().decode(RecordDetailsResponse.self, from: data)
    }
    
}

//MARK: - Format Type

extension Network {
    
    fileprivate enum FormatType: String {
        case json
        case xml
    }
}

