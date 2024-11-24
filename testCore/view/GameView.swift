import SwiftUI
import Apollo
import RocketReserverAPI
struct GameView: View {
    @State private var isMatching: Bool = true
    @State private var isBattled: Bool = false
    @State private var isWin: Bool = false
    @State private var isReady: Bool = false
    @State private var score: Int = 0
    @State private var isResultPosted: Bool = false
    @StateObject private var motionModel = MotionModel()
    @StateObject private var timeModel = TimeModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if isMatching {
                    Text("よ〜い")
                        .task {
                            try? await Task.sleep(nanoseconds: 5 * 1_000_000_000) // 5秒
                            motionModel.startAccelerometer()
                            timeModel.startTiming()
                            isMatching = false
                        }
                } else {
                    VStack {
                        Text("対戦中")
                    }
                    .onChange(of: motionModel.motionMessage) {
                        if motionModel.motionMessage == "ふるふる" {
                            timeModel.diffTime()
                            motionModel.stopAccelerometer()
                            score = timeModel.timeDifference
                            postResult(roomId: "", score: score) {
                                isResultPosted = true
                            }
                            isMatching = false
                            isBattled = true
                        }
                    }
                }
                
                if isResultPosted {
                    Text("結果送信完了！スコア: \(score)")
                }
                
                NavigationLink(
                    destination: MainView(),
                    isActive: $isBattled, // isBattled が true なら MainView に遷移
                    label: {
                        EmptyView() // 見た目を表示させない
                    }
                )
            }
            .onDisappear {
                motionModel.stopAccelerometer()
                isMatching = false
                isReady = false
            }
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
