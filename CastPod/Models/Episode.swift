//
//  Episode.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import Foundation
import FeedKit

struct Episode {
    let title: String?
    let description: String?
    let pubDate: Date?
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title
        self.description = feedItem.iTunes?.iTunesSummary
        self.pubDate = feedItem.pubDate
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
}
