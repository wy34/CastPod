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
    var minimizedTopAnchorConstraint: NSLayoutConstraint?
    
    // MARK: - Views
    private let playerView = PlayerView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
        layoutView()
        playerView.backgroundColor = .red
        
        perform(#selector(maximizePlayerView), with: nil, afterDelay: 1)
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
        
        maximizedTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint?.isActive = true
        
        minimizedTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizedTopAnchorConstraint?.isActive = true
        
        playerView.anchor(trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
    }
    
    // MARK: - Selectors
    @objc func minimizePlayerView() {
        maximizedTopAnchorConstraint?.isActive = false
        minimizedTopAnchorConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func maximizePlayerView() {
        maximizedTopAnchorConstraint?.constant = 0
        maximizedTopAnchorConstraint?.isActive = true
        minimizedTopAnchorConstraint?.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
}
