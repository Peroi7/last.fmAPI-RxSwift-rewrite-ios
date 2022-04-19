//
//  LoadingView.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 08.04.2022..
//

import Foundation
import ProgressHUD

class LoadingView: UIView {
    
    let shouldPresentHud: Bool
    
    init(shouldPresentHud: Bool) {
        self.shouldPresentHud = shouldPresentHud
        super.init(frame: .zero)
        
        alpha = 0
        backgroundColor = ColorTheme.recordDetailBackground
        
        shouldPresentHud ? ProgressHUD.show() : ProgressHUD.dismiss()
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = ColorTheme.primaryBackground
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
