//
//  WatchdogWrapper.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 14.10.2025.
//  https://github.com/kovs705
//

import Foundation
import os
import WatchdogSupport

/// During app startup or wherever you need to start tracking potential main thread blocking, you can start and stop the shared watchdog
///
/// ```swift
///  Watchdog.shared.start()
///  Watchdog.shared.stop()
/// ```
///
/// You can also customize how long the main thread must be blocked before a stall is
/// reported. The default threshold is 4 seconds.
///
/// ```swift
///  Watchdog.shared.start(threshold: 1.0)   // start with a 1s threshold
///  Watchdog.shared.configure(threshold: 2) // change threshold (restarts if running)
/// ```
final public class Watchdog: NSObject, WatchdogRunLoopObserverDelegate {
    @objc
    public static let shared = Watchdog()

    /// The default stalling threshold, in seconds, used when `start()` is called with no arguments.
    public static let defaultThreshold: TimeInterval = 4

    private static let logger = Logger(subsystem: "PreviewDebugger", category: "Watchdog")

    private var observer: WatchdogRunLoopObserver

    /// The stalling threshold, in seconds, currently configured.
    public private(set) var threshold: TimeInterval

    private var isStarted = false

    public enum Notifications {
        public static let didStall = Notification.Name("WatchdogDidStallNotification")
    }

    public enum UserInfoKey {
        public static let duration = "WatchdogDurationKey"
        public static let timestamp = "WatchdogTimestampKey"
    }

    override private init() {
        self.threshold = Watchdog.defaultThreshold
        self.observer = WatchdogRunLoopObserver(stallingThreshold: Watchdog.defaultThreshold)
        super.init()
        self.observer.delegate = self
    }

    deinit {
        stop()
    }

    /// Starts monitoring the main thread using the currently configured threshold (default 4s).
    public func start() {
        if isStarted {
            return
        }

        Self.logger.info("Watchdog started (threshold: \(self.threshold, format: .fixed(precision: 2))s)")
        observer.start()
        isStarted = true
    }

    /// Starts monitoring the main thread, configuring the stalling threshold first.
    ///
    /// If the watchdog is already running with a different threshold, it is restarted
    /// so the new threshold takes effect immediately.
    /// - Parameter threshold: The minimum duration, in seconds, the main thread must be
    ///   blocked before a stall is reported. Must be greater than 0.
    public func start(threshold: TimeInterval) {
        configure(threshold: threshold)
        start()
    }

    /// Updates the stalling threshold.
    ///
    /// If the watchdog is currently running, it is stopped, the underlying observer is
    /// recreated with the new threshold, and monitoring is resumed. Values that are not
    /// greater than zero are ignored.
    /// - Parameter threshold: The minimum duration, in seconds, the main thread must be
    ///   blocked before a stall is reported. Must be greater than 0.
    public func configure(threshold: TimeInterval) {
        guard threshold > 0 else {
            Self.logger.warning("Watchdog ignored invalid threshold: \(threshold, format: .fixed(precision: 2))s")
            return
        }

        guard threshold != self.threshold else { return }

        let wasStarted = isStarted
        if wasStarted {
            stop()
        }

        self.threshold = threshold
        observer = WatchdogRunLoopObserver(stallingThreshold: threshold)
        observer.delegate = self

        Self.logger.info("Watchdog threshold set to \(threshold, format: .fixed(precision: 2))s")

        if wasStarted {
            start()
        }
    }

    public func stop() {
        guard isStarted else { return }
        Self.logger.info("Watchdog stopped")
        observer.stop()
        isStarted = false
    }

    // MARK: WatchdogRunLoopObserverDelegate

    public func runLoopDidStall(withDuration duration: TimeInterval) {
        // Custom logging here
        //    - what task is currently running?
        //    - which view controller is currently on screen?
        if duration >= 3.0 {
            Self.logger.fault("Main thread blocked for \(duration, format: .fixed(precision: 2)) seconds")
        } else {
            Self.logger.warning("Main thread blocked for \(duration, format: .fixed(precision: 2)) seconds")
        }
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
