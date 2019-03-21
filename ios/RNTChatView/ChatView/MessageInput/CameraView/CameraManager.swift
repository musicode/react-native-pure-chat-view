
import UIKit
import AVFoundation

// 支持拍照，录视频

class CameraManager : NSObject {
    
    // 图片保存的目录
    var photoDir = ""
    
    // 视频保存的目录
    var videoDir = ""
    
    // 视频质量
    var videoQuality = VideoQuality.p720
    
    // 视频最短录制时长，单位是毫秒
    var videoMinDuration: Int = 1000
    
    // 视频最大录制时长，单位是毫秒
    var videoMaxDuration: Int = 10000
    
    
    var captureSession = AVCaptureSession()
    
    // 前摄
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    // 后摄
    var backCamera: AVCaptureDevice?
    var backCameraInput: AVCaptureDeviceInput?
    
    // 麦克风
    var microphone: AVCaptureDevice?
    var microphoneInput: AVCaptureDeviceInput?
    
    // 兼容 9 和 10+
    var photoOutput: AVCaptureOutput?
    var videoOutput: AVCaptureMovieFileOutput?
    
    var backgroundRecordingId: UIBackgroundTaskIdentifier?
    
    // 缩放
    var zoomFactor = CGFloat(0) {
        didSet {
            DispatchQueue.main.async {
                self.onZoomFactorChange?()
            }
        }
    }
    
    var lastZoomFactor = CGFloat(1)
    var minZoomFactor = CGFloat(1)
    var maxZoomFactor = CGFloat(5)
    
    // MARK: - 通用配置
    
    // 设备状态
    var deviceOrientation = UIDeviceOrientation.portrait
    
    // 暗光环境下开启自动增强
    var lowHightBoost = true
    
    // 当前的闪光灯模式
    var flashMode = AVCaptureDevice.FlashMode.off {
        didSet {
            DispatchQueue.main.async {
                self.onFlashModeChange?()
            }
        }
    }
    
    // 当前使用的摄像头
    var cameraPosition = AVCaptureDevice.Position.unspecified {
        didSet {
            DispatchQueue.main.async {
                self.onCameraPositionChange?()
            }
        }
    }
    
    // MARK: - 拍照的配置
    
    // 当前拍好的照片
    var photo: UIImage?
    
    // MARK: - 录制视频的配置
    
    // 当前正在录制的视频文件路径
    var videoPath = ""
    
    var videoExtname = ".mp4"
    
    // 录制完成后视频的时长
    var videoDuration: Int = 0
    
    // 录制视频当前的时长
    var videoCurrentTime: Int {
        get {
            guard let output = videoOutput, output.isRecording else {
                return 0
            }
            return seconds2Millisecond(output.recordedDuration.seconds)
        }
    }
    
    //
    // MARK: - 拍照的配置
    //
    
    // Whether to capture still images at the highest resolution supported by the active device and format.
    var isHighResolutionEnabled = true
    
    // 是否可用 live 图片
    var liveMode = CameraLiveMode.off
    
    // live 图片的保存目录
    var livePhotoDir = NSTemporaryDirectory()
    
    //
    // MARK: - 状态
    //
    
    // 视频是否正在录制
    var isVideoRecording = false
    
    // 是否准备就绪
    var isDeviceReady = false
    
    
    //
    // MARK: - 回调
    //
    
    var onDeviceReady: (() -> Void)?
    
    var onFlashModeChange: (() -> Void)?
    
    var onCameraPositionChange: (() -> Void)?
    
    var onZoomFactorChange: (() -> Void)?
    
    var onPermissionsGranted: (() -> Void)?
    
    var onPermissionsDenied: (() -> Void)?
    
    var onPermissionsNotGranted: (() -> Void)?
    
    var onRecordVideoDurationLessThanMinDuration: (() -> Void)?
    
    var onFinishCapturePhoto: ((UIImage?, Error?) -> Void)?
    
