//
//  SearchResult.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
