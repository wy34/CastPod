//
//  Podcast.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import Foundation


struct Podcast: Codable {
    let artistName: String?
    let trackName: String?
    let artworkUrl600: String?
    let trackCount: Int?
    let feedUrl: String?
}
