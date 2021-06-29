//
//  EpisodesController.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit


#warning("Navbar remains small until scrolled")
class EpisodesController: UITableViewController {
    // MARK: - Properties
    var podcast: Podcast? {
        didSet {
            guard let podcast = podcast else { return }
            configureNavBar(title: podcast.trackName ?? "")
        }
    }
    
    var episodes = [
        Episode(title: "First Episode"),
        Episode(title: "Second Episode"),
        Episode(title: "Third Episode")
    ]
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    // MARK: - Helpers
    private func configureNavBar(title: String) {
        navigationItem.title = title
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension EpisodesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = episodes[indexPath.row].title
        return cell
    }
}
