//
//  UserDefaultsExtensions.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 11.04.2022..
//

import Foundation

extension UserDefaults {
    
    func setData<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func getData<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
    
    func clearDefaults(keys: [String]) {
        keys.forEach({self.removeObject(forKey: $0)})
    }
}
