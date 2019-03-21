
import UIKit

public class CameraView: UIView {
    
    var onExit: (() -> Void)?
    
    var onCapturePhoto: ((String, Int, Int, Int) -> Void)?
    
    var onRecordVideo: ((String, Int, Int, String, Int, Int, Int) -> Void)?
    
    var onPermissionsGranted: (() -> Void)?
    
    var onPermissionsDenied: (() -> Void)?
    
    var onPermissionsNotGranted: (() -> Void)?

    var onRecordDurationLessThanMinDuration: (() -> Void)?
    
    //
    // MARK: - 拍摄界面
    //
    
    var captureView: CaptureView!
    
    var flashButton = SimpleButton()
    var flipButton = SimpleButton()
    
    var exitButton = SimpleButton()
    var captureButton = CircleView()
    
    lazy var guideLabel: UILabel = {
        return UILabel()
    }()
    
    //
    // MARK: - 选择界面
    //
    
    var previewView = PreviewView()
    
    var chooseView = UIView()
    var chooseViewWidthConstraint: NSLayoutConstraint!
    
    var submitButton = CircleView()
    var cancelButton = CircleView()
    
    //
    // MARK: - 私有属性
    //
    
    private var configuration: CameraViewConfiguration!
    
    private var cameraManager = CameraManager()
    
    private var progressAnimation: CABasicAnimation!
    
    private var cameraIsReady = false
    
    public convenience init(configuration: CameraViewConfiguration) {
        self.init()
        
        self.configuration = configuration
        self.captureView = CaptureView(configuration: configuration)
        
        cameraManager.photoDir = configuration.photoDir
        cameraManager.videoDir = configuration.videoDir
        cameraManager.videoQuality = configuration.videoQuality
        cameraManager.videoMinDuration = configuration.videoMinDuration
        cameraManager.videoMaxDuration = configuration.videoMaxDuration
        
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        cameraManager.onDeviceReady = {
            self.captureView.bind(
                session: self.cameraManager.captureSession,
                orientation: self.cameraManager.getVideoOrientation(deviceOrientation: self.cameraManager.deviceOrientation)
            )
            self.cameraIsReady = true
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
            self.onPermissionsGranted?()
        }
        
        cameraManager.onPermissionsDenied = {
            self.onPermissionsDenied?()
        }
        
        cameraManager.onPermissionsNotGranted = {
            self.onPermissionsNotGranted?()
        }
        
        cameraManager.onRecordVideoDurationLessThanMinDuration = {
            self.onRecordDurationLessThanMinDuration?()
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
                self.previewView.video = videoPath
                return
            }
            
            self.showControls()
            
        }
        
