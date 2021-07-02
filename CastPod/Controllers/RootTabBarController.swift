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
            generateNavController(PodcastsSearchController(), "Favorites", SFSymbols.star),
            generateNavController(PodcastsSearchController(), "Search", SFSymbols.magnifyingglass),
            generateNavController(PodcastsSearchController(), "Downloads", SFSymbols.download)
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
        maximizedTopAnchorConstraint?.isActive = show ? true : false
        maximizedTopAnchorConstraint?.constant = show ? 0 : view.frame.height
        
        maximizedBottomAnchorConstraint?.isActive = show ? true : false
        maximizedBottomAnchorConstraint?.constant = show ? 0 : view.frame.height
        
        minimizedTopAnchorConstraint?.isActive = show ? false : true
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
        self.tabBar.frame.origin.y = show ? self.view.frame.height : 0
    }
    
    func minimizePlayerView() {
        playerView.hideMainPlayerView()
        animatePlayerViewConstraintsTo(show: false)
    }
    
    func maximizePlayerView(episode: Episode?) {
        playerView.showMainPlayerView()
        
        animatePlayerViewConstraintsTo(show: true)
        
        if playerView.episode == nil {
            playerView.episode = episode
        }
    }
}
