
import UIKit
import AVFoundation

class FocusView: UIView {
    
    private var configuration: CameraViewConfiguration!
    
    convenience init(configuration: CameraViewConfiguration) {
        self.init(frame: CGRect(x: 0, y: 0, width: configuration.focusViewWidth, height: configuration.focusViewHeight))
        self.configuration = configuration
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        let width = configuration.focusViewWidth
        let height = configuration.focusViewHeight
        let thickness = configuration.focusViewThickness
        let crossLength = configuration.focusViewCrossLength
        
        
        // 矩形框
        var topLine = createLine()
        topLine.frame = CGRect(x: 0, y: 0, width: width, height: thickness)
        
        var rightLine = createLine()
        rightLine.frame = CGRect(x: width - thickness, y: 0, width: thickness, height: height)
        
        var bottomLine = createLine()
        bottomLine.frame = CGRect(x: 0, y: height - thickness, width: width, height: thickness)
        
        var leftLine = createLine()
        leftLine.frame = CGRect(x: 0, y: 0, width: thickness, height: height)
        
        
        // 中间的四条短线
        
        topLine = createLine()
        topLine.frame = CGRect(x: width / 2, y: 0, width: thickness, height: crossLength)
        
        rightLine = createLine()
        rightLine.frame = CGRect(x: width - crossLength, y: height / 2, width: crossLength, height: thickness)
        
        bottomLine = createLine()
        bottomLine.frame = CGRect(x: width / 2, y: height - crossLength, width: thickness, height: crossLength)
        
        leftLine = createLine()
        leftLine.frame = CGRect(x: 0, y: height / 2, width: crossLength, height: thickness)
        
    }
    
    private func createLine() -> UIView {
        let line = UIView()
        line.backgroundColor = configuration.focusViewColor
        addSubview(line)
        return line
    }
    
    
}
