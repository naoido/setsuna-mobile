import SwiftUI
import Apollo
import RocketReserverAPI

var isStarted: Bool = false
var setuna_t: Double = 0.0

struct GameView: View {
    @State private var isMatching: Bool = true
    @State private var isBattled: Bool = false
    @State private var isWin: Bool = false
    @State private var isReady: Bool = false
    @State private var score: Int = 0
    @State private var isResultPosted: Bool = false
    @State private var message: String = "始まります..."
    @StateObject private var motionModel = MotionModel.INSTANCE
    @StateObject private var gameTimerModel = GameTimerModel.INSTANCE
    
    init (start_time: Double, setuna_time: Double) {
        if (!isStarted) {
            let now = Date().timeIntervalSince1970
            let start = start_time - now + 3
            let setuna = setuna_time - now
            setuna_t = setuna_time
            self.gameTimerModel.startTimer(s: start, f: setuna)
            
            isStarted = true
        }
    }
    
    var body: some View {
        VStack {
            Text(gameTimerModel.message)
            .onChange(of: motionModel.motionMessage) {
                print(motionModel.motionMessage)
                if motionModel.motionMessage == "ふるふる" {
                    print("ふるふる")
                    let diff = Date().timeIntervalSince1970 - setuna_t
                    motionModel.stopAccelerometer()
                    postResult(roomId: "exampleRoomId", diff: diff) {
                        isResultPosted = true
                    }
                    isMatching = false
                }
            }
            
            if isResultPosted {
                Text("結果送信完了！スコア: \(score)")
            }
        }
        .onDisappear {
            // Viewが非表示になったらセンサーを停止
            motionModel.stopAccelerometer()
            isMatching = false
            isReady = false
        }
    }
    
    func postResult(roomId: String, diff: Double, completion: @escaping () -> Void) {
        let score = Int(floor(diff * 100))
        print("score \(score)")
        let mutation = Post_resultMutation(roomId: roomId, score: score)
        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let resultMessage = graphQLResult.data?.post_result?.result {
                    print("Result posted: \(resultMessage)")
                }
            case .failure(let error):
                print("Error posting result: \(error)")
            }
        }
    }
}
