//
//  ArtistDetailsDataLoader.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 21.04.2022..
//

import Foundation
import RxCocoa

class ArtistDetailsDataLoader: BaseDataLoader<Artist> {
    
    var topTracks = BehaviorRelay<[Track]>(value: [Track]())

    override func loadItems(isPagging: Bool, title: String? = nil) {
        
        if let title = title {
            guard let api = Network.api(type: .artistTopRecords(artist: title)) else { return }
                        
            request = api.fetch(completion: {[weak self] result in
                guard let uSelf = self else { return }
                
                switch result {
                case .success(let value):
                    do {
                        let records = try value.mapArtistTopRecords()
                        let topAlbums = records.topAlbums.topRecords
                        let topTracks = topAlbums.map({Track(name: $0.name)})
                        uSelf.topTracks.accept(topTracks)
                    } catch let error {
                        print("Failed to fetch top records: \(error.localizedDescription)")
                        uSelf.errorOccured?(true)
                    }
                    
                case .failure(_):
                    uSelf.errorOccured?(true)
                }
            })
        }
    }
    
    override func loadDetails<T>(item: T) {
        guard let item = item as? Artist else { return }
        
        guard let api = Network.api(type: .artistDetails(artist: item.name)) else { return }
        
        isLoading.accept(true)
        
        request = api.fetch(completion: {[weak self] result in
            guard let uSelf = self else { return }
            switch result {
            case .success(let value):
                do {
                    let artistInfo = try value.mapArtistInfoResponse()
                    let items = [artistInfo.artist]
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
    }
    
}