    var onFinishRecordVideo: ((String?, Error?) -> Void)?
    
    
    
    //
    // MARK: - 计算属性
    //
    
    // 当前使用的摄像头
    var currentCamera: AVCaptureDevice? {
        get {
            if cameraPosition == .back {
                return backCamera
            }
            else if cameraPosition == .front {
                return frontCamera
            }
            return nil
        }
    }
    
}

extension CameraManager {
    
    // 申请权限
    func requestPermissions() -> Bool {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            if !isDeviceReady {
                prepare { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        DispatchQueue.main.async {
                            self.isDeviceReady = true
                            self.onDeviceReady?()
                        }
                    }
                }
            }
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.onPermissionsGranted?()
                    }
                    else {
                        self.onPermissionsDenied?()
                    }
                }
            }
            break
        default:
            // 拒绝
            break
        }
        
        return false
        
    }
    
    // 拍照
    func capturePhoto() {
        
        guard requestPermissions() else {
            onPermissionsNotGranted?()
            return
        }
        
        if #available(iOS 10.0, *) {
            capturePhoto10()
        }
        else {
            capturePhoto9()
        }
        
    }
    
    // 录制视频
    func startRecordVideo() {
        
        guard requestPermissions() else {
            onPermissionsNotGranted?()
            return
        }
        
        guard let output = videoOutput, !output.isRecording else {
            return
        }
        
        if UIDevice.current.isMultitaskingSupported {
            backgroundRecordingId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        }
        
        let connection = output.connection(with: .video)
        if cameraPosition == .front {
            connection?.isVideoMirrored = true
        }
        
        connection?.videoOrientation = getVideoOrientation(deviceOrientation: deviceOrientation)
        
        if flashMode == .on {
            setTorchMode(.on)
        }
        else if flashMode == .auto {
            setTorchMode(.auto)
        }
        
        // 重置
        photo = nil
        
        videoPath = getFilePath(dirname: videoDir, extname: videoExtname)
        
        output.startRecording(to: URL(fileURLWithPath: videoPath), recordingDelegate: self)
        
        isVideoRecording = true
        
    }
    
    func stopRecordVideo() {
        
        guard let output = videoOutput, output.isRecording else {
            return
        }
        
        output.stopRecording()
        
    }
    
    func switchToFrontCamera() throws {
        
        try configureSession { _ in
            
            guard let device = frontCamera else {
                throw CameraError.invalidOperation
            }
            
            if let input = backCameraInput {
                removeInput(input)
            }
            
            frontCameraInput = try addInput(device: device)
            
            // 拍照和录视频的预设必须一致
            // 否则切换预设时，预览画面的尺寸会变化
            let preset = getVideoPreset(videoQuality: videoQuality)
            captureSession.sessionPreset = captureSession.canSetSessionPreset(preset) ? preset : .high
            
            flashMode = .off
            zoomFactor = 1
            cameraPosition = .front
            
        }
        
    }
    
    func switchToBackCamera() throws {
        
        try configureSession { _ in
            
            guard let device = backCamera else {
                throw CameraError.invalidOperation
            }
            
            if let input = frontCameraInput {
                removeInput(input)
            }
            
            backCameraInput = try addInput(device: device)
            
            let preset = getVideoPreset(videoQuality: videoQuality)
            captureSession.sessionPreset = captureSession.canSetSessionPreset(preset) ? preset : .high
            
            flashMode = .off
            zoomFactor = 1
            cameraPosition = .back
            
        }
        
    }
    
    func setFlashMode(_ flashMode: AVCaptureDevice.FlashMode) {
        
        guard let device = currentCamera else {
            return
        }
        
        if #available(iOS 10.0, *) {
            if let output = photoOutput {
                if (output as! AVCapturePhotoOutput).supportedFlashModes.contains(flashMode) {
                    self.flashMode = flashMode
                }
            }
        }
        else {
            if device.isFlashModeSupported(flashMode) {
                self.flashMode = flashMode
            }
        }
        
    }
    
    func setTorchMode(_ torchMode: AVCaptureDevice.TorchMode) {
        
        guard let device = currentCamera, device.hasTorch else {
            return
        }
        
        do {
            try configureDevice(device) {
                device.torchMode = torchMode
                if torchMode == .on {
                    try device.setTorchModeOn(level: 1.0)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    // 镜头聚焦
    func focus(point: CGPoint) throws -> Bool {
        
        guard let device = currentCamera else {
            return false
        }
        
        let isFocusPointOfInterestSupported = device.isFocusPointOfInterestSupported
        let isExposurePointOfInterestSupported = device.isExposurePointOfInterestSupported
        
        if isFocusPointOfInterestSupported || isExposurePointOfInterestSupported {
            
            try device.lockForConfiguration()
            
            if isFocusPointOfInterestSupported {
                device.focusPointOfInterest = point
            }
            
            if isExposurePointOfInterestSupported {
                device.exposurePointOfInterest = point
            }
            
            device.unlockForConfiguration()
            
            return true
            
        }
        
        return false
        
    }
    
    // 开始缩放，记录当前缩放值作为初始值
    func startZoom() {
        lastZoomFactor = zoomFactor
    }
    
    // 缩放预览窗口
    func zoom(factor: CGFloat) throws {
        
        guard let device = currentCamera else {
            return
        }
        
        try device.lockForConfiguration()
        
        zoomFactor = min(maxZoomFactor, max(minZoomFactor, min(lastZoomFactor * factor, device.activeFormat.videoMaxZoomFactor)))
        
        device.videoZoomFactor = zoomFactor
        
        device.unlockForConfiguration()
        
    }
    
    private func prepare(completionHandler: @escaping (Error?) -> Void) {
        
        // 枚举音视频设备
        func configureCaptureDevices() throws {
            
            let devices: [AVCaptureDevice]
            
            if #available(iOS 10.0, *) {
                let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
                devices = session.devices
            }
            else {
                devices = AVCaptureDevice.devices(for: .video)
            }
            
            for camera in devices {
                if camera.position == .front {
                    frontCamera = camera
                    try configureDevice(camera)
                }
                else if camera.position == .back {
                    backCamera = camera
                    try configureDevice(camera)
                }
            }
            
            microphone = AVCaptureDevice.default(for: .audio)
            
        }
        func configureDeviceInputs() throws {
            if let microphone = microphone {
                microphoneInput = try addInput(device: microphone)
            }
            if cameraPosition != .front {
                try switchToBackCamera()
            }
            else {
                try switchToFrontCamera()
            }
        }
        func configurePhotoOutput() throws {
            
            let settings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            if #available(iOS 10.0, *) {
                let photoOutput = AVCapturePhotoOutput()
                if captureSession.canAddOutput(photoOutput) {
                    photoOutput.isHighResolutionCaptureEnabled = isHighResolutionEnabled
                    photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: settings)], completionHandler: nil)
                    if !photoOutput.isLivePhotoCaptureSupported {
                        liveMode = .unavailable
                    }
                    
                    captureSession.addOutput(photoOutput)
                    self.photoOutput = photoOutput
                }
            }
            else {
                let photoOutput = AVCaptureStillImageOutput()
                if captureSession.canAddOutput(photoOutput) {
                    photoOutput.outputSettings = settings
                    captureSession.addOutput(photoOutput)
                    self.photoOutput = photoOutput
                }
            }
            
        }
        func configureVideoOutput() throws {
            
            let videoOutput = AVCaptureMovieFileOutput()
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
                if let connection = videoOutput.connection(with: .video) {
                    if connection.isVideoStabilizationSupported {
                        connection.preferredVideoStabilizationMode = .auto
                    }
                }
                self.videoOutput = videoOutput
            }
        }
        
        
        DispatchQueue(label: "prepare").async {
            
            do {
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
                try configureVideoOutput()
                self.captureSession.startRunning()
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
            
        }
    }
    
}

