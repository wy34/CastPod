//
//  CastPodView.swift
//  CastPod
//
//  Created by William Yeung on 6/29/21.
//

import UIKit

class CPView: UIView {
    // MARK: - Init
    init(bgColor: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
