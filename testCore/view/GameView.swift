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
    @State private var message: String = "始まります..."
    @StateObject private var motionModel = MotionModel()
    private let setuna: Double
    
    init (start_time: Double, setuna_time: Double) {
        let now = Date().timeIntervalSince1970
        let start = start_time - now
        setuna = setuna_time - now
        self.startTimer(s: start, f: setuna)
    }
    
    func startTimer(s: Double, f: Double) {
        Timer.scheduledTimer(withTimeInterval: s, repeats: false) { _ in
            print("開始")
            self.message = "...(凪)"
        }
        Timer.scheduledTimer(withTimeInterval: f, repeats: false) { _ in
            print("開始")
            self.message = "今！！！！"
        }
    }
    
    var body: some View {
        VStack {
            Text(message)
                .onChange(of: motionModel.motionMessage) {
                    if motionModel.motionMessage == "ふるふる" {
                        let diff = Date().timeIntervalSince1970 - setuna
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
