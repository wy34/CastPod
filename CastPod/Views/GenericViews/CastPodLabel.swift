//
//  CastPodLabel.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit

class CastPodLabel: UILabel {
    // MARK: - Init
    init(text: String, font: UIFont) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
