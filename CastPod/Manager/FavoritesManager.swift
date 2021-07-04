//
//  FavoritesManager.swift
//  CastPod
//
//  Created by William Yeung on 7/3/21.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    let favoritePodcastsKey = "favoritePodcastsKey"
    
    func fetchFavoritePodcasts() -> [Podcast] {
        if let data = UserDefaults.standard.object(forKey: favoritePodcastsKey) as? Data {
            guard let decoded = try? JSONDecoder().decode([Podcast].self, from: data) else { return [] }
            return decoded
        }
        
        return []
    }
    
    func checkIfAlreadyFavorited(podcast: Podcast?) -> Bool {
        guard let podcast = podcast else { return false }
        let existingFavoritePodcasts = fetchFavoritePodcasts()
        return existingFavoritePodcasts.contains(where: { $0.trackName == podcast.trackName })
    }
    
    func saveAsFavorite(podcast: Podcast?) {
        guard let podcast = podcast else { return }
        var existingFavoritePodcasts = fetchFavoritePodcasts()
        existingFavoritePodcasts.append(podcast)
        
        if let encoded = try? JSONEncoder().encode(existingFavoritePodcasts) {
            UserDefaults.standard.setValue(encoded, forKey: favoritePodcastsKey)
        }
    }
    
    func removeFromFavorites(podcast: Podcast?) {
        guard let podcast = podcast else { return }
        var existingFavoritePodcasts = fetchFavoritePodcasts()
        
        if let podcastIndex = existingFavoritePodcasts.firstIndex(where: { $0.trackName == podcast.trackName }) {
            existingFavoritePodcasts.remove(at: podcastIndex)
            
            if let encoded = try? JSONEncoder().encode(existingFavoritePodcasts) {
                UserDefaults.standard.setValue(encoded, forKey: favoritePodcastsKey)
            }
        }
    }
}
