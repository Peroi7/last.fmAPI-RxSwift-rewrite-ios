//
//  URLExtensions.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 04.04.2022..
//

import Foundation

extension URL {
    
    //MARK: - QueryItem

    static func withQuery(baseURL: String, queryName: String, value: String?) -> URL {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [URLQueryItem(name: queryName, value: value)]
        return urlComponents?.url ?? URL(fileURLWithPath: "")
    }
}
