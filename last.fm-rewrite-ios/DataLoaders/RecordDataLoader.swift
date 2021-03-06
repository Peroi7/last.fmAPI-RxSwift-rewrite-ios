//
//  RecordDataLoader.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 05.04.2022..
//

import UIKit
import ProgressHUD

class RecordsDataLoader: BaseDataLoader<Record> {
    
    fileprivate let recordCellIdentifier = "RecordCellIdentifier"
    
    override func loadItems(isPagging: Bool, title: String? = nil) {
        
        var api: Network?
        
        if let title = title {
            api = Network.api(type: .artistTopRecords(artist: title))
        } else {
            guard let tag = RecordTag.generateNextTag() else { return }
            RecordTag.usedTags.append(tag)
            // fancy way not receiving duplicates & ending data
            api = Network.api(type: .recordDetails(tag: tag.rawValue))
        }
        
        isLoading.accept(true)
        
        guard let api = api else {
            return
        }
        
        request = api.fetch(completion: {[weak self] result in
            guard let uSelf = self else { return }
            
            switch result {
            case .success(let value):
                do {
                    let records = try value.mapRecordsResponse()
                    if isPagging {
                        let oldData = uSelf.items.value
                        uSelf.items.accept(oldData + records.records.topRecords)
                    } else {
                        uSelf.items.accept(records.records.topRecords)
                    }
                    
                    uSelf.isLoading.accept(false)
                    uSelf.errorOccured?(false)
                    
                } catch let error {
                    print("Failed to fetch top records: \(error.localizedDescription)")
                    uSelf.errorOccured?(true)
                }
                
            case .failure(_):
                uSelf.errorOccured?(true)
            }
        })
    }
    
    override func setupCollectionView(collectionView: UICollectionView) {
        super.setupCollectionView(collectionView: collectionView)
        collectionView.register(RecordCollectionViewCell.nib, forCellWithReuseIdentifier: recordCellIdentifier)
        collectionView.register(LoadingCell.nib, forCellWithReuseIdentifier: loadingCellIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        onPagination(indexPath: indexPath)
        
        if isLoading.value {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loadingCellIdentifier, for: indexPath) as! LoadingCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recordCellIdentifier, for: indexPath) as! RecordCollectionViewCell
            configCell(cell: cell, indexPath: indexPath)
            return cell
        }
        
    }
    
    override func onPagination(indexPath: IndexPath) {
        guard !items.value.isEmpty else { return }
        
        let scrollIndex = Int(Constants.itemsPerPage - (Constants.itemsPerPage * 2/4))
        let lastScrollItem = items.value[items.value.count - scrollIndex]
        
        if item(indexPath: indexPath) == lastScrollItem && indexPath.item == items.value.count - scrollIndex {
            self.loadItems(isPagging: true)
        }
    }
    
    override func configCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        if let recordCell = cell as? RecordCollectionViewCell {
            recordCell.record = item(indexPath: indexPath)
        }
    }
}
