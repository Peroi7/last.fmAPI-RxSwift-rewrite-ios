//
//  LoadingView.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 08.04.2022..
//

import Foundation
import ProgressHUD

class LoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        backgroundColor = ColorTheme.recordDetailBackground
        
        ProgressHUD.show()
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = ColorTheme.primaryBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
