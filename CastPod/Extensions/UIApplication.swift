//
//  UIApplication.swift
//  CastPod
//
//  Created by William Yeung on 6/29/21.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow {
        return self.windows.filter({ $0.isKeyWindow }).first ?? UIWindow(frame: .zero)
    }
    
    var rootViewController: RootTabBarController? {
        return keyWindow.rootViewController as? RootTabBarController
    }
}
