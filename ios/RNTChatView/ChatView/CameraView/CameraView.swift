
import UIKit

public class CameraView: UIView {
    
    var delegate: CameraViewDelegate!
    
    //
    // MARK: - 拍摄界面
    //
    
    var captureView: CaptureView!
    
    var flashButton = SimpleButton()
    var flipButton = SimpleButton()
    
    var exitButton = SimpleButton()
    var captureButton = CircleView()
    var guideLabel = UILabel()
    
    //
    // MARK: - 选择界面
    //
    
    var previewView = PreviewView()
    
    var chooseView = UIView()
    var chooseViewWidthConstraint: NSLayoutConstraint!
    
    var okButton = CircleView()
    var cancelButton = CircleView()
    
    //
    // MARK: - 私有属性
    //
    
    private var configuration: CameraViewConfiguration!
    
    private var cameraManager = CameraManager()
    
    private var cameraIsReady = false
    
    private var cameraIsCapturing = false
    
    private var recordingTimer: Timer?
    
    public convenience init(configuration: CameraViewConfiguration) {
        self.init()
        self.configuration = configuration
        self.captureView = CaptureView(configuration: configuration)
        cameraManager.configuration = configuration
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        cameraManager.onDeviceReady = {
            self.captureView.bind(
                session: self.cameraManager.captureSession,
                orientation: self.cameraManager.getVideoOrientation(deviceOrientation: self.cameraManager.deviceOrientation)
            )
            self.cameraIsReady = true
            self.cameraIsCapturing = true
        }
        
        cameraManager.onFlashModeChange = {
            
            switch self.cameraManager.flashMode {
            case .auto:
                self.flashButton.setImage(self.configuration.flashAutoImage, for: .normal)
                break
            case .on:
                self.flashButton.setImage(self.configuration.flashOnImage, for: .normal)
                break
            case .off:
                self.flashButton.setImage(self.configuration.flashOffImage, for: .normal)
                break
            }
            
        }
        
        cameraManager.onPermissionsGranted = {
            self.delegate.cameraViewDidPermissionsGranted(self)
        }
        
        cameraManager.onPermissionsDenied = {
            self.delegate.cameraViewDidPermissionsDenied(self)
        }
        
        cameraManager.onCaptureWithoutPermissions = {
            self.delegate.cameraViewWillCaptureWithoutPermissions(self)
        }
        
        cameraManager.onRecordVideoDurationLessThanMinDuration = {
            self.delegate.cameraViewDidRecordDurationLessThanMinDuration(self)
        }
        
        cameraManager.onFinishCapturePhoto = { (photo, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let photo = photo {
                self.showPreviewView()
                self.previewView.image = photo
            }
        }
        
        cameraManager.onFinishRecordVideo = { (videoPath, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let videoPath = videoPath {
                self.showPreviewView()
                self.previewView.startVideoPlaying(videoPath: videoPath)
            }
            self.stopRecordingTimer()
        }
        
        addCaptureView()
        addPreviewView()
        
    }
    
    private func showPreviewView() {
        
        chooseViewWidthConstraint.constant = 230
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.chooseView.layoutIfNeeded()
                self.flashButton.alpha = 0
                self.flipButton.alpha = 0
                self.captureButton.alpha = 0
                self.exitButton.alpha = 0
                self.cancelButton.alpha = 1
                self.okButton.alpha = 1
            },
            completion: { _ in
                self.flashButton.isHidden = true
                self.flipButton.isHidden = true
                self.captureButton.isHidden = true
                self.exitButton.isHidden = true
            }
        )
        
        previewView.isHidden = false
        captureView.isHidden = true
        
        cameraIsCapturing = false
        
    }
    
