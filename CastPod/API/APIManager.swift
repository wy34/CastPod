//
//  APIManager.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    
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
}
