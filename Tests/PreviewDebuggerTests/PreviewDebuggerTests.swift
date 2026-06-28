import XCTest
@testable import PreviewDebugger

/// Smoke test entry point. The substantive suites live in the subject-grouped
/// files (BindingTests, DynamicSizeTests, EnvironmentValuesTests,
/// WatchdogTests, MainThreadMonitorTests).
final class PreviewDebuggerTests: XCTestCase {
    func testModuleImports() throws {
        // If this compiles and runs, @testable import PreviewDebugger works.
        XCTAssertTrue(true)
    }

    func testPreviewModifierEnablesAccessibilityByDefault() throws {
        let defaults = PreviewModifier.defaultParameters()

        XCTAssertTrue(defaults.accessibilityEnabled)
    }
}
