//
//  PreviewCaptureVC.swift
//  TikTok
//
//  Created by Terry Jason on 2024/5/1.
//

import UIKit

// MARK: - PreviewCaptureVC

final class PreviewCaptureVC: UIViewController {
    
    // MARK: - Properties
    
    var viewWillDeinitRestartVideoSession: (() -> Void)?
    
    private let recordedClips: [VideoClips]
    private var currentPlayingVideoClip: VideoClips
    
    // MARK: - init
    
    init?(coder: NSCoder, recordedClips: [VideoClips]) {
        self.currentPlayingVideoClip = recordedClips.first!
        self.recordedClips = recordedClips
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(K.initText.deinitText)
        (viewWillDeinitRestartVideoSession)?()
    }
    
}

// MARK: - Life Cycle

extension PreviewCaptureVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(recordedClips.count)")
    }
    
}
