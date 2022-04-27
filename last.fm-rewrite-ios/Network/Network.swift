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
    case artistSearchResults(artist: String)
    case artistDetails(artist: String)
    case artistTopRecords(artist: String)
    
    fileprivate var apiKey: Any {
        return Bundle.main.propertyValue(resource: "NetworkData", key: "api_key")
    }
    
    static func api(type: Network) -> Network? {
        switch type {
        case .recordDetails(let tag):
            return recordDetails(tag: tag)
        case .recordDetailsExtended(let artist, let album):
            return recordDetailsExtended(artist: artist, album: album)
        case .artistSearchResults(artist: let artist):
            return artistSearchResults(artist: artist)
        case .artistDetails(artist: let artist):
            return .artistDetails(artist: artist)
        case .artistTopRecords(artist: let artist):
            return .artistTopRecords(artist: artist)
        }
    }
}

extension Network: TargetType {
    
    //MARK: - Network Configuration
    
    var baseURL: URL {
        switch self {
        case .recordDetails, .recordDetailsExtended, .artistSearchResults, .artistDetails, .artistTopRecords:
            return URL.withQuery(baseURL: "http://ws.audioscrobbler.com/2.0/", queryName: "method", value: queryValue)
        }
    }
    
    var queryValue: String {
        switch self {
        case .recordDetails:
            return "tag.gettopalbums"
        case .recordDetailsExtended:
            return "album.getinfo"
        case .artistSearchResults:
            return "artist.search"
        case .artistDetails:
            return "artist.getinfo"
        case .artistTopRecords:
            return "artist.gettopalbums"
        }
    }
    
    var path: String {
        switch self {
        case .recordDetails, .recordDetailsExtended,.artistSearchResults, .artistDetails, .artistTopRecords:
            return ""
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .recordDetails, .recordDetailsExtended, .artistSearchResults, .artistDetails, .artistTopRecords:
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
        case .artistSearchResults(artist: let artist), .artistDetails(artist: let artist), .artistTopRecords(artist: let artist):
            let parameters = ["artist" : artist,
                              "api_key" : apiKey,
                              "format" : FormatType.json,
                              "limit" : 20
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
    
    func mapSearchResults() throws -> SearchResultsResponse {
        return try JSONDecoder().decode(SearchResultsResponse.self, from: data)
    }
    
    func mapArtistInfoResponse() throws -> ArtistInfoResponse {
        return try JSONDecoder().decode(ArtistInfoResponse.self, from: data)
    }
    
    func mapArtistTopRecords() throws -> ArtistTopRecordsResponse {
        return try JSONDecoder().decode(ArtistTopRecordsResponse.self, from: data)
    }
    
    
}

//MARK: - Format Type

extension Network {
    
    fileprivate enum FormatType: String {
        case json
        case xml
    }
}

