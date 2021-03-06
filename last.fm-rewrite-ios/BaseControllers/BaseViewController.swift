//
//  BaseViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 01.04.2022..
//

import UIKit
import PureLayout
import ProgressHUD
import RxSwift

class BaseViewController<T: Codable, DataLoader: BaseDataLoader<T>>: UIViewController {

    let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let dataLoader = DataLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBarAppearance()
        showToast()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        dataLoader.setupCollectionView(collectionView: collectionView)
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
    }
        
    fileprivate func showToast()  {
        dataLoader.errorOccured = {[weak self] isErrorOccured in
            guard let uSelf = self else { return }
            if isErrorOccured {
                uSelf.showNoDataView()
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    func showAlertAttributed(attributedText: NSMutableAttributedString, completion: ((Bool) -> Void)?) {
        let alert = UIAlertController.init(title: "",
                                           message: "",
                                           preferredStyle: .alert)
        alert.setValue(attributedText, forKey: "attributedTitle")
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: { (_) in
            completion?(false)
        }))
        alert.addAction(.init(title: "Remove", style: .default, handler: { (_) in
            completion?(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func generateAlertAttributed(title: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: String.init(format:"Are you sure you want to delete \"%@\" from this list?", title))
        // extend with enum but we have this time only one case
    }
    
    //MARK: - NavigationBar Appearance
    
    func setupNavigationBarAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ColorTheme.primaryBackground
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
    
    func showNoDataView() {
        let noDataView = EmptyDataView(viewController: self, message: "Something went wrong. Unable to load data.", actionTitle: "Try again")
        noDataView.fire()
        noDataView.onActionCompletion = { [weak self] in
            self?.dataLoader.loadItems(isPagging: false)
        }
    }
    
}
