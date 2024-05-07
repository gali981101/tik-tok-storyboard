//
//  VideoClips.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/24.
//

import UIKit
import AVKit

struct VideoClips: Equatable {
    let videoUrl: URL
    let cameraPosition: AVCaptureDevice.Position
    
    // MARK: - init
    
    init(videoUrl: URL, cameraPosition: AVCaptureDevice.Position?) {
        self.videoUrl = videoUrl
        self.cameraPosition = cameraPosition ?? .back
    }
}

// MARK: - Static Func

extension VideoClips {
    
    static func == (lhs: VideoClips, rhs: VideoClips) -> Bool {
        return lhs.videoUrl == rhs.videoUrl && lhs.cameraPosition == rhs.cameraPosition
    }
    
}
