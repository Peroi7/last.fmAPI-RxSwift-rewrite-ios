//
//  EmptyDataView.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 27.04.2022..
//

import UIKit
import PureLayout

class EmptyDataView {
    
    fileprivate let viewController: UIViewController
    fileprivate let message: String
    fileprivate let actionTitle: String
    fileprivate var visualEffectView: UIVisualEffectView!
    
    var onActionCompletion:(() -> Void)?
    
    init(viewController: UIViewController, message: String, actionTitle: String) {
        self.message = message
        self.actionTitle = actionTitle
        self.viewController = viewController
    }
    
    func fire() {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            self.blurEffect(show: false)
            self.onActionCompletion?()
        }
        alert.addAction(defaultAction)
        blurEffect(show: true)
        viewController.present(alert, animated: true, completion: nil)
    }
        
    func blurEffect(show: Bool) {
        if show {
            let blurEffect = UIBlurEffect(style: .light)
            visualEffectView =  UIVisualEffectView(effect: blurEffect)
            viewController.view.addSubview(visualEffectView)
            visualEffectView.autoPinEdgesToSuperviewEdges()
        } else {
            visualEffectView.removeFromSuperview()
        }
    }
    
}
