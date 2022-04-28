//
//  ArtistDetailsViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 27.04.2022..
//

import UIKit
import ProgressHUD
import RxSwift

class ArtistDetailsViewController: BaseRecordDetailsViewController<Artist, ArtistDetailsDataLoader> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onErrorOccured()
        dataLoader.topTracks.subscribe(onNext: {[weak self] (tracks) in
            guard let uSelf = self else { return }
            uSelf.configureTopTracks(topTracks: tracks)
        }).disposed(by: disposeBag)
    }
    
    override func expand() {
        super.reverseExpanded()
        setExpanded(isExpanded: isExpanded, animated: true, items: dataLoader.topTracks.value)
    }
    
    //MARK: - Top Tracks
    
    func configureTopTracks(topTracks: [Track]) {
        DispatchQueue.main.async {
            self.topTracksView.alpha = 1
            self.topTracksView.recordTrackLabel.text = topTracks.first?.name
        }
    }
    
    //MARK: - Config
    
    override func config(item: Artist) {
        super.config(item: item)
        
        if let listeners = item.info.listeners, let playCount = item.info.playcount {
            DispatchQueue.main.async {
                self.listenersLabel.recordInfoSecondLabel.text = listeners.intValue.roundedWithAbbreviations
                self.playcountLabel.recordInfoSecondLabel.text = playCount.intValue.roundedWithAbbreviations
            }
            
            if let description = item.artistBio.summary {
                let descriptionText = description.cleanString()
                guard !descriptionText.isBlankOrEmpty() else { descriptionView.isHidden = true
                    setDefaultConstraints()
                    return
                }
                descriptionView.descriptionLabel.text = descriptionText
            }
            
            if let itemTags = item.tags.itemTags {
                recordArtistLabel.text = "Tags - \(itemTags.allJoined())"
            }
            //JSON is so messed up
        }
    }
}

extension ArtistDetailsViewController {
    
    //MARK: - Error Handling
    
    func onErrorOccured() {
        dataLoader.errorOccured = { isError in
            guard isError else { return }
            let noDataView = EmptyDataView(viewController: self, message: "Something went wrong. Probably missing data.", actionTitle: "Ok") // could be constant or localized string also
            noDataView.fire()
            noDataView.onActionCompletion = { [weak self] in
                ProgressHUD.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
