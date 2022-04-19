//
//  RecordDetailsDataLoader.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 07.04.2022..
//

import Foundation
import RxCocoa
import RxSwift


class RecordDetailsDataLoader: BaseDataLoader<RecordDetail> {
        
    enum DetailsLoaderType {
        case api
        case fromDisk
        case cached
    }
    
    func loadDetails<T>(item: T, type: DetailsLoaderType) {
        switch type {
        case .api:
            guard let item = item as? Record else { return }
            
            guard let api = Network.api(type: .recordDetailsExtended(artist: item.artist.name, album: item.name)) else  { return }
            
            isLoading.accept(true)
            
            request = api.fetch(completion: {[weak self] result in
                guard let uSelf = self else { return }
                switch result {
                case .success(let value):
                    do {
                        let recordDetails = try value.mapRecordDetailsExtended()
                        let items = [recordDetails.record]
                        uSelf.items.accept(items)
                        uSelf.isLoading.accept(false)
                        
                    } catch let error {
                        print("Failed to fetch details: \(error.localizedDescription)")
                        uSelf.errorOccured?(true)
                    }
                    
                case .failure(_):
                    uSelf.errorOccured?(true)
                }
            })
            
        case .fromDisk, .cached:
            if let favoriteItem = FavoritesDataLoader.favorites.first(where: {$0.record == item as? Record})?.details {
                self.items.append(favoriteItem)
            }
        }
    }
}

