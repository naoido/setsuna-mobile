import SwiftUI
import RocketReserverAPI

struct ShakeView: View {
    @State var userCount: Int? = nil
    @State var roomID: String? = nil
    @State var isMatched: Bool? = false
    @State private var timer: Timer?
    @StateObject private var motionModel = MotionModel()
    
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
                GameView()
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
                    }
                }
            case .failure(let error):
                print("マッチングエラー: \(error)")
            }
        }
    }
    
    private func startMatchingTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if isMatched == true {
                t.invalidate()
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
