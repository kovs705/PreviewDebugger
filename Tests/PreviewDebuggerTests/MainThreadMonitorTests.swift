import XCTest
import Combine
@testable import PreviewDebugger

@MainActor
final class MainThreadMonitorTests: XCTestCase {

    typealias ViewModel = MainThreadMonitorViewModel

    override func tearDown() {
        Watchdog.shared.stop()
        super.tearDown()
    }

    // MARK: - Severity thresholds (stable contract)

    // Severity is a plain enum without declared Equatable conformance, so we
    // compare by case label via String(describing:).
    private func label(_ severity: ViewModel.Severity) -> String {
        String(describing: severity)
    }

    func testSeverityGreenBelowLowerBound() {
        XCTAssertEqual(label(ViewModel.Severity(duration: 0)), "green")
        XCTAssertEqual(label(ViewModel.Severity(duration: 0.59)), "green")
    }

    func testSeverityBoundaryAt0_6IsYellow() {
        // 0.6 is NOT < 0.6, so it falls into the < 1.5 (yellow) bucket.
        XCTAssertEqual(label(ViewModel.Severity(duration: 0.6)), "yellow")
    }

    func testSeverityYellowJustBelow1_5() {
        XCTAssertEqual(label(ViewModel.Severity(duration: 1.49)), "yellow")
    }

    func testSeverityBoundaryAt1_5IsOrange() {
        XCTAssertEqual(label(ViewModel.Severity(duration: 1.5)), "orange")
    }

    func testSeverityOrangeJustBelow3_0() {
        XCTAssertEqual(label(ViewModel.Severity(duration: 2.99)), "orange")
    }

    func testSeverityBoundaryAt3_0IsRed() {
        XCTAssertEqual(label(ViewModel.Severity(duration: 3.0)), "red")
    }

    func testSeverityRedAboveUpperBound() {
        XCTAssertEqual(label(ViewModel.Severity(duration: 10)), "red")
    }

    // MARK: - Status.event extraction

    func testStatusEventIsNilWhenHealthy() {
        let status = ViewModel.Status.healthy
        XCTAssertNil(status.event)
    }

    func testStatusEventReturnsPayloadWhenStalled() {
        let timestamp = Date(timeIntervalSince1970: 1_000)
        let event = ViewModel.StallEvent(duration: 1.25, timestamp: timestamp)
        let status = ViewModel.Status.stalled(event)

        XCTAssertEqual(status.event, event)
        XCTAssertEqual(status.event?.duration, 1.25)
        XCTAssertEqual(status.event?.timestamp, timestamp)
    }

    // MARK: - Start / stop lifecycle

    func testInitialStatusIsHealthy() {
        let vm = ViewModel()
        XCTAssertEqual(vm.status, .healthy)
    }

    func testStartMonitoringIsIdempotent() {
        let vm = ViewModel()
        vm.startMonitoring()
        vm.startMonitoring()
        vm.stopMonitoring()
    }

    func testStopWithoutStartIsSafe() {
        let vm = ViewModel()
        vm.stopMonitoring()
        XCTAssertEqual(vm.status, .healthy)
    }

    func testStopMonitoringResetsStatusToHealthy() async {
        let vm = ViewModel()
        vm.startMonitoring()

        await postStallAndWaitForStalled(vm: vm, duration: 0.7)
        XCTAssertNotNil(vm.status.event)

        vm.stopMonitoring()
        XCTAssertEqual(vm.status, .healthy)
    }

    // MARK: - Notification-driven status transition

    func testDidStallNotificationTransitionsToStalled() async {
        let vm = ViewModel()
        vm.startMonitoring()

        await postStallAndWaitForStalled(vm: vm, duration: 1.25)

        XCTAssertEqual(vm.status.event?.duration, 1.25)
        vm.stopMonitoring()
    }

    func testDidStallWithMissingUserInfoIsIgnored() async {
        let vm = ViewModel()
        vm.startMonitoring()

        // Post a malformed notification (no userInfo). Status must stay healthy.
        NotificationCenter.default.post(
            name: Watchdog.Notifications.didStall,
            object: nil,
            userInfo: nil
        )

        // Give the run loop a chance to deliver; status must remain healthy.
        try? await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(vm.status, .healthy)
        vm.stopMonitoring()
    }

    func testStoppedMonitorIgnoresNotifications() async {
        let vm = ViewModel()
        vm.startMonitoring()
        vm.stopMonitoring()

        NotificationCenter.default.post(
            name: Watchdog.Notifications.didStall,
            object: nil,
            userInfo: [
                Watchdog.UserInfoKey.duration: TimeInterval(2.0),
                Watchdog.UserInfoKey.timestamp: Date()
            ]
        )

        try? await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(vm.status, .healthy)
    }

    // MARK: - Helpers

    /// Posts a `didStall` notification and awaits the resulting `.stalled` status
    /// transition using KVO-free expectation polling on `@Published var status`.
    private func postStallAndWaitForStalled(vm: ViewModel, duration: TimeInterval) async {
        let expectation = expectation(description: "status becomes .stalled")
        let cancellable = vm.$status.sink { status in
            if status.event != nil {
                expectation.fulfill()
            }
        }

        NotificationCenter.default.post(
            name: Watchdog.Notifications.didStall,
            object: nil,
            userInfo: [
                Watchdog.UserInfoKey.duration: duration,
                Watchdog.UserInfoKey.timestamp: Date()
            ]
        )

        await fulfillment(of: [expectation], timeout: 2.0)
        cancellable.cancel()
    }
}
