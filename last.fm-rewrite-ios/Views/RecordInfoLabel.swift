//
//  ListenersView.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 06.04.2022..
//

import UIKit
import PureLayout

class RecordInfoLabel: UIView {
    
    let recordInfoLeftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    let recordInfoSecondLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    //MARK: - RecordLabel Title
    
    enum RecordInfoLabelTitle: String {
        case listeners = "Listeners"
        case playcount = "Playcount"
        case published = "Published"
    }
    
    //MARK: - Setup

    required init(title: RecordInfoLabelTitle) {
        super.init(frame: .zero)
        
        addSubview(recordInfoLeftLabel)
        recordInfoLeftLabel.autoPinEdge(.left, to: .left, of: self, withOffset: 8.0)
        recordInfoLeftLabel.autoSetDimension(.height, toSize: Constants.paddingDefault)
        recordInfoLeftLabel.autoAlignAxis(.horizontal, toSameAxisOf: self)
        recordInfoLeftLabel.text = title.rawValue

        addSubview(recordInfoSecondLabel)
        recordInfoSecondLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -8.0)
        recordInfoSecondLabel.autoSetDimension(.height, toSize: Constants.paddingDefault)
        recordInfoSecondLabel.autoAlignAxis(.horizontal, toSameAxisOf: recordInfoLeftLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
