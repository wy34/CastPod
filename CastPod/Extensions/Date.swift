//
//  Date.swift
//  CastPod
//
//  Created by William Yeung on 6/29/21.
//

import Foundation

extension Date {
    func stringWith(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
