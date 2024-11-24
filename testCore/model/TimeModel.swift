import Foundation
import Combine

class TimeModel: ObservableObject {

    @Published var currentTime: String = ""
    @Published var timeDifference: Int = 0

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
    }

    func diffTime() {
        guard let startTime = startTime else {
            return
        }
        
        let now = Date()
        let difference = now.timeIntervalSince(startTime)
        
        timeDifference = Int(floor(difference * 100))
        print(timeDifference)
    }

    private func updateTime() {
        currentTime = formatter.string(from: Date())
    }

    deinit {
        timer?.cancel()
    }
}
