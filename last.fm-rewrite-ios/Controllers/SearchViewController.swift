//
//  SearchViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit

class SearchViewController: BaseViewController<Artist, SearchDataLoader> {
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search for artists"
        dataLoader.configSearchController(searchController: searchController)
        navigationItem.searchController = searchController
    }
    
}
