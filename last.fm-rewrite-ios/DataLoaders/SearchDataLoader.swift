//
//  SearchDataLoader.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 19.04.2022..
//

import UIKit
import ProgressHUD

class SearchDataLoader: BaseDataLoader<Artist>, UISearchControllerDelegate {
    
    weak var searchController: UISearchController?
    var timer: Timer?
    
    fileprivate let searchCellIdentifier = "SearchCellIdentifier"
    fileprivate let minimumCharacterInput = 2
    override var headerTitle: String { return "No search results." }
    
    
    //MARK: - Load Data
    
    func loadSearchResults(input: String) {
        
        guard let api = Network.api(type: .artistSearchResults(artist: input)) else { return }
        
        isLoading.accept(true)
        
        if input.count > minimumCharacterInput && items.value.isEmpty {
            ProgressHUD.show()
        }
        
        request = api.fetch(completion: {[weak self] result in
            guard let uSelf = self else { return }
            
            switch result {
            case .success(let value):
                do {
                    let searchResults = try value.mapSearchResults()
                    if input.count > uSelf.minimumCharacterInput {
                        uSelf.items.accept(searchResults.results.artistResults.artist)
                        uSelf.isLoading.accept(uSelf.items.value.isEmpty ? true : false)
                        uSelf.errorOccured?(false)
                    }
                    ProgressHUD.dismiss()
                    
                } catch let error {
                    print("Search results failed: \(error.localizedDescription)")
                    uSelf.errorOccured?(true)
                }
                
            case .failure(_):
                uSelf.errorOccured?(true)
            }
        })
    }
    
    //MARK: - Fire Search
    
    func fireSearch(input: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.45, repeats: false, block: { [weak self] _ in
            guard let uSelf = self else { return }
            uSelf.loadSearchResults(input: input)
        })
    }
    
    //MARK: - CollectionView/SearchController Setup
    
    override func setupCollectionView(collectionView: UICollectionView) {
        super.setupCollectionView(collectionView: collectionView)
        collectionView.register(SearchResultCollectionViewCell.nib, forCellWithReuseIdentifier: searchCellIdentifier)
        collectionView.register(EmptyStateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: emptyStateHeaderIdentifier)
    }
    
    func configSearchController(searchController: UISearchController) {
        self.searchController = searchController
        self.searchController?.delegate = self
        self.searchController?.searchBar.delegate = self
        self.searchController?.searchResultsUpdater = self
        self.searchController?.searchBar.searchTextField.backgroundColor = .white
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellIdentifier, for: indexPath) as! SearchResultCollectionViewCell
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    override func configCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        if let searchCell = cell as? SearchResultCollectionViewCell {
            searchCell.artist = item(indexPath: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: emptyStateHeaderIdentifier, for: indexPath) as! EmptyStateHeaderView
        header.setupTitle(title: headerTitle)
        return header
    }
    
    //MARK: - CollectionViewCell Sizing
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let emptyState = items.value.isEmpty && isLoading.value
        return emptyState ? CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height / 2) : .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100.0)
    }
}

extension SearchDataLoader: UISearchBarDelegate {
    
    //MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isLoading.accept(false)
        items.accept([])
        searchController?.searchResultsController?.edgesForExtendedLayout = .all
        searchController?.edgesForExtendedLayout = .all
        searchController?.searchResultsController?.extendedLayoutIncludesOpaqueBars = true
        timer = nil
    }
}

extension SearchDataLoader: UISearchResultsUpdating {
    
    //MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let uInput = searchController.searchBar.text else { return }
        guard !uInput.isBlankOrEmpty() else {
            items.accept([])
            timer = nil
            return }
        fireSearch(input: uInput)
    }
}
