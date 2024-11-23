import Foundation
import Combine

class TimeModel: ObservableObject {

    @Published var currentTime: String = ""
    @Published var timeDifference: String? = nil

    private var timer: AnyCancellable?
    private let formatter: DateFormatter
    private var startTime: Date?

    init() {
        formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        currentTime = formatter.string(from: Date())
    }

    func startUpdatingTime() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTime()
            }
    }

    func startTiming() {
        startTime = Date()
        timeDifference = nil
    }

    func diffTime() {
        guard let startTime = startTime else {
            timeDifference = "未スタート"
            return
        }
        
        let now = Date()
        let difference = now.timeIntervalSince(startTime)
        
        timeDifference = String(format: "%.2f 秒", difference)
        print(timeDifference)
    }

    private func updateTime() {
        currentTime = formatter.string(from: Date())
    }

    deinit {
        timer?.cancel()
    }
}
