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
    var timer: Timer?
    
    // MARK: - Views
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchingLabel = CPLabel(text: "", font: .systemFont(ofSize: 18, weight: .semibold))
    private let searchingIndicator = UIActivityIndicatorView(style: .large)
    private lazy var searchingStack = CPStackView(views: [searchingLabel, searchingIndicator], axis: .vertical, spacing: -165, distribution: .fillEqually)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupSearchController()
    }

    // MARK: - Helpers
    private func configureTableView() {
        tableView.rowHeight = 132
        tableView.backgroundColor = Colors.darkModeBackground
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        tableView.register(PodcastCell.self, forCellReuseIdentifier: PodcastCell.reuseId)
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = Colors.appTintColor
        searchController.searchBar.placeholder = "Search Podcast"
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        
//        searchBar(searchController.searchBar, textDidChange: "Sean Allen")
    }
    
    private func fetchPodcasts(_ searchQuery: String) {
        APIManager.shared.fetchPodcasts(searchQuery: searchQuery) { [weak self] result in
            switch result {
                case .success(let podcasts):
                    if podcasts.isEmpty {
                        self?.searchingLabel.text = "Cannot find podcast"
                        self?.searchingIndicator.color = .clear
                    } else {
                        self?.podcasts = podcasts
                        self?.tableView.reloadData()
                        self?.searchingIndicator.stopAnimating()
                    }
                case .failure(let error):
                    self?.showAlert("Error", error.localizedDescription)
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
        let label = CPLabel(text: "Please enter a search term", font: .systemFont(ofSize: 18, weight: .bold))
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.count == 0 && searchController.searchBar.text == "" ? 250 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return searchingStack
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.count == 0 && searchController.searchBar.text != "" ? 250 : 0
    }
}

// MARK: - UISearchBarDelegate
extension PodcastsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingLabel.text = "Currently Searching..."
        searchingIndicator.startAnimating()
        searchingIndicator.color = .gray
        podcasts.removeAll()
        tableView.reloadData()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.fetchPodcasts(searchText)
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        podcasts.removeAll()
        tableView.reloadData()
    }
}
