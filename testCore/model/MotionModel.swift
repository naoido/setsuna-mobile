import SwiftUI
import CoreMotion

class MotionModel: ObservableObject {
    public static let INSTANCE = MotionModel()
    private let motionManager = CMMotionManager()
    @Published var motionMessage: String = "加速度センサーのデータ待ち..."
    
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
            
            if (abs(x) + abs(y) + abs(z)) > 2.5 {
                self.motionMessage = "ふるふる"
            } else {
                self.motionMessage = "静止中"
            }
        }
    }
    
    func stopAccelerometer() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
