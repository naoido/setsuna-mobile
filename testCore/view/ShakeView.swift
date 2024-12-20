import SwiftUI
import RocketReserverAPI

struct ShakeView: View {
    @State var userCount: Int? = nil
    @State var roomID: String? = nil
    @State var isMatched: Bool? = false
    @State private var timer: Timer?
    @State var start_time: Double? = nil
    @State var setuna_time: Double? = nil
    @StateObject private var motionModel = MotionModel.INSTANCE
    
    var body: some View {
        VStack {
            if (isMatched == false) {
                Text("\(motionModel.motionMessage)")
                
                if let userCount = userCount {
                    Text("現在の待機数: \(userCount)")
                }
                
                if let isMatched = isMatched {
                    Text(isMatched ? "マッチしました！" : "マッチング中...")
                }
            } else {
                GameView(start_time: start_time!, setuna_time: setuna_time!, room_id: roomID!)
            }
        }
        .onAppear {
            motionModel.startAccelerometer()
            startMatchingTimer()
        }
        .onDisappear {
            motionModel.stopAccelerometer()
        }
    }
    
    func matching(isLeave: Bool) {
        let mutation = Post_matchingMutation(isLeave: isLeave)
        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let response):
                if let data = response.data?.post_matching {
                    DispatchQueue.main.async {
                        self.userCount = data.user_count
                        self.roomID = data.room_id
                        self.isMatched = data.is_matched
                        if (self.isMatched == true) {
                            self.start_time = Double(data.start_time!)
                            self.setuna_time = Double(data.setuna_time!)
                        }
                    }
                }
            case .failure(let error):
                print("マッチングエラー: \(error)")
            }
        }
    }
    
    private func startMatchingTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { t in
            if isMatched == true {
                t.invalidate()
                motionModel.stopAccelerometer()
                return
            }
            switch motionModel.motionMessage {
            case "ふるふる":
                self.matching(isLeave: false)
            case "静止中":
                self.matching(isLeave: true)
            default:
                break
            }
        }
    }
}
