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
        
        dataLoader.requestCompleted =  {[weak self] in
            guard let uSelf = self else { return }
            guard let uItem = uSelf.dataLoader.items.value.first else { return }
            uSelf.configureTopTracks(item: uItem)
        }
    }
    
    override func expand() {
        super.reverseExpanded()
        setExpanded(isExpanded: isExpanded, animated: true, items: dataLoader.items.value.first?.topTracks)
    }
    
    //MARK: - Top Tracks
    
    func configureTopTracks(item: Artist) {
        guard !item.topTracks.isEmpty else { return }
        DispatchQueue.main.async {
            self.topTracksView.alpha = 1
            self.topTracksView.recordTrackLabel.text = item.topTracks.first?.name
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
                guard !descriptionText.isBlankOrEmpty() else { descriptionView.removeFromSuperview()
                    return
                }
                descriptionView.descriptionLabel.text = descriptionText
            }
            
            if let itemTags = item.tags.itemTags {
                recordArtistLabel.text = "Tags - \(itemTags.allJoined())"
            }
            
            guard !item.topTracks.isEmpty else { return }
            topTracksView.recordTrackLabel.text = item.topTracks.first?.name
            topTracksView.alpha = 1
            
            //API is so messed up
            
        }
    }
}

extension ArtistDetailsViewController {
    
    //MARK: - Error Handling
    
    func onErrorOccured() {
        dataLoader.errorOccured = { isError in
            guard isError else { return }
            let noDataView = EmptyDataView(viewController: self, message: "Something went wrong. Probably missing data.", actionTitle: "Ok")
            noDataView.fire()
            noDataView.onActionCompletion = { [weak self] in
                ProgressHUD.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
