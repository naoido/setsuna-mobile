import SwiftUI

struct GameView: View {
    @State private var isMatching: Bool = false
    @State private var isWin: Bool = false
    @StateObject private var motionModel = MotionModel()
    @StateObject private var timeModel = TimeModel()
    
    var body: some View {
        VStack {
            if !isMatching {
                Button("Ready") {
                    motionModel.startAccelerometer()
                    timeModel.startTiming()
                    isMatching = true
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
