//
//  CastPodButton.swift
//  CastPod
//
//  Created by William Yeung on 6/29/21.
//

import UIKit

class CPButton: UIButton {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, bgColor: UIColor, font: UIFont) {
        super.init(frame: .zero)
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.titleLabel?.font = font
    }
    
    init(image: UIImage?, font: UIFont, tintColor: UIColor) {
        super.init(frame: .zero)
        self.init(type: .system)
        self.setImage(image?.applyingSymbolConfiguration(.init(font: font)), for: .normal)
        self.tintColor = tintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
