//
//  TopTracksView.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 06.04.2022..
//

import UIKit

class RecordTracksView: UIView {

    @IBOutlet weak var expandIcon: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var shrinkedConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = ColorTheme.recordDetailBackground
    }

}
