//
//  AlbumsOverviewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit
import PureLayout
import UIView_Shimmer

class RecordsOverviewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Overview"
        
        let layout = UICollectionViewFlowLayout()
    
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor  = .white
        collectionView.register(RecordCollectionViewCell.nib, forCellWithReuseIdentifier: "cellId")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! RecordCollectionViewCell
        
        cell.recordTitleLabel.text = "Abba aniversary gold edition best hits"
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.setTemplateWithSubviews(true, viewBackgroundColor: .systemBackground)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let size = (view.frame.width - 27)  / 2
            
            return CGSize(width: size, height: size)
            
        }
        
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            
        }
    
    
}

