//
//  Record.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit

//MARK: - Record

struct Record: Codable {
    
    let name: String
    let artist: Artist
    let image: [RecordImage]
    
    var imageURL: URL? {
        if let img = image.first(where: {$0.size == ImageSizeUrl.large.rawValue}) {
            return URL(string: img.url)
        } else {
            return nil
        }
    }
    
    var savedImage: UIImage {
        if let imageData = UserDefaults.standard.value(forKey: ident) as? Data {
            if let image = UIImage(data: imageData) {
                return image
            }
        }
        return UIImage()
    }
}

extension Record {
    
    //MARK: - Id
    //need to generate fake id because lot of albums don’t contain any id
    
    var ident: String {
        return "last_fm_record_\(name)"
    }
}

extension Record {
    
    //MARK: - Favorites
    
    var isFavorite: Bool {
        
        let favorites = FavoritesDataLoader.favorites
        for item in favorites {
            if item.record.ident == ident {
                return true
            }
        }
        return false
    }
}

//MARK: - Equatable

extension Record: Hashable {
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.name == rhs.name && lhs.artist == rhs.artist && lhs.image == rhs.image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(artist)
        hasher.combine(image)
        
    }
}
