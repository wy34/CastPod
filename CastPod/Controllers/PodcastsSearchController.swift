//
//  ViewController.swift
//  CastPod
//
//  Created by William Yeung on 6/27/21.
//

import UIKit

class PodcastsSearchController: UITableViewController {
    // MARK: - Properties
    var podcasts = [Podcast]()
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupSearchController()
    }

    // MARK: - Helpers
    private func configureTableView() {
        tableView.rowHeight = 132
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        tableView.register(PodcastCell.self, forCellReuseIdentifier: PodcastCell.reuseId)
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = Colors.appTintColor
        searchController.searchBar.placeholder = "Search Podcast"
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func fetchPodcasts(_ searchQuery: String) {
        APIManager.shared.fetchPodcasts(searchQuery: searchQuery) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let podcasts):
                    self.podcasts = podcasts
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showAlert("Error", error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PodcastsSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PodcastCell.reuseId, for: indexPath) as! PodcastCell
        cell.podcast = podcasts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = podcasts[indexPath.row]
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = CastPodLabel(text: "Please enter a search term", font: .systemFont(ofSize: 18, weight: .bold))
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.count == 0 ? 250 : 0
    }
}

// MARK: - UISearchBarDelegate
extension PodcastsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchPodcasts(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        podcasts.removeAll()
        tableView.reloadData()
    }
}
