import XCTest
import SwiftUI
@testable import PreviewDebugger

final class BindingTests: XCTestCase {

    // MARK: - map(toValue:fromValue:)

    func testMapGetTransformsUnderlyingValue() {
        let base = Binding(wrappedValue: 5)
        let mapped = base.map(toValue: { String($0) }, fromValue: { Int($0) ?? 0 })

        XCTAssertEqual(mapped.wrappedValue, "5")
    }

    func testMapSetWritesBackThroughFromValue() {
        let base = Binding(wrappedValue: 5)
        let mapped = base.map(toValue: { String($0) }, fromValue: { Int($0) ?? 0 })

        mapped.wrappedValue = "42"

        XCTAssertEqual(base.wrappedValue, 42)
        XCTAssertEqual(mapped.wrappedValue, "42")
    }

    func testMapRoundTripPreservesValue() {
        // Round-trip: read mapped, write it straight back, underlying is unchanged.
        let base = Binding(wrappedValue: 7)
        let mapped = base.map(toValue: { $0 * 2 }, fromValue: { $0 / 2 })

        XCTAssertEqual(mapped.wrappedValue, 14)
        mapped.wrappedValue = mapped.wrappedValue
        XCTAssertEqual(base.wrappedValue, 7)
    }

    func testMapBooleanInversionRoundTrip() {
        let base = Binding(wrappedValue: true)
        let inverted = base.map(toValue: { !$0 }, fromValue: { !$0 })

        XCTAssertFalse(inverted.wrappedValue)
        inverted.wrappedValue = true   // means base == false
        XCTAssertFalse(base.wrappedValue)
        XCTAssertTrue(inverted.wrappedValue)
    }

    // MARK: - onChange

    func testOnChangeFiresSideEffectOnSet() {
        let base = Binding(wrappedValue: 0)
        var observed: [Int] = []
        let watched = base.onChange { observed.append($0) }

        watched.wrappedValue = 1
        watched.wrappedValue = 2

        XCTAssertEqual(observed, [1, 2])
    }

    func testOnChangeUpdatesUnderlyingValue() {
        let base = Binding(wrappedValue: 0)
        let watched = base.onChange { _ in }

        watched.wrappedValue = 99

        XCTAssertEqual(base.wrappedValue, 99)
        XCTAssertEqual(watched.wrappedValue, 99)
    }

    func testOnChangeDoesNotFireOnGet() {
        let base = Binding(wrappedValue: 10)
        var fired = false
        let watched = base.onChange { _ in fired = true }

        _ = watched.wrappedValue

        XCTAssertFalse(fired)
    }

    func testOnChangeReceivesTheNewValue() {
        let base = Binding(wrappedValue: "a")
        var last: String?
        let watched = base.onChange { last = $0 }

        watched.wrappedValue = "b"

        XCTAssertEqual(last, "b")
    }
}
