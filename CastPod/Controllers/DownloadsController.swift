//
//  DownloadsController.swift
//  CastPod
//
//  Created by William Yeung on 7/4/21.
//

import UIKit

class DownloadsController: UITableViewController {
    // MARK: - Properties
    var episodes = [Episode]()
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        episodes = DownloadsManager.shared.retrieveEpisodes()
        configureTableView()
        configureUI()
        setupNotificationObservers()
    }
    
    // MARK: - Helpers
    private func configureTableView() {
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseId)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Colors.darkModeBackground
        tableView.rowHeight = 132
    }
    
    private func configureUI() {

    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDownloads), name: .shouldReloadDownloads, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayDownloadProgress), name: .shouldUpdateDownloadProgress, object: nil)
    }
    
    // MARK: - Selectors
    @objc func reloadDownloads() {
        episodes = DownloadsManager.shared.retrieveEpisodes()
        tableView.reloadData()
    }
    
    @objc func displayDownloadProgress(notification: Notification) {
        guard let episodeTitle = notification.userInfo?["episodeTitle"] as? String else { return }
        guard let progress = notification.userInfo?["progress"] as? Double else { return }
        
        if let indexOfEpisode = episodes.firstIndex(where: { $0.title == episodeTitle }) {
            let cell = tableView.cellForRow(at: .init(row: indexOfEpisode, section: 0)) as? EpisodeCell
            if progress == 1 { cell?.hideDownloadingIndicators(); return }
            cell?.showDownloadingIndicatorsWith(progress: progress)
        }
    }
}

extension DownloadsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseId, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(episodes[indexPath.row].localUrl)
        UIApplication.shared.rootViewController?.playerView.episode = nil
        UIApplication.shared.rootViewController?.maximizePlayerView(episode: episodes[indexPath.row], episodeList: episodes)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = CPLabel(text: "No Downloaded Episodes", font: .systemFont(ofSize: 18, weight: .bold))
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return episodes.count == 0 ? 355 : 0
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: "") { [weak self] action, view, completion in
            DownloadsManager.shared.removeDownload(episode: self?.episodes[indexPath.row])
            self?.episodes.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        removeAction.backgroundColor = .red
        removeAction.image = SFSymbols.trash
        
        return .init(actions: [removeAction])
    }
}
