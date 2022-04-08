//
//  FavoritesViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit

class FavoritesViewController: BaseViewController<Record, RecordsDataLoader> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favorites"
    }
    
}

