//
//  RootTabBarController.swift
//  CastPod
//
//  Created by William Yeung on 6/27/21.
//

import UIKit

class RootTabBarController: UITabBarController {
    // MARK: - Properties
    var maximizedTopAnchorConstraint: NSLayoutConstraint?
    var maximizedBottomAnchorConstraint: NSLayoutConstraint?
    var minimizedTopAnchorConstraint: NSLayoutConstraint?
    
    // MARK: - Views
    let playerView = PlayerView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
        layoutView()
    }
    
    // MARK: - Helpers
    private func setupTabBarController() {
        tabBar.tintColor = Colors.appTintColor
        viewControllers = [
            generateNavController(FavoritesController(), "Favorites", SFSymbols.star),
            generateNavController(PodcastsSearchController(), "Search", SFSymbols.magnifyingglass),
            generateNavController(DownloadsController(), "Downloads", SFSymbols.download)
        ]
    }
    
    private func generateNavController(_ viewController: UIViewController, _ title: String, _ icon: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = icon
        return navController
    }
    
    private func layoutView() {
        view.insertSubview(playerView, belowSubview: tabBar)
        
        minimizedTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maximizedTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint?.isActive = true
        maximizedBottomAnchorConstraint = playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        maximizedBottomAnchorConstraint?.isActive = true
        
        playerView.anchor(trailing: view.trailingAnchor, leading: view.leadingAnchor)
    }
    
    private func animatePlayerViewConstraintsTo(show: Bool) {
        UIView.animate(withDuration: 0.35) {
            self.tabBar.isHidden = show ? true : false
            self.maximizedTopAnchorConstraint?.isActive = show ? true : false
            self.maximizedTopAnchorConstraint?.constant = show ? 0 : self.view.frame.height
            
            self.maximizedBottomAnchorConstraint?.isActive = show ? true : false
            self.maximizedBottomAnchorConstraint?.constant = show ? 0 : self.view.frame.height
            
            self.minimizedTopAnchorConstraint?.isActive = show ? false : true
            
            if show { self.playerView.showMainPlayerView() } else { self.playerView.hideMainPlayerView() }
            
            self.view.layoutIfNeeded()
        }
    }
    
    func minimizePlayerView() {
        animatePlayerViewConstraintsTo(show: false)
        
        UITableView.appearance().scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 64, right: 0)
        UITableView.appearance().contentInset = .init(top: 0, left: 0, bottom: 64, right: 0)
        UICollectionView.appearance().scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 64, right: 0)
        UICollectionView.appearance().contentInset = .init(top: 0, left: 0, bottom: 64, right: 0)
    }
    
    func maximizePlayerView(episode: Episode?, episodeList: [Episode] = []) {
        animatePlayerViewConstraintsTo(show: true)
        
        if playerView.episode == nil {
            playerView.episode = episode
        }
        
        if !episodeList.isEmpty {
            playerView.episodeList = episodeList
        }
    }
}
