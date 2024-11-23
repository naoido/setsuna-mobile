import SwiftUI

struct GameView: View {
    @State private var isMatching: Bool = false
    @State private var isWin: Bool = false
    @State private var isReady: Bool = false
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
                    }
                }
            }
        }
        .onDisappear {
            // Viewが非表示になったらセンサーを停止
            motionModel.stopAccelerometer()
            isMatching = false
        }
    }
}
