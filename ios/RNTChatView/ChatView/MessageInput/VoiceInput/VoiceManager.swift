
import AVFoundation

// https://www.cnblogs.com/kenshincui/p/4186022.html
// https://github.com/genedelisa/AVFoundationRecorder/blob/master/AVFoundation%20Recorder/RecorderViewController.swift

class VoiceManager: NSObject {

    // 是否正在录音
    var isRecording: Bool {
        get {
            return recorder != nil ? recorder!.isRecording : false
        }
    }

    // 是否正在播放
    var isPlaying: Bool {
        get {
            guard let player = player, player.isPlaying else {
                return false
            }
            return true
        }
    }

    // 当前正在录音的文件路径
    var filePath = ""
    
    // 录音文件的时长，单位毫秒
    var fileDuration:  Int = 0

    // 外部实时读取的录音时长
    var duration: Int {
        get {
            guard let recorder = recorder else {
                return 0
            }
            var currentTime = timeInterval2Millisecond(recorder.currentTime)
            if currentTime > configuration.audioMaxDuration {
                currentTime = configuration.audioMaxDuration
                do {
                    try stopRecord()
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            return currentTime
        }
    }

    // 外部实时读取的播放进度
    var progress: Int {
        get {
            return player != nil ? timeInterval2Millisecond(player!.currentTime) : 0
        }
    }

    var onPermissionsGranted: (() -> Void)?
    
    var onPermissionsDenied: (() -> Void)?
    
    var onRecordWithoutPermissions: (() -> Void)?
    
    var onRecordDurationLessThanMinDuration: (() -> Void)?

    var onFinishRecord: ((Bool) -> Void)?

    var onFinishPlay: ((Bool) -> Void)?
    
    // 录音器
    private var recorder: AVAudioRecorder?
    
    // 播放器
    private var player: AVAudioPlayer?

    var configuration: VoiceInputConfiguration!
    
    // 判断是否有权限录音，如没有，发起授权请求
    func requestPermissions() -> Bool {

        let session = AVAudioSession.sharedInstance()

        if session.recordPermission() == .undetermined {
            session.requestRecordPermission { granted in
                if granted {
                    self.onPermissionsGranted?()
                }
                else {
                    self.onPermissionsDenied?()
                }
            }
            return false
        }
        
        return session.recordPermission() == .granted

    }

    private func setSessionCategory(_ category: String) {

        do {
            try AVAudioSession.sharedInstance().setCategory(category)
        }
        catch {
            print("could not set session category: \(category)")
            print(error.localizedDescription)
        }

    }

    private func setSessionActive(_ active: Bool) {

        do {
            try AVAudioSession.sharedInstance().setActive(active)
        }
        catch {
            print("could not set session active: \(active)")
            print(error.localizedDescription)
        }

    }


    func startRecord() throws {

        guard requestPermissions() else {
            onRecordWithoutPermissions?()
            return
        }
        
        filePath = getFilePath(dirname: configuration.fileDir, extname: configuration.fileExtname)

        fileDuration = 0

        let recordSettings: [String: Any] = [
            AVFormatIDKey: configuration.audioFormat,
            AVNumberOfChannelsKey: configuration.audioNumberOfChannels,
            AVEncoderAudioQualityKey : configuration.audioQuality.rawValue,
            AVEncoderBitRateKey : configuration.audioBitRate,
            AVSampleRateKey : configuration.audioSampleRate
        ]

        do {
            recorder = try AVAudioRecorder(url: URL(fileURLWithPath: filePath), settings: recordSettings)
        }
        catch {
            print("could not init AVAudioRecorder")
            print(error.localizedDescription)
            throw VoiceManagerError.recorderIsNotAvailable
        }

        if let recorder = recorder {

            // 设置 session
            setSessionCategory(AVAudioSessionCategoryRecord)
            setSessionActive(true)

            recorder.delegate = self
//            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
            
            recorder.record()

        }

    }

    func stopRecord() throws {

        guard isRecording else {
            throw VoiceManagerError.recorderIsNotRunning
        }

        if let recorder = recorder {
            fileDuration = timeInterval2Millisecond(recorder.currentTime)
            recorder.stop()
        }

        setSessionCategory(AVAudioSessionCategoryPlayback)
        setSessionActive(false)

    }
    
    func startPlay() throws {

        guard filePath != "" else {
            throw VoiceManagerError.audioFileIsNotExisted
        }

        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
        }
        catch {
            print("could not init AVAudioPlayer")
            print(error.localizedDescription)
            throw VoiceManagerError.playerIsNotAvailable
        }

        if let player = player {

            player.delegate = self
            player.prepareToPlay()
            player.play()

        }

    }

    func stopPlay() {

        guard isPlaying else {
            return
        }

        if let player = player {
            player.stop()
            self.player = nil
        }

    }

    func deleteFile() {

        guard let recorder = recorder else {
            return
        }

        recorder.deleteRecording()

        self.recorder = nil
        self.filePath = ""

    }

}

extension VoiceManager: AVAudioRecorderDelegate {

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("recorder encode error")
            print(error.localizedDescription)
        }
    }

    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        if flag {
            if fileDuration >= configuration.audioMinDuration {
                onFinishRecord?(true)
            }
            else {
                deleteFile()
                onRecordDurationLessThanMinDuration?()
                onFinishRecord?(false)
            }
            return
        }

        deleteFile()
        onFinishRecord?(false)

    }

}

extension VoiceManager: AVAudioPlayerDelegate {

    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("player encode error")
            print(error.localizedDescription)
        }
    }

    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinishPlay?(flag)
    }

}

//
// MARK: - 工具方法
//

extension VoiceManager {
    
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
    
    func timeInterval2Millisecond(_ timeInterval: TimeInterval) -> Int {
        return Int(timeInterval * 1000)
    }
    
}

enum VoiceManagerError: Swift.Error {

    // 录音器不可用
    case recorderIsNotAvailable
    
    // 录音器没在运行中
    case recorderIsNotRunning
    
    // 没有录音文件
    case audioFileIsNotExisted
    
    // 播放器不可用
    case playerIsNotAvailable
    
}
