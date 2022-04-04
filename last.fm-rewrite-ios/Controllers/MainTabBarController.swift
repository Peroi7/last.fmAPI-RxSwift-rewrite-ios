//
//  MainTabBarController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 01.04.2022..
//

import UIKit
import Moya

class MainTabBarController: UITabBarController {
    
    var request: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        customizeTabBarItems()
        setupTabBarAppearance()
        
        guard let api = Network.api(type: .recordDetails) else  { return }
        
        request = api.fetch(completion: { result in
            
            switch result {
            case .success(let value):
            
                do {
                    let value = try value.records()
                    let records = value
                    print(records)
                    
                } catch let err {
                    print(err)
                }
                
            case .failure(_):
                print("Request failed")
            }
            
        })
                
    }
    
    fileprivate func setupControllers() {
        setViewControllers([RecordsOverviewController().embedInNavController(), SearchViewController().embedInNavController(), FavoritesViewController().embedInNavController()], animated: true)
    }
    
    fileprivate func customizeTabBarItems() {
        guard let uTabBarItems = tabBar.items else { return }
        uTabBarItems.forEach {
            guard let uIndex = uTabBarItems.firstIndex(of: $0) else { return }
            $0.image = UIImage(named: TabBarItemIcons.allCases[uIndex].rawValue)?.withRenderingMode(.alwaysTemplate)
            $0.imageInsets = UIEdgeInsets(top: 8.0, left: 0, bottom: -8.0, right: 0)
        }
    }
    
}

// MARK: - TabBarAppearance

extension MainTabBarController {
    
    fileprivate func setupTabBarAppearance() {
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = ColorTheme.shadowBackground
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
}

// MARK: - TabBarItemIcons

extension MainTabBarController {
    
    fileprivate enum TabBarItemIcons: String, CaseIterable {
        case albumsOverView = "icLastfm-icon"
        case search = "icSearch-icon"
        case favorites = "icAddToFavorite-icon"
    }
    
}
