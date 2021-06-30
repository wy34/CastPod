//
//  ExpandableSection.swift
//  CastPod
//
//  Created by William Yeung on 6/30/21.
//

import Foundation

class ExpandableSection {
    let title: String
    var cellTitles: [String]
    var isOpen = false

    init(title: String, cellTitles: [String]) {
        self.title = title
        self.cellTitles = cellTitles
    }
}
