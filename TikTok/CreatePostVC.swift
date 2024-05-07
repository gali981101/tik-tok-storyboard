//
//  CreatePostVC.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/21.
//

import UIKit
import AVFoundation

// MARK: - CreatePostVC

final class CreatePostVC: UIViewController {
    
    // MARK: - Properties
    
    private let photoFileOutput = AVCapturePhotoOutput()
    private let captureSession = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()
    
    private lazy var isRecording: Bool = false
    private lazy var videoDurationOfLastClip: Int = 0
    private lazy var total_RecordedTime_In_Secs: Int = 0
    private lazy var total_RecordedTime_In_Minutes: Int = 0
    private lazy var recordedClips: [VideoClips] = []
    private lazy var segmentedProgressView = SegmentedProgressView(width: view.frame.width - 17.5)
    
    private var activeInput: AVCaptureDeviceInput!
    private var outPutURL: URL!
    private var currentCameraDevice: AVCaptureDevice?
    private var thumbnailImage: UIImage?
    private var recordingTimer: Timer?
    
    private var currentMaxRecordingDuration: Int = 15 {
        didSet {
            timeCounterLabel.text = "\(currentMaxRecordingDuration)"
        }
    }
    
    // MARK: - @IBOulet
    
    @IBOutlet weak var filpCameraLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var beautyLabel: UILabel!
    @IBOutlet weak var filtersLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var flashLabel: UIButton!
    @IBOutlet weak var timeCounterLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var filpCameraButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var beautyButton: UIButton!
    @IBOutlet weak var filtersButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    @IBOutlet weak var effectsButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    
    @IBOutlet weak var soundsView: UIView!
    @IBOutlet weak var captureButtonRingView: UIView!
    
}

// MARK: - Life Cycle

extension CreatePostVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

// MARK: - Set

extension CreatePostVC {
    
    private func setUp() {
        segmentedProgressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedProgressView)
        
        if setUpCaptureSession() {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                self.captureSession.startRunning()
            }
        }
        
        timeCounterLabel.backgroundColor = .black.withAlphaComponent(0.42)
        timeCounterLabel.layer.cornerRadius = 15
        timeCounterLabel.layer.borderColor = UIColor.white.cgColor
        timeCounterLabel.layer.borderWidth = 1.8
        timeCounterLabel.clipsToBounds = true
        
        captureButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        captureButton.layer.cornerRadius = 68 / 2
        
        saveButton.alpha = 0
        discardButton.alpha = 0
        
        captureButtonRingView.layer.borderColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 0.5).cgColor
        captureButtonRingView.layer.borderWidth = 6
        captureButtonRingView.layer.cornerRadius = 85 / 2
        
        soundsView.layer.cornerRadius = 12
        
        segmentedProgressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        segmentedProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedProgressView.widthAnchor.constraint(equalToConstant: view.frame.width - 17.5).isActive = true
        segmentedProgressView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        [filtersLabel, speedLabel, beautyLabel, filtersLabel, timerLabel, flashLabel, timeCounterLabel, cancelButton, filpCameraButton, speedButton, beautyButton, filtersButton, timerButton, flashButton, effectsButton, captureButton, galleryButton, saveButton, discardButton, soundsView, captureButtonRingView, segmentedProgressView]
            .forEach { subView in
                subView?.layer.zPosition = 1
            }
    }
    
    private func setUpCaptureSession() -> Bool {
        captureSession.sessionPreset = .high
        
        // Setup inputs
        guard let captureVideoDevice = AVCaptureDevice.default(for: .video),
              let captureAudioDevice = AVCaptureDevice.default(for: .audio) else { fatalError() }
        
        do {
            let inputVideo = try AVCaptureDeviceInput(device: captureVideoDevice)
            let inputAudio = try AVCaptureDeviceInput(device: captureAudioDevice)
            
            if captureSession.canAddInput(inputVideo) {
                captureSession.addInput(inputVideo)
                activeInput = inputVideo
            }
            if captureSession.canAddInput(inputAudio) { captureSession.addInput(inputAudio) }
            
            if captureSession.canAddOutput(movieOutput) { captureSession.addOutput(movieOutput) }
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        // Setup outputs
        if captureSession.canAddOutput(photoFileOutput) { captureSession.addOutput(photoFileOutput) }
        
        // Setup output previews
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        
        return true
    }
    
}

// MARK: - @IBAction

extension CreatePostVC {
    
