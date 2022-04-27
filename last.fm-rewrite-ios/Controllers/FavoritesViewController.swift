//
//  FavoritesViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit
import RxSwift

class FavoritesViewController: BaseViewController<FavoriteItem, FavoritesDataLoader> {
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteItemAdded), name: .didAddToFavorites, object: nil)
        onFavoriteItemRemoved()
        
        dataLoader.didSelect = {[weak self] _,_, item in
            guard let uSelf = self else { return }
            let recordDetailsViewController = RecordDetailsViewController(item: item.record, type: .favorites)
            uSelf.navigationController?.pushViewController(recordDetailsViewController, animated: true)
        }
    }
    
    @objc func favoriteItemAdded() {
        collectionView.reloadData()
    }
}

extension FavoritesViewController {
    
    //MARK: - Delete Favorite Item
    
    func onFavoriteItemRemoved() {
        dataLoader.onDelete.subscribe(onNext: {[weak self] (ident, index) in
            guard let uSelf = self else { return }
            var deletionIndex = index
            guard let favoriteItem = FavoritesDataLoader.favorites.first(where: {$0.record.ident == ident}) else { return }
            uSelf.showAlertAttributed(attributedText: uSelf.generateAlertAttributed(title: favoriteItem.record.name)) { shouldRemove in
                guard !shouldRemove else {
                    if deletionIndex >= FavoritesDataLoader.favorites.count {
                        deletionIndex = FavoritesDataLoader.favorites.count - 1
                    }
                    FavoritesDataLoader.favorites.removeAll(where: {$0 == favoriteItem})
                    uSelf.collectionView.performBatchUpdates {
                        uSelf.collectionView.deleteItems(at: [.init(item: deletionIndex, section: 0)])
                    }
                    return
                }
            }
            
        }).disposed(by: disposeBag)
    }
}

extension FavoritesViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Favorites"
    }
    
}
