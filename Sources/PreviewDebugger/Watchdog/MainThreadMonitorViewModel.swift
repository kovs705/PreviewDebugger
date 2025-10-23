//
//  MainThreadMonitorViewModel.swift
//  PreviewDebugger
//
//  Created by ChatGPT on 21.11.2025.
//

import Foundation

@MainActor
final class MainThreadMonitorViewModel: ObservableObject {

    struct StallEvent: Equatable {
        let duration: TimeInterval
        let timestamp: Date
    }

    enum Status: Equatable {
        case healthy
        case stalled(StallEvent)

        var event: StallEvent? {
            if case let .stalled(event) = self {
                return event
            }
            return nil
        }
    }

    enum Severity {
        case green
        case yellow
        case orange
        case red

        init(duration: TimeInterval) {
            switch duration {
            case ..<0.6:
                self = .green
            case ..<1.5:
                self = .yellow
            case ..<3.0:
                self = .orange
            default:
                self = .red
            }
        }
    }

    @Published private(set) var status: Status = .healthy

    private let resetInterval: TimeInterval = 6
    private var resetItem: DispatchWorkItem?
    private var notificationObserver: NSObjectProtocol?
    private var isMonitoring = false

    func startMonitoring() {
        guard !isMonitoring else { return }

        notificationObserver = NotificationCenter.default.addObserver(
            forName: Watchdog.Notifications.didStall,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard
                let duration = notification.userInfo?[Watchdog.UserInfoKey.duration] as? TimeInterval,
                let timestamp = notification.userInfo?[Watchdog.UserInfoKey.timestamp] as? Date
            else {
                return
            }
            Task { @MainActor [weak self] in
                self?.handleStall(duration: duration, timestamp: timestamp)
            }
        }

        Watchdog.shared.start()
        isMonitoring = true
    }

    func stopMonitoring() {
        guard isMonitoring else { return }

        Watchdog.shared.stop()

        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
            notificationObserver = nil
        }

        resetItem?.cancel()
        resetItem = nil
        status = .healthy
        isMonitoring = false
    }

    deinit {
        Task { @MainActor [weak self] in
            self?.stopMonitoring()
        }
    }

    private func handleStall(duration: TimeInterval, timestamp: Date) {
        status = .stalled(.init(duration: duration, timestamp: timestamp))
        scheduleReset()
    }

    private func scheduleReset() {
        resetItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.status = .healthy
        }
        resetItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + resetInterval, execute: workItem)
    }
}
