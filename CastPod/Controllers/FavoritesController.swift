//
//  FavoritesController.swift
//  CastPod
//
//  Created by William Yeung on 7/3/21.
//

import UIKit

class FavoritesController: UIViewController {
    // MARK: - Properties
    var favorites = FavoritesManager.shared.fetchFavoritePodcasts()
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseId)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = Colors.darkModeBackground
        cv.showsVerticalScrollIndicator = false
        return cv
    }()

    private let noFavoritesLabel = CPLabel(text: "You have no favorites", font: .systemFont(ofSize: 18, weight: .bold))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupNotificationObservers()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.tabBarViewControllers[0].tabBarItem.badgeValue = nil
    }
    
    // MARK: - Helpers
    private func configureUI() {
        noFavoritesLabel.textAlignment = .center
        noFavoritesLabel.numberOfLines = 0
        noFavoritesLabel.alpha = favorites.isEmpty ? 1 : 0
    }
    
    private func layoutUI() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        
        collectionView.addSubview(noFavoritesLabel)
        noFavoritesLabel.setDimension(width: collectionView.widthAnchor)
        noFavoritesLabel.center(to: collectionView, by: .centerX)
        noFavoritesLabel.center(to: collectionView, by: .centerY, withMultiplierOf: 0.42)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorites), name: .shouldReloadFavorites, object: nil)
    }
    
    private func setupGestures() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(displayRemoveMenu))
        gesture.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(gesture)
    }
    
    // MARK: - Selectors
    @objc func reloadFavorites() {
        favorites = FavoritesManager.shared.fetchFavoritePodcasts()
        noFavoritesLabel.alpha = favorites.isEmpty ? 1 : 0
        collectionView.reloadData()
    }
    
    @objc func displayRemoveMenu(gesture: UILongPressGestureRecognizer) {
        let gestureLocation = gesture.location(in: collectionView)
        if let gestureLocationIndexPath = collectionView.indexPathForItem(at: gestureLocation) {
            showRemoveFavoriteActionSheet(title: "Remove \(favorites[gestureLocationIndexPath.item].trackName ?? "")?") { [weak self] _ in
                FavoritesManager.shared.removeFromFavorites(podcast: self?.favorites[gestureLocationIndexPath.item])
                self?.favorites.remove(at: gestureLocationIndexPath.item)
                self?.collectionView.deleteItems(at: [gestureLocationIndexPath])
                self?.noFavoritesLabel.alpha = self?.favorites.count == 0 ? 1 : 0
                NotificationCenter.default.post(name: .shouldUnfavoritePodcast, object: nil)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FavoritesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        cell.podcast = favorites[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodeController = EpisodesController()
        episodeController.podcast = favorites[indexPath.item]
        navigationController?.pushViewController(episodeController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (view.frame.width - 48) / 2
        return .init(width: side, height: side + 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}
