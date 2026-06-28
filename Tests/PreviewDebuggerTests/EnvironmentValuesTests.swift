import XCTest
import SwiftUI
@testable import PreviewDebugger

final class EnvironmentValuesTests: XCTestCase {

    typealias Diff = EnvironmentValues.Diff

    // MARK: - Diff raw values

    func testDiffIndividualRawValues() {
        XCTAssertEqual(Diff.locale.rawValue, 1 << 0)
        XCTAssertEqual(Diff.colorScheme.rawValue, 1 << 1)
        XCTAssertEqual(Diff.dynamicSize.rawValue, 1 << 2)
        XCTAssertEqual(Diff.layoutDirection.rawValue, 1 << 3)
        XCTAssertEqual(Diff.accessibilityEnabled.rawValue, 1 << 4)
    }

    func testDiffRawValuesAreDistinct() {
        let values = [
            Diff.locale, .colorScheme, .dynamicSize, .layoutDirection, .accessibilityEnabled
        ].map(\.rawValue)
        XCTAssertEqual(Set(values).count, values.count)
    }

    // MARK: - OptionSet semantics

    func testDiffUnionContainsBothMembers() {
        let combined: Diff = [.locale, .colorScheme]

        XCTAssertTrue(combined.contains(.locale))
        XCTAssertTrue(combined.contains(.colorScheme))
        XCTAssertFalse(combined.contains(.dynamicSize))
    }

    func testDiffUnionRawValueIsBitwiseOr() {
        let combined: Diff = [.locale, .dynamicSize]
        XCTAssertEqual(combined.rawValue, (1 << 0) | (1 << 2))
    }

    func testDiffInsertAndRemove() {
        var set: Diff = [.locale]
        set.insert(.colorScheme)
        XCTAssertTrue(set.contains(.colorScheme))

        set.remove(.locale)
        XCTAssertFalse(set.contains(.locale))
        XCTAssertTrue(set.contains(.colorScheme))
    }

    func testDiffIntersection() {
        let a: Diff = [.locale, .colorScheme, .dynamicSize]
        let b: Diff = [.colorScheme, .layoutDirection]
        XCTAssertEqual(a.intersection(b), [.colorScheme])
    }

    func testDiffEmptySetContainsNothing() {
        let empty: Diff = []
        XCTAssertFalse(empty.contains(.locale))
        XCTAssertEqual(empty.rawValue, 0)
    }

    // MARK: - supportedLocales / currentLocale

    func testSupportedLocalesDerivesFromMainBundleLocalizations() {
        // Deterministic: this mirrors exactly the source's construction. Under the
        // test bundle the set of localizations is environment-dependent, so we only
        // assert structural equivalence, not specific contents.
        let expected = Bundle.main.localizations.map { Locale(identifier: $0) }
        XCTAssertEqual(
            EnvironmentValues.supportedLocales.map(\.identifier),
            expected.map(\.identifier)
        )
    }

    func testSupportedLocalesIsStableAcrossReads() {
        // It is a lazily-initialized static; repeated reads must return the same data.
        let first = EnvironmentValues.supportedLocales.map(\.identifier)
        let second = EnvironmentValues.supportedLocales.map(\.identifier)
        XCTAssertEqual(first, second)
    }

    func testCurrentLocaleIsAmongSupportedWhenNonNil() {
        // currentLocale resolves Locale.current against supportedLocales by full or
        // 2-letter prefix. Whether it is nil depends on the test host's localizations
        // (non-deterministic), so we only assert the invariant: when present, it is a
        // prefix-match of a supported locale.
        guard let current = EnvironmentValues.currentLocale else {
            // Acceptable: the test bundle may have no localization matching Locale.current.
            return
        }
        let matches = EnvironmentValues.supportedLocales.contains {
            $0.identifier.hasPrefix(current.identifier) ||
            current.identifier.hasPrefix($0.identifier)
        }
        XCTAssertTrue(matches, "currentLocale \(current.identifier) should relate to a supported locale")
    }
}
