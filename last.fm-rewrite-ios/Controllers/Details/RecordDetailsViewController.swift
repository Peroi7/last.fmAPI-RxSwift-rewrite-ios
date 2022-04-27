//
//  RecordDetailsViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 07.04.2022..
//

import UIKit
import ProgressHUD

class RecordDetailsViewController: BaseRecordDetailsViewController<RecordDetail, RecordDetailsDataLoader> {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - On Favorite
    
    override func onFavorite() {
        guard let record = item as? Record else { return }
        guard let recordDetails = dataLoader.items.value.first else { return }
        let favoriteItem = FavoriteItem.init(record: record, details: recordDetails)
        if record.isFavorite {
            FavoritesDataLoader.favorites.removeAll(where: {$0.record.ident == favoriteItem.record.ident})
        } else {
            if let image = recordImageView.image {
                convertImageToData(image: image, key: favoriteItem.record.ident)
            }
            FavoritesDataLoader.favorites.append(favoriteItem)
        }
        
        NotificationCenter.default.post(name: .didAddToFavorites, object: nil)
        setFavoriteButtonImage(animated: record.isFavorite)
    }
    
    fileprivate func convertImageToData(image: UIImage, key: String) {
        guard let imageData = image.jpegData(compressionQuality: 100.0) else { return }
        UserDefaults.standard.set(imageData, forKey: key)
    }
    
    override func expand() {
        super.reverseExpanded()
        setExpanded(isExpanded: isExpanded, animated: true, items: dataLoader.items.value.first?.topTracks?.tracks)
    }
    
    //MARK: - Config Item
    
    
    override func config(item: RecordDetail) {
        super.config(item: item)
        
        listenersLabel.recordInfoSecondLabel.text = item.listeners.intValue.roundedWithAbbreviations
        playcountLabel.recordInfoSecondLabel.text = item.playcount.intValue.roundedWithAbbreviations
        
        
        if let published = item.wiki?.published {
            recordInfoView.stackView.addArrangedSubview(publishedLabel)
            publishedLabel.recordInfoSecondLabel.text = published
            infoStackViewHeight.constant = setInfoViewStackHeight(stack: recordInfoView.stackView)
        }
        
        if let tracks = item.topTracks?.tracks {
            topTracksView.recordTrackLabel.text = tracks.first?.name
            topTracksView.alpha = 1
        }
    }
    
}