    @IBAction func handleDismiss(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func filpButtonDidTapped(_ sender: Any) {
        captureSession.beginConfiguration()
        
        let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        
        let newCameraDevice = currentInput?.device.position == .back ?
        getDeviceFront(position: .front) : getDeviceBack(position: .back)
        
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        
        guard let inputs = captureSession.inputs as? [AVCaptureDeviceInput] else { return }
        
        for input in inputs {
            captureSession.removeInput(input)
        }
        
        if captureSession.inputs.isEmpty {
            captureSession.addInput(newVideoInput!)
            activeInput = newVideoInput
        }
        
        if let microphone = AVCaptureDevice.default(for: .audio) {
            do {
                let micInput = try AVCaptureDeviceInput(device: microphone)
                if captureSession.canAddInput(micInput) { captureSession.addInput(micInput) }
            } catch let error {
                fatalError(error.localizedDescription)
            }
        }
        
        captureSession.commitConfiguration()
    }
    
    @IBAction func captureButtonDidTapped(_ sender: Any) {
        handleDidTapRecord()
    }
    
    @IBAction func discardButtonDidTapped(_ sender: Any) {
        let alertVC = UIAlertController(title: K.AlertTitle.discardClip, message: nil, preferredStyle: .alert)
        
        let discardAction = UIAlertAction(title: K.AlertAction.discard, style: .default) { [weak self] _ in
            self?.handleDiscardLastRecordedClip()
        }
        
        let keepAction = UIAlertAction(title: K.AlertAction.keep, style: .cancel) { _ in
        }
        
        alertVC.addAction(discardAction)
        alertVC.addAction(keepAction)
        
        present(alertVC, animated: true)
    }
    
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        let previewVC = UIStoryboard(name: K.Storyboard.main, bundle: .main)
            .instantiateViewController(identifier: K.Identifier.previewVC) { coder -> PreviewCaptureVC? in
                PreviewCaptureVC(coder: coder, recordedClips: self.recordedClips)
            }
        
        previewVC.viewWillDeinitRestartVideoSession = { [weak self] in
            guard let self = self else { return }
            
            if self.setUpCaptureSession() { 
                DispatchQueue.global(qos: .background).async { self.captureSession.stopRunning() }
            }
        }
        
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
}

// MARK: - Helper Methods

extension CreatePostVC {
    
    private func getDeviceFront(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    }
    
    private func getDeviceBack(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    }
    
    private func generateVideoThumbnail(withfile videoUrl: URL) -> UIImage? {
        let asset = AVAsset(url: videoUrl)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cmTime = CMTimeMake(value: 1, timescale: 60)
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: cmTime, actualTime: nil)
            
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    private func didTakePicture(_ picture: UIImage, to orientation: UIImage.Orientation) -> UIImage {
        let flippedImage = UIImage(cgImage: picture.cgImage!, scale: picture.scale, orientation: orientation)
        return flippedImage
    }
    
    private func tempUrl() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + K.ContentType.mp4)
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    private func startRecording() {
        if movieOutput.isRecording == true { return }
        guard let connection = movieOutput.connection(with: .video) else { return }
        
        if connection.isVideoRotationAngleSupported(0) {
            connection.preferredVideoStabilizationMode = .auto
            
            let device = activeInput.device
            
            if !(device.isSmoothAutoFocusSupported) { return }
            
            do {
                try device.lockForConfiguration()
                device.isSmoothAutoFocusEnabled = false
                device.unlockForConfiguration()
            } catch {
                print(error.localizedDescription)
            }
            
            outPutURL = tempUrl()
            movieOutput.startRecording(to: outPutURL, recordingDelegate: self)
            handleAnimateRecordButton()
        }
    }
    
    private func stopRecording() {
        if movieOutput.isRecording == false { return }
        movieOutput.stopRecording()
        handleAnimateRecordButton()
        stopTimer()
        segmentedProgressView.pauseProgress()
    }
    
    private func handleAnimateRecordButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self else { return }
            
