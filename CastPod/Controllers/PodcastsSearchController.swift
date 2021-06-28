//
//  ViewController.swift
//  CastPod
//
//  Created by William Yeung on 6/27/21.
//

import UIKit


class PodcastsSearchController: UITableViewController {
    // MARK: - Properties
    private let reuseId = "PodcastCell"
    
    var podcasts = [
        Podcast(name: "Lets Build That App", artistName: "Brian Voong"),
        Podcast(name: "Some Podcast", artistName: "Some Author")
    ]
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    // MARK: - Helpers
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
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
        cell.textLabel?.text = "\(podcast.name)\n\(podcast.artistName)"
        cell.imageView?.image = Asset.placeholder
        return cell
    }
}
