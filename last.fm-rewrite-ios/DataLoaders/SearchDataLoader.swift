//
//  SearchDataLoader.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 19.04.2022..
//

import UIKit

class SearchDataLoader: BaseDataLoader<Artist>, UISearchResultsUpdating, UISearchControllerDelegate {
    
    weak var searchController: UISearchController?
    
    func loadSearchResults(input: String) {
        
        guard input.count > 2 else { return }
        
        guard let api = Network.api(type: .artistSearchResults(artist: input)) else { return }
                
        isLoading.accept(true)
        
        request = api.fetch(completion: {[weak self] result in
            guard let uSelf = self else { return }
            
            switch result {
            case .success(let value):
                do {
                    let searchResults = try value.mapSearchResults()
                    uSelf.items.accept(searchResults.results.artistResults.artist)
                    uSelf.isLoading.accept(false)
                    uSelf.errorOccured?(false)
                    
                } catch let error {
                    print("Search results failed: \(error.localizedDescription)")
                    uSelf.errorOccured?(true)
                }
                
            case .failure(_):
                uSelf.errorOccured?(true)
            }
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let uSearchText = searchController.searchBar.text else { return }
        guard !uSearchText.isBlankOrEmpty() else { return }
        loadSearchResults(input: uSearchText)
    }
    
    
    
    func configSearchController(searchController: UISearchController) {
        self.searchController = searchController
        self.searchController?.delegate = self
        self.searchController?.searchResultsUpdater = self
        self.searchController?.searchBar.searchTextField.backgroundColor = .white
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
         UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }
    
    override func setupCollectionView(collectionView: UICollectionView) {
        super.setupCollectionView(collectionView: collectionView)
    }
}