            if self.isRecording == false {
                self.captureButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.captureButton.layer.cornerRadius = 5
                self.captureButtonRingView.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                
                self.saveButton.alpha = 0
                self.discardButton.alpha = 0
                
                [filtersLabel, speedLabel, beautyLabel, filtersLabel, timerLabel, flashLabel, filpCameraButton, speedButton, beautyButton, filtersButton, timerButton, flashButton, effectsButton, galleryButton, soundsView]
                    .forEach { subView in
                        subView?.isHidden = true
                    }
            } else {
                self.captureButton.transform = CGAffineTransform.identity
                self.captureButton.layer.cornerRadius = 68 / 2
                self.captureButtonRingView.transform = CGAffineTransform.identity
                
                self.handleResetAll()
            }
        }) { [weak self] onComplete in
            guard let self = self else { return }
            self.isRecording = !self.isRecording
        }
    }
    
    private func handleResetAll() {
        if recordedClips.isEmpty {
            [filtersLabel, speedLabel, beautyLabel, filtersLabel, timerLabel, flashLabel, filpCameraButton, speedButton, beautyButton, filtersButton, timerButton, flashButton, effectsButton, galleryButton, soundsView]
                .forEach { subView in
                    subView?.isHidden = false
                }
            
            saveButton.alpha = 0
            discardButton.alpha = 0
        } else {
            [filtersLabel, speedLabel, beautyLabel, filtersLabel, timerLabel, flashLabel, filpCameraButton, speedButton, beautyButton, filtersButton, timerButton, flashButton, effectsButton, galleryButton, soundsView]
                .forEach { subView in
                    subView?.isHidden = true
                }
            
            saveButton.alpha = 1
            discardButton.alpha = 1
        }
    }
    
    private func handleDidTapRecord() {
        movieOutput.isRecording ? stopRecording() : startRecording()
    }
    
    private func handleDiscardLastRecordedClip() {
        outPutURL = nil
        thumbnailImage = nil
        recordedClips.removeLast()
        handleResetAll()
        handleSetNewOutputURLAndThumbnailImage()
        segmentedProgressView.handleRemoveLastSegment()
        
        if recordedClips.isEmpty {
            handleResetTimersAndProgressViewToZero()
        } else if !(recordedClips.isEmpty) {
            handleCalculateDurationLeft()
        }
    }
    
    private func handleSetNewOutputURLAndThumbnailImage() {
        outPutURL = recordedClips.last?.videoUrl
        
        let currentUrl: URL? = outPutURL
        
        guard let currentUrl = currentUrl else { return }
        guard let generatedThumbnailImage = generateVideoThumbnail(withfile: currentUrl) else { return }
        
        if currentCameraDevice?.position == .front {
            thumbnailImage = didTakePicture(generatedThumbnailImage, to: .upMirrored)
        } else {
            thumbnailImage = generatedThumbnailImage
        }
    }
    
}

// MARK: - AVCaptureFileOutputRecordingDelegate

extension CreatePostVC: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        let newRecordedClip = VideoClips(videoUrl: fileURL, cameraPosition: currentCameraDevice?.position)
        recordedClips.append(newRecordedClip)
        startTimer()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error = error { fatalError(error.localizedDescription) }
        
        let urlOfVideoRecorded = outPutURL! as URL
        
        guard let generatedThumbnailImage = generateVideoThumbnail(withfile: urlOfVideoRecorded) else { return }
        
        if currentCameraDevice?.position == .front {
            thumbnailImage = didTakePicture(generatedThumbnailImage, to: .upMirrored)
        } else {
            thumbnailImage = generatedThumbnailImage
        }
    }
    
}

// MARK: - Recording Timer

extension CreatePostVC {
    
    private func startTimer() {
        videoDurationOfLastClip = 0
        stopTimer()
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.timeTick()
        })
    }
    
    private func stopTimer() {
        recordingTimer?.invalidate()
    }
    
    private func timeTick() {
        total_RecordedTime_In_Secs += 1
        videoDurationOfLastClip += 1
        
        let time_limit = currentMaxRecordingDuration * 10
        
        if total_RecordedTime_In_Secs == time_limit {
            handleDidTapRecord()
        }
        
        let startTime: Int = 0
        let trimmedTime: Int = Int(currentMaxRecordingDuration) - startTime
        let positiveOrZero = max(total_RecordedTime_In_Secs, 0)
        let progress = Float(positiveOrZero) / Float(trimmedTime) / 10
        
        segmentedProgressView.setProgress(CGFloat(progress))
        
        let countDownSec: Int = Int(currentMaxRecordingDuration) - total_RecordedTime_In_Secs / 10
        timeCounterLabel.text = "\(countDownSec)s"
    }
    
    private func handleResetTimersAndProgressViewToZero() {
        total_RecordedTime_In_Secs = 0
        total_RecordedTime_In_Minutes = 0
        videoDurationOfLastClip = 0
        stopTimer()
        segmentedProgressView.setProgress(0)
        timeCounterLabel.text = "\(currentMaxRecordingDuration)"
    }
    
    private func handleCalculateDurationLeft() {
        let timeToDiscard = videoDurationOfLastClip
        let currentCombineTime = total_RecordedTime_In_Secs
        let newVideoDuration = currentCombineTime - timeToDiscard
        
        total_RecordedTime_In_Secs = newVideoDuration
        
        let countDownSec: Int = Int(currentMaxRecordingDuration) - total_RecordedTime_In_Secs / 10
        
        timeCounterLabel.text = "\(countDownSec)"
    }
    
}











