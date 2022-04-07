//
//  CustomLabel.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit

class CustomLabel: UILabel {
    
    //MARK: - CustomLabel
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: .init(
            origin: .zero,
            size: textRect(
                forBounds: rect,
                limitedToNumberOfLines: numberOfLines
            ).size
        ))
    }
}
