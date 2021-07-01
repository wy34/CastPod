//
//  Constants.swift
//  CastPod
//
//  Created by William Yeung on 6/27/21.
//

import UIKit

struct SFSymbols {
    static let star = UIImage(systemName: "star.fill")!
    static let magnifyingglass = UIImage(systemName: "magnifyingglass")!
    static let download = UIImage(systemName: "arrow.down.circle.fill")!
    static let playButton = UIImage(systemName: "play.fill")!
    static let backward15 = UIImage(systemName: "gobackward.15")!
    static let forward15 = UIImage(systemName: "goforward.15")!
    static let volumeDown = UIImage(systemName: "speaker.wave.2.fill")!
    static let volumeUp = UIImage(systemName: "speaker.wave.3.fill")!
    static let circle = UIImage(systemName: "circle.fill")!
    static let pauseButton = UIImage(systemName: "pause.fill")!
    static let information = UIImage(systemName: "info.circle")!
    static let xmark = UIImage(systemName: "xmark")!
}

struct Asset {
    static let placeholder = #imageLiteral(resourceName: "placeholder")
}

struct Colors {
    static let appTintColor = UIColor.systemBlue
    static let darkModeBackground = UIColor.secondarySystemBackground
    static let darkModeSymbol = UIColor(named: "InverseDarkMode")!
    static let sliderTintColor = UIColor.gray
}
