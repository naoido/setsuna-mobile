import SwiftUI

public class GameTimerModel: ObservableObject {
    static let INSTANCE = GameTimerModel()
    @Published var message: String = "始まりの時..."
    
    func startTimer(s: Double, f: Double) {
        print(s)
        print(f)
        Timer.scheduledTimer(withTimeInterval: s, repeats: false) { _ in
            print("開始")
            MotionModel.INSTANCE.startAccelerometer()
            self.changeMessage(message: "...(凪)")
        }
        Timer.scheduledTimer(withTimeInterval: f, repeats: false) { _ in
            print("今")
            self.message = "今！！！！"
        }
    }
    
    func changeMessage(message: String) {
        self.message = message
    }
}
