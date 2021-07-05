//
//  Episode.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import Foundation
import FeedKit

struct Episode: Codable {
    let title: String?
    var artist: String?
    let description: String?
    let pubDate: Date?
    var imageUrl: String?
    var streamUrl: String?
    var localUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title
        self.artist = feedItem.iTunes?.iTunesAuthor
        self.description = feedItem.iTunes?.iTunesSummary
        self.pubDate = feedItem.pubDate
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url
    }
}
