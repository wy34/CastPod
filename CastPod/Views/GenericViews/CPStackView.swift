//
//  CastPodStackView.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit

class CPStackView: UIStackView {
    // MARK: - Init
    init(views: [UIView], axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .center) {
        super.init(frame: .zero)
        views.forEach({ self.addArrangedSubview($0) })
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
