import XCTest
@testable import PreviewDebugger

final class WatchdogTests: XCTestCase {

    override func tearDown() {
        // Leave the shared watchdog in a known stopped state regardless of test order.
        Watchdog.shared.stop()
        super.tearDown()
    }

    func testNotificationNamesAreStableContract() {
        XCTAssertEqual(
            Watchdog.Notifications.didStall,
            Notification.Name("WatchdogDidStallNotification")
        )
    }

    func testUserInfoKeysAreStableContract() {
        XCTAssertEqual(Watchdog.UserInfoKey.duration, "WatchdogDurationKey")
        XCTAssertEqual(Watchdog.UserInfoKey.timestamp, "WatchdogTimestampKey")
    }

    func testStartIsIdempotent() {
        // Calling start twice must not crash.
        Watchdog.shared.start()
        Watchdog.shared.start()
        Watchdog.shared.stop()
    }

    func testStopWithoutStartIsSafe() {
        // Defensive: stop on a fresh/stopped instance must be a no-op, not a crash.
        Watchdog.shared.stop()
        Watchdog.shared.stop()
    }

    func testStartStopStartCycleDoesNotCrash() {
        Watchdog.shared.start()
        Watchdog.shared.stop()
        Watchdog.shared.start()
        Watchdog.shared.stop()
    }

    func testSharedReturnsSameInstance() {
        XCTAssertTrue(Watchdog.shared === Watchdog.shared)
    }
}
