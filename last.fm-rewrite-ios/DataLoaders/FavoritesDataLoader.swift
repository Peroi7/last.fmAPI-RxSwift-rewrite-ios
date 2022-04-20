//
//  FavoritesDataLoader.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 08.04.2022..
//

import UIKit
import RxCocoa

class FavoritesDataLoader: BaseDataLoader<FavoriteItem> {
    
    var onDelete: BehaviorRelay<(String, Int)> = BehaviorRelay.init(value: ("",0))
    
    fileprivate static var keyAllFavorites = "allFavorites"
    fileprivate var favoriteCellIdentifier = "FavoriteCellIdentifier"
    override var headerTitle: String { return "No favorite added."}
        
    //MARK: - Favorites
    
   override class var favorites: [FavoriteItem] {
        get { UserDefaults.standard.getData([FavoriteItem].self, forKey:  keyAllFavorites) ?? []
        }
        set {  UserDefaults.standard.setData(encodable: newValue, forKey: keyAllFavorites)
        }
    }
    
    //MARK: - CollectionView Setup
    
    override func setupCollectionView(collectionView: UICollectionView) {
        super.setupCollectionView(collectionView: collectionView)
        collectionView.register(FavoriteRecordCollectionViewCell.nib, forCellWithReuseIdentifier: favoriteCellIdentifier)
        collectionView.register(EmptyStateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: emptyStateHeaderIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoritesDataLoader.favorites.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteCellIdentifier, for: indexPath) as! FavoriteRecordCollectionViewCell
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    override func item(indexPath: IndexPath) -> FavoriteItem {
        return FavoritesDataLoader.favorites[indexPath.item]
    }
    
    override func configCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        if let favoriteCell = cell as? FavoriteRecordCollectionViewCell {
            favoriteCell.record = item(indexPath: indexPath).record
            favoriteCell.onDelete = {[weak self] ident in
                self?.onDelete.accept((ident, indexPath.item))
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let callback = didSelect {
            callback(collectionView, indexPath, item(indexPath: indexPath))
        }
    }
    
    //MARK: - CollectionViewCell Sizing
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 86.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: emptyStateHeaderIdentifier, for: indexPath) as! EmptyStateHeaderView
        header.setupTitle(title: headerTitle)
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let emptyState = FavoritesDataLoader.favorites.isEmpty
        return emptyState ? CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height / 2) : .zero
    }
}
