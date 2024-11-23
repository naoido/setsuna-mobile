import SwiftUI
import CoreMotion

protocol MotionModelDelegate {
    func didDetectMotion(type: String)
}

class MotionModel: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var motionMessage: String = "加速度センサーのデータ待ち..."
    var delegate: MotionModelDelegate? 
    
    func startAccelerometer() {
        guard motionManager.isAccelerometerAvailable else {
            motionMessage = "加速度センサーが使用できません"
            return
        }
        motionManager.accelerometerUpdateInterval = 0.3 // 更新間隔
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }
            
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            print("x: \(x), y: \(y), z: \(z)")
            
            if abs(x) > 1.0 {
                self.motionMessage = "ふるふる"
                self.delegate?.didDetectMotion(type: "ふるふる")
            } else if abs(y) > 1.0 {
                self.motionMessage = "ふりふり"
                self.delegate?.didDetectMotion(type: "ふりふり")
            } else if abs(z) > 1.0 {
                self.motionMessage = "ふらふら"
                self.delegate?.didDetectMotion(type: "ふらふら")
            } else {
                self.motionMessage = "静止"
            }
        }
    }
    
    func stopAccelerometer() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
