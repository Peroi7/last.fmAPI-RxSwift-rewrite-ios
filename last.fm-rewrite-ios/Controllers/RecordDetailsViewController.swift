//
//  RecordDetailsViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 06.04.2022..
//

import UIKit

class RecordDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate var topImageView: StretchyImageView!
    fileprivate var recordImageView: UIImageView!
    fileprivate var recordArtistLabel: UILabel!
    fileprivate var listenersLabel: RecordInfoLabel!
    fileprivate var playcountLabel: RecordInfoLabel!
    fileprivate var publishedLabel: RecordInfoLabel!
    fileprivate var topTracksView: RecordTracksView!
    fileprivate var recordInfoView: RecordInfoView!
    
    fileprivate(set) var isExpanded: Bool = false
    fileprivate var stackViewBottomInset: CGFloat = 80

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorTheme.recordDetailBackground
        navigationItem.title = "Raf Camora Anthrazit"
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .white
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        let containerView = UIView.newAutoLayout()
        containerView.backgroundColor = ColorTheme.recordDetailBackground
        
        topImageView = StretchyImageView()
        topImageView.backgroundColor = .red
        containerView.addSubview(topImageView)
        topImageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        topImageView.autoSetDimension(.height, toSize: 240.0)
        topImageView.imageView.image = UIImage(named: "icMusic-icon")
        
        recordImageView = UIImageView()
        topImageView.addSubview(recordImageView)
        recordImageView.backgroundColor = .orange
        recordImageView.autoPinEdge(.top, to: .bottom, of: topImageView, withOffset: -70.0)
        recordImageView.autoAlignAxis(.vertical, toSameAxisOf: topImageView)
        recordImageView.autoSetDimensions(to: .init(width: 140.0, height: 140.0))
        recordImageView.layer.cornerRadius = 70.0
        recordImageView.layer.masksToBounds = true

        recordArtistLabel = UILabel()
        recordArtistLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        recordArtistLabel.text = "Donna Summer"
        recordArtistLabel.numberOfLines = 0
        recordArtistLabel.textAlignment = .center
        
        containerView.addSubview(recordArtistLabel)
        recordArtistLabel.autoPinEdge(.top, to: .bottom, of: recordImageView, withOffset: Constants.paddingDefault)
        recordArtistLabel.autoAlignAxis(.vertical, toSameAxisOf: containerView)
        recordArtistLabel.autoSetDimension(.height, toSize: 40.0)

        listenersLabel = RecordInfoLabel.fromNib()
        playcountLabel = RecordInfoLabel.fromNib()
        publishedLabel = RecordInfoLabel.fromNib()
            
        recordInfoView = RecordInfoView.fromNib()
        containerView.addSubview(recordInfoView)
        recordInfoView.stackView.addArrangedSubview(listenersLabel)
        recordInfoView.stackView.addArrangedSubview(playcountLabel)
        recordInfoView.stackView.addArrangedSubview(publishedLabel)

        recordInfoView.autoPinEdge(.top, to: .bottom, of: recordArtistLabel)
        recordInfoView.autoPinEdge(.left, to: .left, of: containerView)
        recordInfoView.autoPinEdge(.right, to: .right, of: containerView)
        recordInfoView.wrapperView.autoSetDimension(.height, toSize: 150)

        topTracksView = RecordTracksView.fromNib()
        containerView.addSubview(topTracksView)
        topTracksView.autoPinEdge(.top, to: .bottom, of: recordInfoView.wrapperView, withOffset: 54.0)
        topTracksView.autoPinEdge(.left, to: .left, of: containerView)
        topTracksView.autoPinEdge(.right, to: .right, of: containerView)
        topTracksView.autoSetDimension(.height, toSize: 120.0)
        topTracksView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expand)))
        
        scrollView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        containerView.autoMatch(.width, to: .width, of: scrollView)
        containerView.autoPinEdge(.bottom, to: .bottom, of: topTracksView)
        scrollView.contentInset.bottom = stackViewBottomInset

    }

}

extension RecordDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topImageView.scrollViewDidScroll(scrollView: scrollView)
    }
    
    @objc func expand() {
        isExpanded = !isExpanded
        setExpanded(isExpanded: isExpanded, animated: true)
    }
    
    func setExpanded(isExpanded: Bool, animated: Bool) {
        guard let stackView = self.topTracksView.stackView else { return }
        
        let uItems =  [UIView(), UIView(), UIView(), UIView()]
        
        if isExpanded {
            for item in uItems {
                item.autoSetDimension(.height, toSize: Constants.stackViewItemSize)
                stackView.addArrangedSubview(item)
            }
        }
        
        let itemsCount: CGFloat = CGFloat(uItems.count)
        let stackViewHeight: CGFloat = Constants.stackViewItemSize + (itemsCount * Constants.stackViewItemSize)
        let expandedConstant: CGFloat =  stackViewHeight + (itemsCount * Constants.stackViewItemSize/2) -  Constants.stackViewItemSize/2

        
        if isExpanded {
            topTracksView.shrinkedConstraint.constant = expandedConstant
            scrollView.contentInset.bottom += expandedConstant
        } else {
            self.topTracksView.shrinkedConstraint.constant = Constants.stackViewItemSize
        }
        
        
        let animations = {
            self.topTracksView.layoutIfNeeded()
            
            if isExpanded {
                self.topTracksView.expandIcon.transform = CGAffineTransform.init(rotationAngle: 180.0 * .pi / 180)
            }
            else {
                self.topTracksView.expandIcon.transform = .identity
                self.topTracksView.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                self.scrollView.contentInset.bottom = self.stackViewBottomInset
            }
        }

        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: animations, completion: nil)
        }
        else {
            animations()
        }
    }
    
}
