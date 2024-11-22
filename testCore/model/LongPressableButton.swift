import SwiftUI
import AVFoundation

struct LongPressableButton<Label>: View where Label: View {
    var tapAction: (() -> Void)?
    var longPressAction: (() -> Void)?
    var label: (() -> Label)
    @State private var longPressed = false

    private let tonePlayer = MorseTonePlayer()

    init(tapAction: (() -> Void)? = nil, longPressAction: (() -> Void)? = nil, label: @escaping (() -> Label)) {
        self.tapAction = tapAction
        self.longPressAction = longPressAction
        self.label = label
    }

    var body: some View {
        Button(action: {
            if longPressed {
                longPressAction?()
                tonePlayer.playTone(duration: 0.2)
                longPressed = false
            } else {
                tapAction?()
                tonePlayer.playTone(duration: 0.1)
            }
        }, label: {
            label()
        })
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                longPressed = true
            }
        )
        .padding()
    }
}

class MorseTonePlayer {
    private var audioEngine: AVAudioEngine
    private var toneNode: AVAudioSourceNode?

    init() {
        audioEngine = AVAudioEngine()
    }

    func playTone(duration: TimeInterval) {
        stopTone()


        let sampleRate: Double = 44100.0
        let frequency: Double = 750.0 // モールス信号の周波数はこのくらいらしい
        var currentSample: Double = 0
        let increment = frequency * 2.0 * .pi / sampleRate

        toneNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            guard let bufferPointer = audioBufferList.pointee.mBuffers.mData else {
                return -1
            }
            let buffer = bufferPointer.bindMemory(to: Float.self, capacity: Int(frameCount))
            for frame in 0..<Int(frameCount) {
                buffer[frame] = Float(sin(currentSample))
                currentSample += increment
                if currentSample > 2.0 * .pi {
                    currentSample -= 2.0 * .pi
                }
            }
            return noErr
        }

        if let toneNode = toneNode {
            let mainMixer = audioEngine.mainMixerNode
            audioEngine.attach(toneNode)
            audioEngine.connect(toneNode, to: mainMixer, format: mainMixer.outputFormat(forBus: 0))

            do {
                try audioEngine.start()
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.stopTone()
                }
            } catch {
                print("Audio Engine Error: \(error)")
            }
        }
    }

    func stopTone() {
        audioEngine.stop()
        if let toneNode = toneNode {
            audioEngine.detach(toneNode)
            self.toneNode = nil
        }
    }
}
