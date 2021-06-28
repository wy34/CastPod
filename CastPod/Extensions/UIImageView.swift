//
//  UIImageView.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit

extension UIImageView {
    func setImage(with url: String?, completion: (() -> Void)?) {
        APIManager.shared.downloadImageFor(url) { image in
            DispatchQueue.main.async {
                self.image = image
                completion?()
            }
        }
    }
}
