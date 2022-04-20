//
//  SearchResultCollectionViewCell.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 20.04.2022..
//

import UIKit
import SDWebImage

class SearchResultCollectionViewCell: UICollectionViewCell {
    // could also reuse not xib cell
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!

    //MARK: - Artist

    var artist: Artist? {
        didSet {
            guard let uArtist = artist else { return }
            artistName.text = uArtist.name
            //unfortunately api does not provide artist image anymore
        }
    }
}
