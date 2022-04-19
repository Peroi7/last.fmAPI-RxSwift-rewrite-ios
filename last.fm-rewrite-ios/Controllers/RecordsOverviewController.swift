//
//  RecordsOverviewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 19.04.2022..
//

import UIKit

class RecordsOverviewController: BaseViewController<Record, RecordsDataLoader> {

    override func viewDidLoad() {
        super.viewDidLoad()

        dataLoader.loadItems(isPagging: false)
        dataLoader.didSelect = {[weak self] _,_,item in
            guard let uSelf = self else { return }
            let recordDetailsViewController = RecordDetailsViewController(item: item, loaderType: FavoritesDataLoader.favorites.contains(where: {$0.record.ident == item.ident}) ? .cached : .api)
            uSelf.navigationController?.pushViewController(recordDetailsViewController, animated: true)
        }
        
    }
}

extension RecordsOverviewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Overview"
    }
}
