//
//  ViewController.swift
//  CastPod
//
//  Created by William Yeung on 6/27/21.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController {
    // MARK: - Properties
    private let reuseId = "PodcastCell"
    
    var podcasts = [
        Podcast(artistName: "Lets Build That App", trackName: "Brian Voong"),
        Podcast(artistName: "Some Podcast", trackName: "Some Author")
    ]
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupSearchController()
    }

    // MARK: - Helpers
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .orange
        searchController.searchBar.placeholder = "Search Podcast"
        searchController.searchBar.delegate = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PodcastsSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        let podcast = podcasts[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(podcast.artistName ?? "")\n\(podcast.trackName ?? "")"
        cell.imageView?.image = Asset.placeholder
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension PodcastsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let urlString = "https://itunes.apple.com/search?term=\(searchText)&media=podcast".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        AF.request(urlString).response { response in
            if let error = response.error {
                print(error.localizedDescription)
                return
            }
            
            if let data = response.data {
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    self.podcasts = searchResult.results
                    self.tableView.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
