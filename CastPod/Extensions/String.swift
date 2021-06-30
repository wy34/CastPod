//
//  String.swift
//  CastPod
//
//  Created by William Yeung on 6/29/21.
//

import Foundation

extension String {
    func removeHTML() -> String? {
        do {
            guard let data = self.data(using: .unicode) else { return nil }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
    
    func removeNewLines() -> String? {
        return self.replacingOccurrences(of: "\n", with: "")
    }
    
    func removeBackSlashes() -> String? {
        return self.replacingOccurrences(of: "\\", with: "")
    }
}
