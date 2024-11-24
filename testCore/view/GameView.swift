import SwiftUI
import Apollo
import RocketReserverAPI
struct GameView: View {
    @State private var isMatching: Bool = false
    @State private var isWin: Bool = false
    @State private var isReady: Bool = false
    @State private var score: Int = 0
    @State private var isResultPosted: Bool = false
    @StateObject private var motionModel = MotionModel()
    @StateObject private var timeModel = TimeModel()
    
    var body: some View {
        VStack {
            if !isMatching {
                if isReady == false {
                    Button("Ready") {
                        isReady = true
                        // ランダムな待機時間を設定
                        let delay = Double.random(in: 3...5)
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            motionModel.startAccelerometer()
                            timeModel.startTiming()
                            isMatching = true
                        }
                    }
                }

                if isReady == true {
                    Text("よ〜い！")
                }
            } else {
                VStack {
                    Text("対戦中")
                    Text(motionModel.motionMessage)
                }
                .onChange(of: motionModel.motionMessage) {
                    if motionModel.motionMessage == "ふるふる" {
                        timeModel.diffTime()
                        motionModel.stopAccelerometer()
                        score = timeModel.timeDifference
                        postResult(roomId: "exampleRoomId", score: score) {
                            isResultPosted = true
                        }
                        isMatching = false
                    }
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
    func postResult(roomId: String, score: Int, completion: @escaping () -> Void) {
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
