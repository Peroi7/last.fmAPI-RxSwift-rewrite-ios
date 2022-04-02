//
//  UIViewControllerExtensions.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit

extension UIViewController {
    
    func embedInNavController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
}