// 拍照
@available(iOS 10.0, *)
extension CameraManager: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?
        ) {
        
        if let error = error {
            onFinishCapturePhoto?(nil, error)
        }
        else if let buffer = photoSampleBuffer,
            let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil) {
            let photo = outputPhoto(data: data)
            self.photo = photo
            onFinishCapturePhoto?(photo, nil)
        }
        else {
            onFinishCapturePhoto?(nil, CameraError.unknown)
        }
        
    }
}

// 录制视频
extension CameraManager: AVCaptureFileOutputRecordingDelegate {
    
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        isVideoRecording = false
        
        if let taskId = backgroundRecordingId {
            UIApplication.shared.endBackgroundTask(taskId)
            backgroundRecordingId = nil
        }
        
        if flashMode != .off {
            setTorchMode(.off)
        }

        var success = false
        
        if error == nil {
            videoDuration = seconds2Millisecond(output.recordedDuration.seconds)
            if videoDuration >= videoMinDuration {
                success = true
                onFinishRecordVideo?(videoPath, nil)
            }
            else {
                onRecordVideoDurationLessThanMinDuration?()
                onFinishRecordVideo?(nil, nil)
            }
        }
        else {
            onFinishRecordVideo?(nil, error)
        }
        
        if !success {
            try! FileManager.default.removeItem(atPath: videoPath)
            videoPath = ""
        }
        
    }
    
    private func seconds2Millisecond(_ seconds: Double) -> Int {
        return Int(seconds * 1000)
    }
    
}

