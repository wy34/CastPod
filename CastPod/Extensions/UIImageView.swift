//
//  UIImageView.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit

extension UIImageView {
    func setImage(with url: String?, completion: ((UIImage?) -> Void)?) {
        APIManager.shared.downloadImageFor(url) { image in
            DispatchQueue.main.async {
                self.image = image
                completion?(image)
            }
        }
    }
}
