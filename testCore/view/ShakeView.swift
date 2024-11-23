import SwiftUI
import RocketReserverAPI

struct ShakeView: View, MotionModelDelegate {
    @State var isMatching: Bool = false
    @State var userCount: Int? = nil
    @State var roomID: String? = nil
    @State var isMatched: Bool? = nil
    @State private var timer: Timer? 
    @StateObject private var motionModel = MotionModel()
    
    var body: some View {
        VStack {
            if !isMatching {
                Button("マッチング開始") {
                    motionModel.delegate = self
                    motionModel.startAccelerometer()
                    isMatching = true
                    startMatchingTimer()
                }
            } else {
                Text("マッチング中")
                Text("\(motionModel.motionMessage)")
                
                if let userCount = userCount {
                    Text("現在の待機数: \(userCount)")
                }
                
                if let roomID = roomID {
                    Text("ルームID: \(roomID)")
                }
                
                if let isMatched = isMatched {
                    Text(isMatched ? "マッチしました！" : "マッチング中...")
                }
                
                Button("マッチング終了") {
                    motionModel.stopAccelerometer()
                    stopMatchingTimer()
                    isMatching = false
                }
            }
        }
        .onDisappear {
            motionModel.stopAccelerometer()
            stopMatchingTimer()
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
    
    func didDetectMotion(type: String) {
        print("検知された動作: \(type)")
    }
    
    private func startMatchingTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.matching(isLeave: false)
        }
    }
    
    private func stopMatchingTimer() {
        timer?.invalidate()
        timer = nil
    }
}
