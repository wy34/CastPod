//
//  EpisodesController.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit


class EpisodesController: UIViewController {
    // MARK: - Properties
    var podcast: Podcast? {
        didSet {
            guard let podcast = podcast else { return }
            configureNavBar(title: podcast.trackName ?? "")
            parseEpisodes(feedUrl: podcast.feedUrl)
        }
    }
    
    var episodes = [Episode]()
    
    // MARK: - Views
    private let loadingLabel = CPLabel(text: "Loading...", font: .systemFont(ofSize: 18, weight: .semibold))
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private lazy var loadingStack = CPStackView(views: [loadingLabel, loadingIndicator], axis: .vertical, spacing: -165, distribution: .fillEqually)
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseId)
        tv.backgroundColor = Colors.darkModeBackground
        tv.tableFooterView = UIView()
        tv.rowHeight = 132
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        layoutUI()
        setupNotificationObservers()
        checkIfPodcastIsAlreadyFavorited()
    }
    
    // MARK: - Helpers
    private func configureNavBar(title: String) {
        navigationItem.title = title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.heart, style: .plain, target: self, action: #selector(favoritePodcast))
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteIconToUnfavorite), name: .shouldUnfavoritePodcast, object: nil)
    }
    
    private func parseEpisodes(feedUrl: String?) {
        APIManager.shared.parsePodcastFeed(urlString: feedUrl) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let episodes):
                    DispatchQueue.main.async {
                        if let episodes = episodes {
                            self.episodes = episodes
                            self.tableView.reloadData()
                            self.loadingIndicator.stopAnimating()
                        }
                    }
                case .failure(let error):
                    self.showAlert("Error", error.localizedDescription, completion: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
            }
        }
    }
    
    private func checkIfPodcastIsAlreadyFavorited() {
        if FavoritesManager.shared.checkIfAlreadyFavorited(podcast: podcast) {
            navigationItem.rightBarButtonItem?.image = SFSymbols.heartFill
        }
    }
    
    // MARK: - Selectors
    @objc func favoritePodcast() {
        let currentButtonImage = navigationItem.rightBarButtonItem?.image
        
        if currentButtonImage == SFSymbols.heart {
            navigationItem.rightBarButtonItem?.image = SFSymbols.heartFill
            FavoritesManager.shared.saveAsFavorite(podcast: podcast)
            UIApplication.shared.tabBarViewControllers[0].tabBarItem.badgeValue = "New"
            UIApplication.shared.tabBarViewControllers[0].tabBarItem.badgeColor = Colors.appTintColor
        } else if currentButtonImage == SFSymbols.heartFill {
            navigationItem.rightBarButtonItem?.image = SFSymbols.heart
            FavoritesManager.shared.removeFromFavorites(podcast: podcast)
        }
        
        NotificationCenter.default.post(name: .shouldReloadFavorites, object: nil)
    }
    
    @objc func updateFavoriteIconToUnfavorite() {
        navigationItem.rightBarButtonItem?.image = SFSymbols.heart
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension EpisodesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseId, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.rootViewController?.playerView.episode = nil
        UIApplication.shared.rootViewController?.maximizePlayerView(episode: episodes[indexPath.row], episodeList: episodes)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return loadingStack
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return episodes.count == 0 ? 250 : 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let downloadAction = UIContextualAction(style: .normal, title: "") { [weak self] action, view, completion in
            DownloadsManager.shared.downloadEpisode(episode: self?.episodes[indexPath.row])
            APIManager.shared.download(episode: self?.episodes[indexPath.row])
            completion(true)
        }
        
        downloadAction.image = SFSymbols.download
        
        return UISwipeActionsConfiguration(actions: [downloadAction])
    }
}
