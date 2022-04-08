//
//  MainTabBarController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 01.04.2022..
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        customizeTabBarItems()
        setupTabBarAppearance()
                
    }
    
    fileprivate func setupControllers() {
        setViewControllers([RecordsOverviewController().embedInNavController(), SearchViewController().embedInNavController(), RecordsOverviewController().embedInNavController()], animated: true)
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
