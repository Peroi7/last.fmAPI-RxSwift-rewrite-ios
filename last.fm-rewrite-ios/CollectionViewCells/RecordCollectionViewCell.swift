//
//  RecordCollectionViewCell.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit
import UIView_Shimmer

class RecordCollectionViewCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var recordImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var recordTitleLabel: CustomLabel!
    
//    var shimmeringAnimatedItems: [UIView] {
//        [recordImageView]
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
}

