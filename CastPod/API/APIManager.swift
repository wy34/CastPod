//
//  APIManager.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import Foundation
import Alamofire

class APIManager {
    // MARK: - Properties
    static let shared = APIManager()
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Helpers
    func fetchPodcasts(searchQuery: String, completion: @escaping (Result<[Podcast], Error>) -> Void) {
        let urlString = "https://itunes.apple.com/search?term=\(searchQuery)&media=podcast"
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        AF.request(encodedURLString).response { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }
            
            if let data = response.data {
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    completion(.success(searchResult.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func downloadImageFor(_ urlString: String?, completion: @escaping (UIImage) -> Void) {
        guard let urlString = urlString else { return }
        
        let cacheKey = NSString(string: urlString)
        
        if let existingImage = imageCache.object(forKey: cacheKey) {
            completion(existingImage)
        } else {
            guard let url = URL(string: urlString) else { return }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let _ = error { return }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
                
                if let data = data {
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: cacheKey)
                        completion(image)
                    }
                }
            }.resume()
        }
    }
}
