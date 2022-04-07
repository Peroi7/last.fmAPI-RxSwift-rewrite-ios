//
//  LoadingCell.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 05.04.2022..
//

import ProgressHUD

//MARK: - Loading Cell

class LoadingCell: UICollectionViewCell {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ProgressHUD.show()
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = ColorTheme.primaryBackground
    }
}
