//
//  WatchdogWrapper.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 14.10.2025.
//  https://github.com/kovs705
//

import Foundation
import WatchdogSupport

/// During app startup or wherever you need to start tracking potential main thread blocking, you can start and stop the shared watchdog
///
/// ```swift
///  Watchdog.shared.start()
///  Watchdog.shared.stop()
/// ```
///
final public class Watchdog: NSObject, WatchdogRunLoopObserverDelegate {
    @objc
    public static let shared = Watchdog()

    private let observer = WatchdogRunLoopObserver()

    private var isStarted = false

    public enum Notifications {
        public static let didStall = Notification.Name("WatchdogDidStallNotification")
    }

    public enum UserInfoKey {
        public static let duration = "WatchdogDurationKey"
        public static let timestamp = "WatchdogTimestampKey"
    }

    override private init() {
        super.init()
        self.observer.delegate = self
    }

    deinit {
        stop()
    }

    public func start() {
        if isStarted {
            return
        }

        print("[Watchdog] started")
        observer.start()
        isStarted = true
    }

    public func stop() {
        guard isStarted else { return }
        print("[Watchdog] stopped")
        observer.stop()
        isStarted = false
    }

    // MARK: WatchdogRunLoopObserverDelegate

    public func runLoopDidStall(withDuration duration: TimeInterval) {
        // Custom logging here
        //    - what task is currently running?
        //    - which view controller is currently on screen?
        print("🚫 ⚠️ [Watchdog] main thread blocked for \(duration) seconds")
        notifyDidStall(duration: duration)
    }

    private func notifyDidStall(duration: TimeInterval) {
        let userInfo: [String: Any] = [
            UserInfoKey.duration: duration,
            UserInfoKey.timestamp: Date()
        ]

        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notifications.didStall,
                object: self,
                userInfo: userInfo
            )
        }
    }
}
