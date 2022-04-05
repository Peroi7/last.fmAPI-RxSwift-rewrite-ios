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
    
    case recordDetails
    
    fileprivate var apiKey: Any {
        return Bundle.main.propertyValue(resource: "NetworkData", key: "api_key")
    }
    
    fileprivate var defaultFetchLimit: Int {
        return 20
    }
    
    static func api(type: Network) -> Network? {
        switch type {
        case .recordDetails:
            return recordDetails
        }
    }
}

extension Network: TargetType {
    
    //MARK: - Network Configuration
    
    var baseURL: URL {
        switch self {
        case .recordDetails:
            return URL.withQuery(baseURL: "http://ws.audioscrobbler.com/2.0/", queryName: "method", value: queryValue)
        }
    }
    
    var queryValue: String {
        switch self {
        case .recordDetails:
            return "tag.gettopalbums"
        }
    }
    
    var path: String {
        switch self {
        case .recordDetails:
            return ""
        }
    
    }
    
    var method: Moya.Method {
        switch self {
        case .recordDetails:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case.recordDetails:
            let parameters = ["tag": RecordTags.disco,
                              "api_key" : apiKey,
                              "format" : FormatType.json,
                              "limit" : defaultFetchLimit
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
    
}

//MARK: - Format/Record Type

extension Network {
    
    fileprivate enum FormatType: String {
        case json
        case xml
    }
    
    fileprivate enum RecordTags: String, CaseIterable {
        case disco
    }
}
