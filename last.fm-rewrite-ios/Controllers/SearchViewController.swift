//
//  SearchViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit
import ProgressHUD

class SearchViewController: BaseViewController<Artist, SearchDataLoader> {
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataLoader.configSearchController(searchController: searchController)
        navigationItem.searchController = searchController
        
        dataLoader.didSelect = {[weak self] _,_,item in
            guard let uSelf = self else { return }
            let recordDetailsViewController = ArtistDetailsViewController(item: item, type: .artistDetails)
            uSelf.searchController.searchBar.resignFirstResponder()
            uSelf.navigationController?.pushViewController(recordDetailsViewController, animated: true)
        }
    }
}

extension SearchViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Search for artists"

    }
}
