//
//  RecordDetailsViewController.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 06.04.2022..
//

import UIKit
import SDWebImage
import RxSwift
import ProgressHUD

class BaseRecordDetailsViewController<T: Codable, DataLoader: BaseDataLoader<T>>: UIViewController, UIScrollViewDelegate  {
    
    //MARK: - Deinit
    
    deinit {
        
    }
    
    //MARK: - Views
    
    var topImageView: StretchyImageView!
    var recordArtistLabel: UILabel!
    
    var recordImageView: UIImageView!
    var scrollView: UIScrollView!
    var recordInfoView: RecordInfoView!
    var listenersLabel: RecordInfoLabel!
    var playcountLabel: RecordInfoLabel!
    var publishedLabel: RecordInfoLabel!
    var topTracksView: RecordTracksView!
    var descriptionView: DescriptionView!
    var favoriteButton: UIButton!
    var loadingView: LoadingView!
    
    var infoStackViewHeight: NSLayoutConstraint!
    
    let dataLoader = DataLoader()
    let disposeBag = DisposeBag()
    let item: Any
    var loaderType: LoaderType = .recordDetails
    
    var isExpanded: Bool = false
    
    enum LoaderType {
        case recordDetails
        case artistDetails
        case favorites
    }
    
    //MARK: - Initialization
        
    init<L: Codable>(item: L, type: LoaderType) {
        self.item = item
        self.loaderType = type
        dataLoader.loadDetails(item: item)
        if let item = item as? Artist {
            dataLoader.loadItems(isPagging: false, title: item.name)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        let containerView = UIView.newAutoLayout()
        containerView.backgroundColor = ColorTheme.recordDetailBackground
    
        view.backgroundColor = ColorTheme.recordDetailBackground
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .white
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        topImageView = StretchyImageView()
        topImageView.backgroundColor = .white
        containerView.addSubview(topImageView)
        topImageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        topImageView.autoSetDimension(.height, toSize: 240.0)
        
        recordImageView = UIImageView()
        topImageView.addSubview(recordImageView)
        recordImageView.backgroundColor = .white
        recordImageView.autoPinEdge(.top, to: .bottom, of: topImageView, withOffset: -70.0)
        recordImageView.autoAlignAxis(.vertical, toSameAxisOf: topImageView)
        recordImageView.autoSetDimensions(to: .init(width: 140.0, height: 140.0))
        recordImageView.layer.cornerRadius = 70.0
        recordImageView.layer.masksToBounds = true

        recordArtistLabel = UILabel.newAutoLayout()
        recordArtistLabel.font = UIFont.systemFont(ofSize: loaderType != .artistDetails ? 20.0 : 17.0, weight: loaderType != .artistDetails ? .bold : .medium)
        if loaderType == .artistDetails {
            recordArtistLabel.textColor = .black.withAlphaComponent(0.5)
        }
        recordArtistLabel.textAlignment = .center
        recordArtistLabel.numberOfLines = 0
        
        descriptionView = DescriptionView.fromNib()

        containerView.addSubview(recordArtistLabel)
        recordArtistLabel.autoPinEdge(.top, to: .bottom, of: recordImageView, withOffset: Constants.paddingDefault)
        recordArtistLabel.autoSetDimension(.height, toSize: 48.0)
        
        switch loaderType {
        case .recordDetails, .favorites:
            recordArtistLabel.autoAlignAxis(.vertical, toSameAxisOf: containerView)
        case .artistDetails:
            recordArtistLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Constants.paddingDefaultSmall)
            recordArtistLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: Constants.paddingDefaultSmall)
        }
        
        favoriteButton = UIButton(type: .custom)
        favoriteButton.setImage(UIImage(named: "icAddToFavorite-icon"), for: .normal)
        favoriteButton.layer.cornerRadius = 6.0
        favoriteButton.isUserInteractionEnabled = false
        favoriteButton.backgroundColor = ColorTheme.favoriteButtonBackground
        
        if loaderType != .artistDetails {
            containerView.addSubview(favoriteButton)
            favoriteButton.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Constants.paddingDefaultSmall)
            favoriteButton.autoAlignAxis(.horizontal, toSameAxisOf: recordArtistLabel)
            favoriteButton.autoSetDimensions(to: .init(width: 48.0, height: 48.0))
            favoriteButton.addTarget(self, action: #selector(onFavorite), for: .touchUpInside)
            setFavoriteButtonImage(animated: false)
        }
                
        listenersLabel = RecordInfoLabel.init(title: .listeners)
        playcountLabel = RecordInfoLabel.init(title: .playcount)
        publishedLabel = RecordInfoLabel.init(title: .published)
        
        recordInfoView = RecordInfoView.fromNib()
        containerView.addSubview(recordInfoView)
        recordInfoView.autoPinEdge(.top, to: .bottom, of: recordArtistLabel)
        recordInfoView.autoPinEdge(.left, to: .left, of: containerView)
        recordInfoView.autoPinEdge(.right, to: .right, of: containerView)
        infoStackViewHeight = recordInfoView.wrapperView.autoSetDimension(.height, toSize: 150.0)
        infoStackViewHeight.isActive = true
        
        if loaderType == .artistDetails {
            containerView.addSubview(descriptionView)
            descriptionView.autoPinEdge(.top, to: .bottom, of: recordInfoView, withOffset: Constants.paddingDefaultSmall)
            descriptionView.autoPinEdge(.left, to: .left, of: containerView)
            descriptionView.autoPinEdge(.right, to: .right, of: containerView)
        }

