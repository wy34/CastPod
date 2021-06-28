//
//  CastPodImageview.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit

class CastPodImageView: UIImageView {
    // MARK: - Init
    init(image: UIImage?, contentMode: UIImageView.ContentMode) {
        super.init(frame: .zero)
        self.image = image
        self.contentMode = contentMode
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
