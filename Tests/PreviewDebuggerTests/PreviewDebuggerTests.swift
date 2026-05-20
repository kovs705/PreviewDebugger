import XCTest
@testable import PreviewDebugger

final class PreviewDebuggerTests: XCTestCase {
    func testPreviewModifierEnablesAccessibilityByDefault() throws {
        let defaults = PreviewModifier.defaultParameters()

        XCTAssertTrue(defaults.accessibilityEnabled)
    }
}