    private func hidePreviewView() {
        
        chooseViewWidthConstraint.constant = 0
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.chooseView.layoutIfNeeded()
                self.flashButton.alpha = 1
                self.flipButton.alpha = 1
                self.captureButton.alpha = 1
                self.exitButton.alpha = 1
                self.cancelButton.alpha = 0
                self.okButton.alpha = 0
            },
            completion: { _ in
                self.flashButton.isHidden = false
                self.flipButton.isHidden = false
                self.captureButton.isHidden = false
                self.exitButton.isHidden = false
            }
        )
        
        previewView.isHidden = true
        captureView.isHidden = false
        
        if previewView.image != nil {
            previewView.image = nil
        }
        else {
            previewView.stopVideoPlaying()
        }
        
        cameraIsCapturing = true
        
    }
    
    public func requestPermissions() -> Bool {
        return cameraManager.requestPermissions()
    }
    
    public override func layoutSubviews() {
        
        let currentDevice = UIDevice.current
        let orientation = currentDevice.orientation
        
        if !orientation.isFlat {
            cameraManager.deviceOrientation = orientation
            captureView.updateLayer(orientation: cameraManager.getVideoOrientation(deviceOrientation: orientation))
        }
        
    }
    
}

//
// MARK: - 界面搭建
//

extension CameraView {
    
