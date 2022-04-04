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
            return  URL.init(string: "http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums")!
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
            return .requestParameters(parameters: ["tag" : RecordTags.disco.rawValue, "api_key" : apiKey, "format": FormatType.json.rawValue, "limit" : defaultFetchLimit], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [String : String]()
    }

}

extension Network {
    
    //MARK: - Fetching

    fileprivate static let provider = MoyaProvider<Network>()
    
    func fetch(completion:@escaping Moya.Completion) -> Cancellable {
        return Network.provider.request(self) { (result) in
            completion(result)
        }
    }
}

extension Moya.Response {
    
    func records() throws -> RecordsResponse {
        return try JSONDecoder().decode(RecordsResponse.self, from: data)
    }
    
}

extension Network {
    
    fileprivate enum FormatType: String {
        case json
        case xml
    }
    
    fileprivate enum RecordTags: String, CaseIterable {
        case disco
    }
}
