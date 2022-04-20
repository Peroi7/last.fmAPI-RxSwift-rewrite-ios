//
//  RecordCollectionViewCell.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit
import SDWebImage

class RecordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var recordImageView: UIImageView!
    @IBOutlet weak var recordTitleLabel: CustomLabel!
    
    //MARK: - Record
    
    var record: Record? {
        didSet {
            guard let uRecord = record else { return }
            recordTitleLabel.text = uRecord.name
            recordImageView.sd_imageTransition = .fade
            self.recordImageView.sd_setImage(with: uRecord.imageURL)
        }
    }
}

