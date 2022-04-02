//
//  ShadowView.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit

class ShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        setupShadow()
    }
    
    func setupShadow() {
        backgroundColor = .gray
        layer.cornerRadius = 8
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 8 / 2
    }
}
