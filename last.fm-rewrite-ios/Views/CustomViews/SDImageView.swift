//
//  SDImageView.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 27.04.2022..
//

import SDWebImage
import UIKit

class SDImageView: UIImageView {
    
    init(urlString: String) {
        super.init(frame: .zero)
        
        sd_setImage(with: URL(string: urlString))
        self.sd_imageTransition = .fade
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