        addCaptureView()
        addPreviewView()
        
    }
    
    private func showPreviewView() {
        
        // 经测试，3.2 个圆是个不错的宽度
        chooseViewWidthConstraint.constant = 3.2 * 2 * configuration.captureButtonCenterRadiusNormal
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.chooseView.layoutIfNeeded()
                self.chooseView.alpha = 1
                
                self.flashButton.alpha = 0
                self.flipButton.alpha = 0
                self.exitButton.alpha = 0
                self.captureButton.alpha = 0
            },
            completion: { _ in
                self.flashButton.isHidden = true
                self.flipButton.isHidden = true
                self.exitButton.isHidden = true
                self.captureButton.isHidden = true
            }
        )
        
        previewView.isHidden = false
        captureView.isHidden = true
        
    }
    
    private func hidePreviewView() {
        
        chooseViewWidthConstraint.constant = 0
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.chooseView.layoutIfNeeded()
                self.chooseView.alpha = 0
                
                self.flashButton.alpha = 1
                self.flipButton.alpha = 1
                self.exitButton.alpha = 1
                self.captureButton.alpha = 1
            },
            completion: nil
        )
        
        captureView.isHidden = false
        flashButton.isHidden = false
        flipButton.isHidden = false
        exitButton.isHidden = false
        captureButton.isHidden = false
        
        previewView.isHidden = true
        
        previewView.image = nil
        previewView.video = ""
        
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
            guard self.cameraIsReady else {
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
            self.onExit?()
        }
        
    }
    
    private func addGuideLabel() {
        
        if configuration.guideLabelTitle.isEmpty {
            return
        }
        
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
        if configuration.guideLabelFadeOutDelay > 0 {
            Timer.scheduledTimer(
                timeInterval: configuration.guideLabelFadeOutDelay,
                target: self,
                selector: #selector(CameraView.onGuideLabelFadeOut),
                userInfo: nil,
                repeats: false
            )
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
        
        chooseView.alpha = 0
        chooseView.translatesAutoresizingMaskIntoConstraints = false
        chooseView.clipsToBounds = true
        addSubview(chooseView)
        
        chooseViewWidthConstraint = NSLayoutConstraint(item: chooseView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        
        addSubmitButton()
        addCancelButton()
        
        addConstraints([
            NSLayoutConstraint(item: chooseView, attribute: .height, relatedBy: .equal, toItem: submitButton, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chooseView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chooseView, attribute: .centerY, relatedBy: .equal, toItem: captureButton, attribute: .centerY, multiplier: 1, constant: 0),
            chooseViewWidthConstraint
        ])
        
    }
    
    private func addSubmitButton() {
        
        submitButton.delegate = self
        submitButton.centerRadius = configuration.submitButtonCenterRadius
        submitButton.centerColor = configuration.submitButtonCenterColor
        submitButton.ringWidth = 0
        submitButton.centerImage = configuration.submitButtonImage
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        chooseView.addSubview(submitButton)
        
        chooseView.addConstraints([
            NSLayoutConstraint(item: submitButton, attribute: .right, relatedBy: .equal, toItem: chooseView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: submitButton, attribute: .centerY, relatedBy: .equal, toItem: chooseView, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
    }
    
    private func addCancelButton() {
       
        cancelButton.delegate = self
        cancelButton.centerRadius = configuration.cancelButtonCenterRadius
        cancelButton.centerColor = configuration.cancelButtonCenterColor
        cancelButton.ringWidth = 0
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
// MARK: - 私有方法
//

extension CameraView {
    
    private func submit() {
        
        let photoQuality = configuration.photoQuality
        
        if let photo = cameraManager.photo {
            // 保存图片
            cameraManager.saveToDisk(image: photo, compressionQuality: photoQuality) { path, size in
                self.onCapturePhoto?(path, size, Int(photo.size.width), Int(photo.size.height))
            }
        }
        else if let photo = cameraManager.getVideoFirstFrame(videoPath: cameraManager.videoPath) {
            guard let videoData = NSData(contentsOfFile: cameraManager.videoPath) else {
                return
            }
            // 保存视频截图
            cameraManager.saveToDisk(image: photo, compressionQuality: photoQuality) { path, size in
                self.onRecordVideo?(
                    cameraManager.videoPath,
                    videoData.length,
                    cameraManager.videoDuration,
                    path,
                    size,
                    Int(photo.size.width),
                    Int(photo.size.height)
                )
            }
        }
        
    }
    
    private func startRecordVideo() {
        
        cameraManager.startRecordVideo()
        
        if cameraManager.isVideoRecording {
            
            captureButton.centerRadius = configuration.captureButtonCenterRadiusRecording
            captureButton.ringWidth = configuration.captureButtonRingWidthRecording
            captureButton.trackValue = 0
            
            progressAnimation = CABasicAnimation(keyPath: #keyPath(CircleLayer.trackValue))
            progressAnimation.fromValue = 0.0
            progressAnimation.toValue = 1.0
            progressAnimation.delegate = self
            progressAnimation.duration = Double(configuration.videoMaxDuration) / 1000
            captureButton.layer.add(progressAnimation, forKey: #keyPath(CircleLayer.trackValue))
            
            hideControls()
            
        }
        
    }
    
    private func stopRecordVideo() {
        
        guard cameraManager.isVideoRecording else {
            return
        }
        
        cameraManager.stopRecordVideo()
        
        captureButton.layer.removeAnimation(forKey: #keyPath(CircleLayer.trackValue))
        
        captureButton.centerRadius = configuration.captureButtonCenterRadiusNormal
        captureButton.ringWidth = configuration.captureButtonRingWidthNormal
        captureButton.trackValue = 0

    }
    
    private func showControls() {
        flipButton.isHidden = false
        flashButton.isHidden = false
        exitButton.isHidden = false
    }
    
    private func hideControls() {
        flipButton.isHidden = true
        flashButton.isHidden = true
        exitButton.isHidden = true
    }
    
    @objc private func onGuideLabelFadeOut() {
        
        // 引导文字淡出消失
        UIView.animate(
            withDuration: 1,
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
        if circleView == captureButton && configuration.captureMode != .photo {
            // 长按触发录制视频
            startRecordVideo()
        }
    }
    
    public func circleViewDidLongPressEnd(_ circleView: CircleView) {
        if circleView == captureButton {
            stopRecordVideo()
        }
    }
    
    public func circleViewDidTouchDown(_ circleView: CircleView) {
        if circleView == captureButton {
            circleView.centerColor = configuration.captureButtonCenterColorPressed
            circleView.setNeedsDisplay()
        }
    }
    
    public func circleViewDidTouchEnter(_ circleView: CircleView) {
        if circleView == captureButton {
            circleView.centerColor = configuration.captureButtonCenterColorPressed
            circleView.setNeedsDisplay()
        }
    }
    
    public func circleViewDidTouchLeave(_ circleView: CircleView) {
        if circleView == captureButton {
            circleView.centerColor = configuration.captureButtonCenterColorNormal
            circleView.setNeedsDisplay()
        }
    }
    
    public func circleViewDidTouchUp(_ circleView: CircleView, _ inside: Bool, _ isLongPress: Bool) {
        
        if inside && circleView == captureButton {
            circleView.centerColor = configuration.captureButtonCenterColorNormal
            circleView.setNeedsDisplay()
        }
        
        guard inside, !isLongPress else {
            return
        }
        
        if circleView == captureButton {
            // 纯视频拍摄需要长按
            if configuration.captureMode != .video {
                cameraManager.capturePhoto()
            }
        }
        else if circleView == cancelButton {
            hidePreviewView()
        }
        else if circleView == submitButton {
            hidePreviewView()
            submit()
        }
    }
    
}

extension CameraView: CAAnimationDelegate {
    
    // 这里只能这样写，否则动画结束时不会调这里
    @objc func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopRecordVideo()
    }
    
}