        topTracksView = RecordTracksView.fromNib()
        containerView.addSubview(topTracksView)
        topTracksView.alpha = 0
        topTracksView.autoPinEdge(.top, to: .bottom, of: loaderType == .artistDetails ? descriptionView : recordInfoView.wrapperView, withOffset: 54.0)
        topTracksView.autoPinEdge(.left, to: .left, of: containerView)
        topTracksView.autoPinEdge(.right, to: .right, of: containerView)
        topTracksView.autoSetDimension(.height, toSize: 120.0)
        topTracksView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expand)))
        
        if loaderType == .artistDetails {
            descriptionView.autoPinEdge(.bottom, to: .top, of: topTracksView, withOffset: -Constants.paddingDefaultSmall)
        }
        
        loadingView = LoadingView(shouldPresentHud: dataLoader.isLoading.value)
        if dataLoader.isLoading.value {
            containerView.addSubview(loadingView)
            switch loaderType {
            case .recordDetails, .favorites:
                loadingView.autoPinEdge(.top, to: .bottom, of: recordArtistLabel)
            case .artistDetails:
                loadingView.autoPinEdge(.top, to: .bottom, of: recordImageView)
            }
            loadingView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        }
        
        scrollView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        containerView.autoMatch(.width, to: .width, of: scrollView)
        containerView.autoPinEdge(.bottom, to: .bottom, of: topTracksView)
        scrollView.contentInset.bottom = Constants.scrollViewBottomInset
        
        baseConfig(type: loaderType)
                    
        dataLoader.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            guard let uSelf = self else { return }
            uSelf.loadingView.alpha = isLoading ? 1 : 0
            uSelf.favoriteButton.isUserInteractionEnabled = !isLoading
            if !isLoading {
                guard let uItem = uSelf.dataLoader.items.value.first else { return }
                uSelf.config(item: uItem)
                ProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFavoriteButtonImage(animated: false)
    }
    
    //MARK: - FavoriteButton Setup
    
   func setFavoriteButtonImage(animated: Bool) {
       guard let uItem = item as? Record else { return }
        let animations = {
            if uItem.isFavorite {
                self.favoriteButton.setImage(UIImage(named: "icAddToFavoriteFull-icon"), for: .normal)
            }
            else {
                self.favoriteButton.setImage(UIImage(named: "icAddToFavorite-icon"), for: .normal)
            }
        }
        
        if animated {
            UIView.transition(with: favoriteButton.imageView!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: animations)
        }
        else {
            animations()
        }
    }
     
    @objc func onFavorite() {
        
    }
    
    func setInfoViewStackHeight(stack: UIStackView) -> CGFloat {
        return CGFloat(stack.arrangedSubviews.count) * Constants.detailInfoViewItemSize
    }
    
    
    //MARK: - Config Item
    
    func baseConfig(type: LoaderType) {
        switch type {
        case .recordDetails, .favorites:
            guard let uItem = item as? Record else { return }
            navigationItem.title = uItem.name
            recordArtistLabel.text = uItem.artist.name
            guard let safeURL = uItem.imageURL else { return }
            if dataLoader.isLoading.value {
                recordImageView.sd_imageTransition = .fade
                topImageView.imageView.sd_setImage(with: safeURL)
                recordImageView.sd_setImage(with: safeURL)
            } else {
                recordImageView.image = uItem.savedImage
                topImageView.imageView.image = uItem.savedImage
            }
        case .artistDetails:
            guard let uItem = item as? Artist else { return }
            navigationItem.title = uItem.name
            recordArtistLabel.text = uItem.name
            recordImageView.image = uItem.defaultArtistImage
            topImageView.imageView.image = uItem.defaultArtistImage
        }
        
    }
    
    func config(item: T) {
        recordInfoView.stackView.addArrangedSubview(listenersLabel)
        recordInfoView.stackView.addArrangedSubview(playcountLabel)
        infoStackViewHeight.constant = setInfoViewStackHeight(stack: recordInfoView.stackView)
    }
    
    //MARK: - ScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topImageView.scrollViewDidScroll(scrollView: scrollView)
    }
    
    @objc func expand() {
       
    }
    
    //MARK: - Expand Top Tracks
    
    func reverseExpanded() {
        isExpanded = !isExpanded
    }
    
    func setExpanded(isExpanded: Bool, animated: Bool, items: [Track]?) {
        guard let uItems = items else { return }
        guard !uItems.isEmpty else {
            topTracksView.removeFromSuperview()
            return }
        
        if isExpanded {
            for uItem in uItems[1..<uItems.count] {
                let viewItem = UILabel()
                viewItem.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
                viewItem.text = uItem.name
                viewItem.autoSetDimension(.height, toSize: Constants.stackViewItemSize)
                topTracksView.stackView.addArrangedSubview(viewItem)
                // strange animation with xib file
            }
        }
        
        let itemsCount: Int = uItems.count - 1
        let stackViewHeight: CGFloat = Constants.stackViewItemSize + (CGFloat(itemsCount) * Constants.stackViewItemSize)
        let expandedConstant: CGFloat =  stackViewHeight + (CGFloat(itemsCount) * Constants.stackViewItemSize/2) - Constants.stackViewItemSize/2
        
        if isExpanded {
            topTracksView.shrinkedConstraint.constant = expandedConstant
            scrollView.contentInset.bottom += expandedConstant
        } else {
            topTracksView.shrinkedConstraint.constant = Constants.stackViewItemSize
        }
        
        let animations = {
            self.topTracksView.layoutIfNeeded()
            
            if isExpanded {
                self.topTracksView.expandIcon.transform = CGAffineTransform.init(rotationAngle: 180.0 * .pi / 180)
            }
            else {
                self.topTracksView.expandIcon.transform = .identity
                self.topTracksView.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                self.scrollView.contentInset.bottom = Constants.scrollViewBottomInset
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
