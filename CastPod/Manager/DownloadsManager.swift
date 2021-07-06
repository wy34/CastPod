//
//  DownloadsManager.swift
//  CastPod
//
//  Created by William Yeung on 7/4/21.
//

import Foundation

class DownloadsManager {
    static let shared = DownloadsManager()
    let downloadsKey = "downloadsKey"
    
    func retrieveEpisodes() -> [Episode] {
        guard let episodesData = UserDefaults.standard.object(forKey: downloadsKey) as? Data else { return [] }
        
        if let decoded = try? JSONDecoder().decode([Episode].self, from: episodesData) {
            return decoded
        }
        
        return []
    }
    
    func downloadEpisode(episode: Episode?) {
        guard let episode = episode else { return }
        
        var existingDownloads = retrieveEpisodes()
        existingDownloads.append(episode)
        
        if let encoded = try? JSONEncoder().encode(existingDownloads) {
            UserDefaults.standard.setValue(encoded, forKey: downloadsKey)
            NotificationCenter.default.post(name: .shouldReloadDownloads, object: nil)
        }
    }
    
    func removeDownload(episode: Episode?) {
        guard let episode = episode else { return }
        
        var existingDownloads = retrieveEpisodes()
        
        if let episodeIndex = existingDownloads.firstIndex(where: { $0.title == episode.title && $0.pubDate == episode.pubDate }) {
            existingDownloads.remove(at: episodeIndex)
        
            if let encoded = try? JSONEncoder().encode(existingDownloads) {
                UserDefaults.standard.setValue(encoded, forKey: downloadsKey)
                removeFromDocumentsDirectory(urlString: episode.localUrl)
            }
        }
    }
    
    func removeFromDocumentsDirectory(urlString: String?) {
        do {
            guard let url = URL(string: urlString?.convertToTrueLocationPath() ?? "") else { return }
            try FileManager.default.removeItem(atPath: url.path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveEpisodeList(episodes: [Episode]) {
        if let encoded = try? JSONEncoder().encode(episodes) {
            UserDefaults.standard.setValue(encoded, forKey: downloadsKey)
        }
    }
}
