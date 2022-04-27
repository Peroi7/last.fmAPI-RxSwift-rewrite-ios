//
//  UIApplicationExtensions.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 27.04.2022..
//

import Foundation
import UIKit

extension UIApplication {
    
    var actualKeyWindow: UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter({
                $0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }
        return window
    }
}
