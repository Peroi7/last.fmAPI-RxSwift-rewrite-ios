//
//  BaseViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 01.04.2022..
//

import UIKit
import PureLayout
import ProgressHUD

class BaseViewController<T: Codable, DataLoader: BaseDataLoader<T>>: UIViewController {

    fileprivate var visualEffectView: UIVisualEffectView!
    let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let dataLoader = DataLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataLoader.loadItems()
        setupUI()
        setupNavigationBarAppearance(background: ColorTheme.primaryBackground)
        showToast()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        dataLoader.setupCollectionView(collectionView: collectionView)
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
    }
    
    func showToast()  {
        dataLoader.errorOccured = {[weak self] isErrorOccured in
            guard let uSelf = self else { return }
            if isErrorOccured {
                uSelf.showNoDataView()
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    //MARK: - NavigationBar Appearance
    
    func setupNavigationBarAppearance(background: UIColor) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = background
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.standardAppearance = appearance;
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
    }
}

extension BaseViewController {
    
    //MARK: - Error Handling Views
    
    fileprivate func showNoDataView() {
        let alert = UIAlertController(title: "", message: "Something went wrong. Unable to load data.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Try again", style: .default) { _ in
            self.blurEffect(show: false)
            self.dataLoader.loadItems()
        }
        alert.addAction(defaultAction)
        blurEffect(show: true)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func blurEffect(show: Bool) {
        if show {
            let blurEffect = UIBlurEffect(style: .light)
            visualEffectView =  UIVisualEffectView(effect: blurEffect)
            view.addSubview(visualEffectView)
            visualEffectView.autoPinEdgesToSuperviewEdges()
        } else {
            visualEffectView.removeFromSuperview()
        }
    }
    
}
