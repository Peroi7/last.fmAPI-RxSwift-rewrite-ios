//
//  RecordDetailsViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 07.04.2022..
//

import UIKit

class RecordDetailsViewController: BaseRecordDetailsViewController<RecordDetail, RecordDetailsDataLoader> {
    
    fileprivate (set) var isExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - On Favorite
    
    override func onFavorite() {
        let isFavorite = record.isFavorite
        guard let recordDetails = dataLoader.items.value.first else { return }
        let favoriteItem = FavoriteItem.init(record: record, details: recordDetails)
        if isFavorite {
            FavoritesDataLoader.favorites.removeAll(where: {$0.record.ident == favoriteItem.record.ident})
        } else {
            if let image = recordImageView.image {
                convertImageToData(image: image, key: favoriteItem.record.ident)
            }
            FavoritesDataLoader.favorites.append(favoriteItem)
        }
        
        if !isFavorite {
            NotificationCenter.default.post(name: .didAddToFavorites, object: nil)
        }
        
        setFavoriteButtonImage(animated: isFavorite)
    }
    
    fileprivate func convertImageToData(image: UIImage, key: String) {
        guard let imageData = image.jpegData(compressionQuality: 100.0) else { return }
        UserDefaults.standard.set(imageData, forKey: key)
    }
    
    override func expand() {
        isExpanded = !isExpanded
        setExpanded(isExpanded: isExpanded, animated: true)
    }
    
    //MARK: - Config Item
    
    override func config(item: Any) {
        super.config(item: item)
        
        guard let item = item as? RecordDetail else {
            return
        }
        
        recordInfoView.stackView.addArrangedSubview(listenersLabel)
        recordInfoView.stackView.addArrangedSubview(playcountLabel)
        
        listenersLabel.recordInfoSecondLabel.text = item.listeners.intValue.roundedWithAbbreviations
        playcountLabel.recordInfoSecondLabel.text = item.playcount.intValue.roundedWithAbbreviations
        
        infoStackViewHeight.constant = setInfoViewStackHeight(stack: recordInfoView.stackView)
        
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
    
    fileprivate func setInfoViewStackHeight(stack: UIStackView) -> CGFloat {
        return CGFloat(stack.arrangedSubviews.count) * Constants.detailInfoViewItemSize
    }
    
    //MARK: - Expand Top Tracks
    
    func setExpanded(isExpanded: Bool, animated: Bool) {
        guard let uItems = dataLoader.items.value.first?.topTracks?.tracks else { return }
        
        if isExpanded {
            for uItem in uItems[1..<uItems.count] {
                let viewItem = UILabel()
                viewItem.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
                viewItem.text = uItem.name
                viewItem.autoSetDimension(.height, toSize: Constants.stackViewItemSize)
                topTracksView.stackView.addArrangedSubview(viewItem)
                // strange animation with xib file
            }
        }
        
        let itemsCount: Int = uItems.count - 1
        let stackViewHeight: CGFloat = Constants.stackViewItemSize + (CGFloat(itemsCount) * Constants.stackViewItemSize)
        let expandedConstant: CGFloat =  stackViewHeight + (CGFloat(itemsCount) * Constants.stackViewItemSize/2) - Constants.stackViewItemSize/2
        
        if isExpanded {
            topTracksView.shrinkedConstraint.constant = expandedConstant
            scrollView.contentInset.bottom += expandedConstant
        } else {
            topTracksView.shrinkedConstraint.constant = Constants.stackViewItemSize
        }
        
        let animations = {
            self.topTracksView.layoutIfNeeded()
            
            if isExpanded {
                self.topTracksView.expandIcon.transform = CGAffineTransform.init(rotationAngle: 180.0 * .pi / 180)
            }
            else {
                self.topTracksView.expandIcon.transform = .identity
                self.topTracksView.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                self.scrollView.contentInset.bottom = Constants.scrollViewBottomInset
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: animations, completion: nil)
        }
        else {
            animations()
        }
    }
    
}


