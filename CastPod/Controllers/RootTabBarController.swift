//
//  RootTabBarController.swift
//  CastPod
//
//  Created by William Yeung on 6/27/21.
//

import UIKit

class RootTabBarController: UITabBarController {
    // MARK: - Properties
    
    
    // MARK: - Views
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
    }
    
    // MARK: - Helpers
    private func setupTabBarController() {
        tabBar.tintColor = .orange
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
}
