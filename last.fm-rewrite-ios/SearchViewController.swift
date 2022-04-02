//
//  SearchViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit

class SearchViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false

        // Do any additional setup after loading the view.
    }
    
    override func setupNavigationBarAppearance(background: UIColor) {
        super.setupNavigationBarAppearance(background: .white)
    }
    
}
