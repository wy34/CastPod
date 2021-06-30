//
//  CPSlider.swift
//  CastPod
//
//  Created by William Yeung on 6/29/21.
//

import UIKit

class CPSlider: UISlider {
    // MARK: - Init
    init(minValue: Float, maxValue: Float, image: UIImage? = nil) {
        super.init(frame: .zero)
        self.minimumValue = minValue
        self.maximumValue = maxValue
        self.setThumbImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
