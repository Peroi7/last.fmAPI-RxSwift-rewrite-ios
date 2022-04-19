//
//  FavoriteRecordCollectionViewCell.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 18.04.2022..
//

import UIKit

class FavoriteRecordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recordImageView: UIImageView!
    @IBOutlet weak var recordTitleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var onDelete:((_ id: String) -> Void)?

    //MARK: - Record
    
    var record: Record? {
        didSet {
            guard let uRecord = record else { return }
            recordTitleLabel.text = uRecord.name
            recordImageView.image = uRecord.savedImage
        }
    }
    
    @IBAction func onDelete(_ sender: Any) {
        if let ident = record?.ident {
            onDelete?(ident)
        }
    }
}
