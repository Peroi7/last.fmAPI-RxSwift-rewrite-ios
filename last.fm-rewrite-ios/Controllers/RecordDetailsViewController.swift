//
//  RecordDetailsViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 07.04.2022..
//

import UIKit
import RxSwift
import ProgressHUD

class RecordDetailsViewController: BaseRecordDetailsViewController<RecordDetail, RecordDetailsDataLoader> {
    
    fileprivate (set) var isExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        playcountLabel.recordInfoSecondLabel.text = item.playCount.intValue.roundedWithAbbreviations
        infoStackViewHeight.constant = 100
        
        if let published = item.wiki?.published {
            recordInfoView.stackView.addArrangedSubview(publishedLabel)
            publishedLabel.recordInfoSecondLabel.text = published
            infoStackViewHeight.constant = 150
        }
        
        if let tracks = item.tracks?.track {
            topTracksView.recordTrackLabel.text = tracks.first?.name
            topTracksView.alpha = 1
        }
        
    }
    
    //MARK: - Expand Top Tracks
    
    func setExpanded(isExpanded: Bool, animated: Bool) {
        guard let stackView = self.topTracksView.stackView else { return }
        guard let uItems = dataLoader.items.value.first?.tracks?.track else { return }
        
        if isExpanded {
            for uItem in uItems[1..<uItems.count] {
                let viewItem = UILabel()
                viewItem.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
                viewItem.text = uItem.name
                viewItem.autoSetDimension(.height, toSize: Constants.stackViewItemSize)
                stackView.addArrangedSubview(viewItem)
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


