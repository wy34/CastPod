//
//  CastPodImageview.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit

class CPImageView: UIImageView {
    // MARK: - Init
    init(image: UIImage?, contentMode: UIImageView.ContentMode) {
        super.init(frame: .zero)
        self.image = image
        self.contentMode = contentMode
    }
    
    init(image: UIImage?, contentMode: UIImageView.ContentMode, font: UIFont) {
        super.init(frame: .zero)
        self.image = image?.applyingSymbolConfiguration(.init(font: font))
        self.contentMode = contentMode
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
