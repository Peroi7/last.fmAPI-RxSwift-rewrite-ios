//
//  FavoritesEmptyHeaderView.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 19.04.2022..
//

import UIKit
import PureLayout

class FavoritesEmptyStateHeaderView: UICollectionReusableView {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorite added."
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(messageLabel)
        messageLabel.autoCenterInSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