// 工具方法
extension CameraManager {
    
    private func configureSession(callback: (_ isRunning: Bool) throws -> Void) throws {
        
        if captureSession.isRunning {
            
            captureSession.beginConfiguration()
            
            try callback(true)
            
            captureSession.commitConfiguration()
            
        }
        else {
            try callback(false)
        }
        
    }
    
    private func configureDevice(_ device: AVCaptureDevice, callback: () throws -> Void) throws {
        
        try device.lockForConfiguration()
        
        try callback()
        
        device.unlockForConfiguration()
        
    }
    
    private func configureDevice(_ device: AVCaptureDevice) throws {
        
        try configureDevice(device) {
            
            if device.isFocusModeSupported(.continuousAutoFocus) {
                device.focusMode = .continuousAutoFocus
            }
            if device.isSmoothAutoFocusSupported {
                device.isSmoothAutoFocusEnabled = true
            }
            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposureMode = .continuousAutoExposure
            }
            if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                device.whiteBalanceMode = .continuousAutoWhiteBalance
            }
            if device.isLowLightBoostSupported && lowHightBoost {
                device.automaticallyEnablesLowLightBoostWhenAvailable = true
            }
            
        }
        
    }
    
    private func addInput(device: AVCaptureDevice) throws -> AVCaptureDeviceInput {
        
        let input = try AVCaptureDeviceInput(device: device)
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        else {
            throw CameraError.inputsAreInvalid
        }
        
        return input
        
    }
    
    private func removeInput(_ input: AVCaptureDeviceInput) {
        
        if captureSession.inputs.contains(input) {
            captureSession.removeInput(input)
        }
        
    }
    
    private func getVideoPreset(videoQuality: VideoQuality) -> AVCaptureSession.Preset {
        switch videoQuality {
        case .p720:
            return AVCaptureSession.Preset.hd1280x720
        case .p1080:
            return AVCaptureSession.Preset.hd1920x1080
        case .p2160:
            return AVCaptureSession.Preset.hd4K3840x2160
        default:
            return AVCaptureSession.Preset.vga640x480
        }
    }
    
    private func outputPhoto(data: Data?) -> UIImage {
        
        let dataProvider = CGDataProvider(data: data! as CFData)
        let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
        
        // Set proper orientation for photo
        // If camera is currently set to front camera, flip image
        return UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: getImageOrientation(deviceOrientation: deviceOrientation))
        
    }
    
    func getVideoOrientation(deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        
        switch deviceOrientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
        
    }
    
    func getImageOrientation(deviceOrientation: UIDeviceOrientation) -> UIImage.Orientation {
        
        let isBackCamera = cameraPosition == .back
        
        switch deviceOrientation {
        case .landscapeLeft:
            return isBackCamera ? .up : .downMirrored
        case .landscapeRight:
            return isBackCamera ? .down : .upMirrored
        case .portraitUpsideDown:
            return isBackCamera ? .left : .rightMirrored
        default:
            return isBackCamera ? .right : .leftMirrored
        }
        
    }
    
}

