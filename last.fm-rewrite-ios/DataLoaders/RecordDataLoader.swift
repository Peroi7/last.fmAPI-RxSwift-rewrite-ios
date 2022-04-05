//
//  RecordDataLoader.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 05.04.2022..
//

import UIKit
import ProgressHUD

class RecordsDataLoader: BaseDataLoader<Record> {
    
    override func loadItems() {
        guard let api = Network.api(type: .recordDetails) else { return }
        
        isLoading.accept(true)
        
        request = api.fetch(completion: {[weak self] result in
            guard let uSelf = self else { return }
            switch result {
            case .success(let value):
                do {
                    let records = try value.mapRecordsResponse()
                    uSelf.items.accept(records.records.topRecords)
                    uSelf.isLoading.accept(false)
                    uSelf.errorOccured?(false)
                    
                } catch let error {
                    print("Failed to fetch top records: \(error.localizedDescription)")
                    uSelf.errorOccured?(true)
                }
                
            case .failure(_):
                uSelf.errorOccured?(true)
                print("error")
            }
        })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isLoading.value {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } else {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading.value ? 1 : items.value.count
    }
    
    override var baseCellIdentifier: String { return "RecordCellIdentifier"}
    
    override func setupCollectionView(collectionView: UICollectionView) {
        super.setupCollectionView(collectionView: collectionView)
        collectionView.register(RecordCollectionViewCell.nib, forCellWithReuseIdentifier: baseCellIdentifier)
        collectionView.register(LoadingCell.nib, forCellWithReuseIdentifier: loadingCellIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isLoading.value {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loadingCellIdentifier, for: indexPath) as! LoadingCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseCellIdentifier, for: indexPath) as! RecordCollectionViewCell
            configCell(cell: cell, indexPath: indexPath)
            return cell
            
        }
        
    }
    
    override func configCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        super.configCell(cell: cell, indexPath: indexPath)
        
        if let uRecordCell = cell as? RecordCollectionViewCell {
            let uItem = item(indexPath: indexPath)
            uRecordCell.record = uItem
        }
    }
    
}
