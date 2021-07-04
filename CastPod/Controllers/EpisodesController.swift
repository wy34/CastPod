//
//  EpisodesController.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit


class EpisodesController: UITableViewController {
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        configureTableView()
        checkIfPodcastIsAlreadyFavorited()
    }
    
    // MARK: - Helpers
    private func configureNavBar(title: String) {
        navigationItem.title = title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.heart, style: .plain, target: self, action: #selector(favoritePodcast))
    }
    
    private func configureTableView() {
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseId)
        tableView.backgroundColor = Colors.darkModeBackground
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 132
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
                    self.showAlert("Error", error.localizedDescription)
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
        } else if currentButtonImage == SFSymbols.heartFill {
            navigationItem.rightBarButtonItem?.image = SFSymbols.heart
            FavoritesManager.shared.removeFromFavorites(podcast: podcast)
        }
        
        NotificationCenter.default.post(name: .shouldReloadFavorites, object: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension EpisodesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseId, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.rootViewController?.playerView.episode = nil
        UIApplication.shared.rootViewController?.maximizePlayerView(episode: episodes[indexPath.row], episodeList: episodes)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return loadingStack
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return episodes.count == 0 ? 250 : 0
    }
}