// 兼容 ios9 和 ios10+
extension CameraManager {
    
    @available(iOS 10.0, *)
    func capturePhoto10() {
        
        guard captureSession.isRunning, let photoOutput = photoOutput else {
            return
        }
        
        let settings = AVCapturePhotoSettings()
        
        if liveMode == .on {
            let livePhotoPath = "\(livePhotoDir)/live_photo_\(settings.uniqueID)"
            settings.livePhotoMovieFileURL = URL(fileURLWithPath: livePhotoPath)
        }
        
        settings.flashMode = flashMode
        settings.isHighResolutionPhotoEnabled = isHighResolutionEnabled
        
        // 重置
        photo = nil
        videoPath = ""
        
        let output = photoOutput as! AVCapturePhotoOutput

        output.capturePhoto(with: settings, delegate: self)
        
    }
    
    func capturePhoto9() {
        
        guard captureSession.isRunning, let currentCamera = currentCamera, let photoOutput = photoOutput else {
            return
        }
        
        try! configureDevice(currentCamera) {
            currentCamera.flashMode = flashMode
        }
        
        let output = photoOutput as! AVCaptureStillImageOutput
        if let connection = output.connection(with: .video) {
            
            // 重置
            photo = nil
            videoPath = ""
            
            output.captureStillImageAsynchronously(from: connection) { (sampleBuffer, error) in
                if let sampleBuffer = sampleBuffer {
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let photo = self.outputPhoto(data: data)
                    
                    self.photo = photo
                    self.onFinishCapturePhoto?(photo, nil)
                }
            }
        }
        
    }

}

extension CameraManager {
    
    // 获取视频第一帧画面
    func getVideoFirstFrame(videoPath: String) -> UIImage? {
        
        let avAsset = AVAsset.init(url: URL(fileURLWithPath: videoPath))
        let generator = AVAssetImageGenerator.init(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600) // 取第0秒， 一秒600帧
        var actualTime = CMTimeMake(value: 0, timescale: 0)
        
        do {
            let cgImage = try generator.copyCGImage(at: time, actualTime: &actualTime)
            return UIImage(cgImage: cgImage)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return nil
        
    }
    
    // 把图片保存到磁盘
    func saveToDisk(image: UIImage, compressionQuality: CGFloat = 0.7, callback: (String, Int) -> Void) {

        if let imageData = image.jpegData(compressionQuality: compressionQuality) as NSData? {
            let filePath = getFilePath(dirname: photoDir, extname: ".jpeg")
            if imageData.write(toFile: filePath, atomically: true) {
                callback(filePath, imageData.length)
            }
        }
        
    }
    
    // 生成一个文件路径
    func getFilePath(dirname: String, extname: String) -> String {

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dirname) {
            try? fileManager.createDirectory(atPath: dirname, withIntermediateDirectories: true, attributes: nil)
        }
        
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        
        let filename = "\(format.string(from: Date()))\(extname)"
        
        if dirname.hasSuffix("/") {
            return dirname + filename
        }
        
        return "\(dirname)/\(filename)"
        
    }
    
}

extension CameraManager {
    
    enum CameraError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    enum CameraPosition {
        case front, back
    }
    
    enum CameraLiveMode {
        case on, off, unavailable
    }
    
}
