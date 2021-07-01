//
//  CMTime.swift
//  CastPod
//
//  Created by William Yeung on 6/30/21.
//

import AVKit

extension CMTime {
    func toFormattedString() -> String {
        let totalTimeInSeconds = Int(CMTimeGetSeconds(self))
        
        let seconds = totalTimeInSeconds % 60
        let minutes = (totalTimeInSeconds / 60) % 60
        let hours = totalTimeInSeconds / 3600
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