    private func addCaptureView() {
        
        captureView.translatesAutoresizingMaskIntoConstraints = false
        
        captureView.onFocusPointChange = {
            guard self.cameraIsReady, self.cameraIsCapturing else {
                return
            }
            do {
                if try self.cameraManager.focus(point: $1) {
                    self.captureView.moveFocusView(to: $0)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        captureView.onZoomStart = {
            self.cameraManager.startZoom()
        }
        
        captureView.onZoomFactorChange = {
            try! self.cameraManager.zoom(factor: $0)
        }
        
        addSubview(captureView)
        
        addConstraints([
            NSLayoutConstraint(item: captureView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: captureView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: captureView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: captureView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
        ])
        
        addFlipButton()
        addFlashButton()
        
        addCaptureButton()
        addExitButton()
        addGuideLabel()

    }
    
    private func addFlipButton() {
        
        flipButton.setImage(configuration.flipButtonImage, for: .normal)
        flipButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(flipButton)
        
        addConstraints([
            NSLayoutConstraint(item: flipButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: configuration.flipButtonMarginTop),
            NSLayoutConstraint(item: flipButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -configuration.flipButtonMarginRight),
            NSLayoutConstraint(item: flipButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.flipButtonWidth),
            NSLayoutConstraint(item: flipButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.flipButtonHeight),
        ])
        
        flipButton.onClick = {
            switch self.cameraManager.cameraPosition {
            case .front:
                try? self.cameraManager.switchToBackCamera()
                break
            case .back:
                try? self.cameraManager.switchToFrontCamera()
                break
            case .unspecified:
                try? self.cameraManager.switchToBackCamera()
                break
            }
        }
        
    }
    
    private func addFlashButton() {
        
        flashButton.setImage(configuration.flashOffImage, for: .normal)
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(flashButton)
        
        addConstraints([
            NSLayoutConstraint(item: flashButton, attribute: .centerY, relatedBy: .equal, toItem: flipButton, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: flashButton, attribute: .right, relatedBy: .equal, toItem: flipButton, attribute: .left, multiplier: 1, constant: -configuration.flashButtonMarginRight),
            NSLayoutConstraint(item: flashButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.flashButtonWidth),
            NSLayoutConstraint(item: flashButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.flashButtonHeight),
        ])
        
        flashButton.onClick = {
            switch self.cameraManager.flashMode {
            case .auto:
                self.cameraManager.setFlashMode(.on)
                break
            case .on:
                self.cameraManager.setFlashMode(.off)
                break
            case .off:
                self.cameraManager.setFlashMode(.auto)
                break
            }
        }
        
    }
    
    private func addCaptureButton() {
        
        captureButton.delegate = self
        captureButton.centerRadius = configuration.captureButtonCenterRadiusNormal
        captureButton.centerColor = configuration.captureButtonCenterColorNormal
        captureButton.ringWidth = configuration.captureButtonRingWidthNormal
        captureButton.ringColor = configuration.captureButtonRingColor
        captureButton.trackWidth = configuration.captureButtonTrackWidth
        captureButton.trackColor = configuration.captureButtonTrackColor
        
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(captureButton)
        
        addConstraints([
            NSLayoutConstraint(item: captureButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: captureButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -configuration.captureButtonMarginBottom),
        ])
        
    }
    
    private func addExitButton() {
        
        exitButton.setImage(configuration.exitButtonImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(exitButton)
        
        addConstraints([
            NSLayoutConstraint(item: exitButton, attribute: .centerY, relatedBy: .equal, toItem: captureButton, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: exitButton, attribute: .right, relatedBy: .equal, toItem: captureButton, attribute: .left, multiplier: 1, constant: -configuration.exitButtonMarginRight),
            NSLayoutConstraint(item: exitButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.exitButtonWidth),
            NSLayoutConstraint(item: exitButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.exitButtonHeight),
        ])
        
        exitButton.onClick = {
            self.delegate.cameraViewDidExit(self)
        }
        
    }
    
    private func addGuideLabel() {
        
        guideLabel.text = configuration.guideLabelTitle
        guideLabel.textColor = configuration.guideLabelTextColor
        guideLabel.font = configuration.guideLabelTextFont
        
        guideLabel.sizeToFit()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(guideLabel)
        
        addConstraints([
            NSLayoutConstraint(item: guideLabel, attribute: .centerX, relatedBy: .equal, toItem: captureButton, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: guideLabel, attribute: .bottom, relatedBy: .equal, toItem: captureButton, attribute: .top, multiplier: 1, constant: -configuration.guideLabelMarginBottom)
        ])
        
        // N 秒后淡出
        if configuration.guideLabelFadeOutInterval > 0 {
            Timer.scheduledTimer(timeInterval: configuration.guideLabelFadeOutInterval, target: self, selector: #selector(CameraView.onGuideLabelFadeOut), userInfo: nil, repeats: false)
        }
        
    }
    
    private func addPreviewView() {
        
        previewView.isHidden = true
        previewView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(previewView)
        
        addConstraints([
            NSLayoutConstraint(item: previewView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
        ])
        
        addChooseView()
        
    }
    
    private func addChooseView() {
        
        chooseView.translatesAutoresizingMaskIntoConstraints = false
        chooseView.clipsToBounds = true
        addSubview(chooseView)
        
        chooseViewWidthConstraint = NSLayoutConstraint(item: chooseView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        
        addOkButton()
        addCancelButton()
        
        addConstraints([
            NSLayoutConstraint(item: chooseView, attribute: .height, relatedBy: .equal, toItem: okButton, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chooseView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chooseView, attribute: .centerY, relatedBy: .equal, toItem: captureButton, attribute: .centerY, multiplier: 1, constant: 0),
            chooseViewWidthConstraint
        ])
        
    }
    
    private func addOkButton() {
        
        okButton.alpha = 0
        okButton.delegate = self
        okButton.centerRadius = configuration.okButtonCenterRadius
        okButton.centerColor = configuration.okButtonCenterColor
        okButton.ringWidth = configuration.okButtonRingWidth
        okButton.centerImage = configuration.okButtonImage
        
        okButton.translatesAutoresizingMaskIntoConstraints = false
        chooseView.addSubview(okButton)
        
        chooseView.addConstraints([
            NSLayoutConstraint(item: okButton, attribute: .right, relatedBy: .equal, toItem: chooseView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: okButton, attribute: .centerY, relatedBy: .equal, toItem: chooseView, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
    }
    
    private func addCancelButton() {
        
        cancelButton.alpha = 0
        cancelButton.delegate = self
        cancelButton.centerRadius = configuration.cancelButtonCenterRadius
        cancelButton.centerColor = configuration.cancelButtonCenterColor
        cancelButton.ringWidth = configuration.cancelButtonRingWidth
        cancelButton.centerImage = configuration.cancelButtonImage
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        chooseView.addSubview(cancelButton)
        
        chooseView.addConstraints([
            NSLayoutConstraint(item: cancelButton, attribute: .left, relatedBy: .equal, toItem: chooseView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cancelButton, attribute: .centerY, relatedBy: .equal, toItem: chooseView, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
    }
    
}

//
// MARK: - 录制视频的定时器
//

extension CameraView {
    
    func startRecordingTimer() {
        // 一毫秒执行一次
        recordingTimer = Timer.scheduledTimer(timeInterval: 1 / 1000, target: self, selector: #selector(CameraView.onRecordingDurationUpdate), userInfo: nil, repeats: true)

        captureButton.centerRadius = configuration.captureButtonCenterRadiusRecording
        captureButton.ringWidth = configuration.captureButtonRingWidthRecording
        captureButton.trackValue = 0
        captureButton.setNeedsLayout()
        captureButton.setNeedsDisplay()
    }
    
    private func stopRecordingTimer() {
        guard let timer = recordingTimer else {
            return
        }
        timer.invalidate()
        self.recordingTimer = nil
        
        captureButton.centerRadius = configuration.captureButtonCenterRadiusNormal
        captureButton.ringWidth = configuration.captureButtonRingWidthNormal
        captureButton.trackValue = 0
        captureButton.setNeedsLayout()
        captureButton.setNeedsDisplay()
    }
    
    @objc private func onRecordingDurationUpdate() {
        
        let currentTime = cameraManager.videoCurrentTime

        captureButton.trackValue = Double(currentTime) / Double(configuration.videoMaxDuration)
        captureButton.setNeedsDisplay()
        
        if currentTime >= configuration.videoMaxDuration {
            cameraManager.stopRecordVideo()
        }
        
    }
    
    @objc private func onGuideLabelFadeOut() {
        
        // 引导文字淡出消失
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.guideLabel.alpha = 0
            },
            completion: { _ in
                 self.guideLabel.isHidden = true
            }
        )
        
    }
    
}

//
// MARK: - 圆形按钮的事件响应
//

extension CameraView: CircleViewDelegate {

    public func circleViewDidLongPressStart(_ circleView: CircleView) {
        if circleView == captureButton {
            // 长按触发录制视频
            cameraManager.startRecordVideo()
            if cameraManager.isVideoRecording {
                startRecordingTimer()
            }
        }
    }
    
    public func circleViewDidLongPressEnd(_ circleView: CircleView) {
        if circleView == captureButton {
            if cameraManager.isVideoRecording {
                cameraManager.stopRecordVideo()
            }
        }
    }
    
    public func circleViewDidTouchUp(_ circleView: CircleView, _ inside: Bool, _ isLongPress: Bool) {
        guard inside, !isLongPress else {
            return
        }
        if circleView == captureButton {
            cameraManager.capturePhoto()
        }
        else if circleView == cancelButton {
            hidePreviewView()
        }
        else if circleView == okButton {
            hidePreviewView()
            if let photo = cameraManager.photo {
                // 保存图片
                if let photoPath = cameraManager.saveToDisk(image: photo) {
                    delegate.cameraViewDidPickPhoto(
                        self,
                        photoPath: photoPath,
                        photoWidth: photo.size.width,
                        photoHeight: photo.size.height
                    )
                }
            }
            else if let photo = cameraManager.getVideoFirstFrame(videoPath: cameraManager.videoPath) {
                // 保存视频截图
                if let photoPath = cameraManager.saveToDisk(image: photo) {
                    delegate.cameraViewDidPickVideo(
                        self,
                        videoPath: cameraManager.videoPath,
                        videoDuration: cameraManager.videoDuration,
                        photoPath: photoPath,
                        photoWidth: photo.size.width,
                        photoHeight: photo.size.height
                    )
                }
            }
        }
    }
    
}
