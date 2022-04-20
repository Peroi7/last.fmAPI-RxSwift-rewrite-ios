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

class BaseRecordDetailsViewController<T: Codable, DataLoader: RecordDetailsDataLoader>: UIViewController, UIScrollViewDelegate  {
    
    
    //MARK: - Deinit
    
    deinit {
        
    }
    
    //MARK: - Views
    
    fileprivate var topImageView: StretchyImageView!
    fileprivate var recordArtistLabel: UILabel!
    
    var recordImageView: UIImageView!
    var scrollView: UIScrollView!
    var recordInfoView: RecordInfoView!
    var listenersLabel: RecordInfoLabel!
    var playcountLabel: RecordInfoLabel!
    var publishedLabel: RecordInfoLabel!
    var topTracksView: RecordTracksView!
    var favoriteButton: UIButton!
    var loadingView: LoadingView!
    
    var infoStackViewHeight: NSLayoutConstraint!
    
    let dataLoader = DataLoader()
    let disposeBag = DisposeBag()
    let record: Record
    let loaderType: DataLoader.DetailsLoaderType
    
    
    //MARK: - Initialization
    
    init(item: Record, loaderType: DataLoader.DetailsLoaderType) {
        self.record = item
        self.loaderType = loaderType
        dataLoader.loadDetails(item: item, type: loaderType)
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

        recordArtistLabel = UILabel()
        recordArtistLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)

        containerView.addSubview(recordArtistLabel)
        recordArtistLabel.autoPinEdge(.top, to: .bottom, of: recordImageView, withOffset: Constants.paddingDefault)
        recordArtistLabel.autoAlignAxis(.vertical, toSameAxisOf: containerView)
        recordArtistLabel.autoSetDimension(.height, toSize: 48.0)
        
        favoriteButton = UIButton(type: .custom)
        favoriteButton.setImage(UIImage(named: "icAddToFavorite-icon"), for: .normal)
        favoriteButton.layer.cornerRadius = 6.0
        favoriteButton.isUserInteractionEnabled = false
        favoriteButton.backgroundColor = ColorTheme.favoriteButtonBackground
        if loaderType == .api || loaderType == .cached {
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

        topTracksView = RecordTracksView.fromNib()
        containerView.addSubview(topTracksView)
        topTracksView.alpha = 0
        topTracksView.autoPinEdge(.top, to: .bottom, of: recordInfoView.wrapperView, withOffset: 54.0)
        topTracksView.autoPinEdge(.left, to: .left, of: containerView)
        topTracksView.autoPinEdge(.right, to: .right, of: containerView)
        topTracksView.autoSetDimension(.height, toSize: 120.0)
        topTracksView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expand)))
        
        loadingView = LoadingView(shouldPresentHud: loaderType == .api ? true : false)
        if loaderType == .api  {
            containerView.addSubview(loadingView)
            loadingView.autoPinEdge(.top, to: .bottom, of: recordArtistLabel)
            loadingView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        }
    
        scrollView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        containerView.autoMatch(.width, to: .width, of: scrollView)
        containerView.autoPinEdge(.bottom, to: .bottom, of: topTracksView)
        scrollView.contentInset.bottom = Constants.scrollViewBottomInset
        
        config(item: record)
                    
        dataLoader.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            guard let uSelf = self else { return }
            uSelf.loadingView.alpha = uSelf.loaderType == .api ? 0 : isLoading ? 1 : 0
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
        let animations = {
            if self.record.isFavorite {
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
    
    //MARK: - Config Item
    
    func config(item: Any) {
        if let uItem = item as? Record {
            navigationItem.title = uItem.name
            recordArtistLabel.text = uItem.artist.name
            guard let safeURL = uItem.imageURL else { return }
            switch loaderType {
            case .api:
                recordImageView.sd_imageTransition = .fade
                topImageView.imageView.sd_setImage(with: safeURL)
                recordImageView.sd_setImage(with: safeURL)
            case .fromDisk, .cached:
                recordImageView.image = uItem.savedImage
                topImageView.imageView.image = uItem.savedImage
            }
        }
    }
    
    //MARK: - ScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topImageView.scrollViewDidScroll(scrollView: scrollView)
    }
    
    @objc func expand() {
       
    }
    
}
