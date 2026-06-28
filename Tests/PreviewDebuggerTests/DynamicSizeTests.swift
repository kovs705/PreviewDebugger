import XCTest
import SwiftUI
@testable import PreviewDebugger

final class DynamicSizeTests: XCTestCase {

    // MARK: - DynamicTypeSize

    func testDynamicTypeSizeStrideMatchesCachedStride() {
        XCTAssertEqual(DynamicTypeSize.stride, DynamicTypeSize.cachedStride)
    }

    func testDynamicTypeSizeCachedStrideValue() {
        let expected = 1 / CGFloat(DynamicTypeSize.allCases.count - 1)
        XCTAssertEqual(DynamicTypeSize.cachedStride, expected, accuracy: 1e-12)
    }

    func testDynamicTypeSizeFirstCaseHasZeroFloatValue() throws {
        let first = try XCTUnwrap(DynamicTypeSize.allCases.first)
        XCTAssertEqual(first.floatValue, 0, accuracy: 1e-12)
    }

    func testDynamicTypeSizeLastCaseHasOneFloatValue() throws {
        let last = try XCTUnwrap(DynamicTypeSize.allCases.last)
        XCTAssertEqual(last.floatValue, 1, accuracy: 1e-12)
    }

    func testDynamicTypeSizeFloatValueRoundTripForEveryCase() {
        for size in DynamicTypeSize.allCases {
            let restored = DynamicTypeSize.from(float: size.floatValue)
            XCTAssertEqual(restored, size, "Round-trip failed for \(size)")
        }
    }

    func testDynamicTypeSizeInitFloatValueMatchesFrom() {
        for size in DynamicTypeSize.allCases {
            XCTAssertEqual(DynamicTypeSize(floatValue: size.floatValue), size)
        }
    }

    func testDynamicTypeSizeClampsNegativeToFirst() {
        XCTAssertEqual(DynamicTypeSize.from(float: -5), DynamicTypeSize.allCases.first)
        XCTAssertEqual(DynamicTypeSize(floatValue: -0.0001), DynamicTypeSize.allCases.first)
    }

    func testDynamicTypeSizeClampsAboveOneToLast() {
        XCTAssertEqual(DynamicTypeSize.from(float: 2), DynamicTypeSize.allCases.last)
        XCTAssertEqual(DynamicTypeSize(floatValue: 99), DynamicTypeSize.allCases.last)
    }

    func testDynamicTypeSizeNameMappings() {
        XCTAssertEqual(DynamicTypeSize.xSmall.name, "XS")
        XCTAssertEqual(DynamicTypeSize.small.name, "S")
        XCTAssertEqual(DynamicTypeSize.medium.name, "M")
        XCTAssertEqual(DynamicTypeSize.large.name, "L (default)")
        XCTAssertEqual(DynamicTypeSize.xLarge.name, "XL")
        XCTAssertEqual(DynamicTypeSize.xxLarge.name, "XXL")
        XCTAssertEqual(DynamicTypeSize.xxxLarge.name, "XXXL")
        XCTAssertEqual(DynamicTypeSize.accessibility1.name, "Accessibility M")
        XCTAssertEqual(DynamicTypeSize.accessibility2.name, "Accessibility L")
        XCTAssertEqual(DynamicTypeSize.accessibility3.name, "Accessibility XL")
        XCTAssertEqual(DynamicTypeSize.accessibility4.name, "Accessibility XXL")
        XCTAssertEqual(DynamicTypeSize.accessibility5.name, "Accessibility XXXL")
    }

    func testDynamicTypeSizeNoNameIsUnknownForKnownCases() {
        for size in DynamicTypeSize.allCases {
            XCTAssertNotEqual(size.name, "Unknown", "Unexpected Unknown for \(size)")
        }
    }

    // MARK: - ContentSizeCategory

    func testContentSizeCategoryStrideMatchesCachedStride() {
        XCTAssertEqual(ContentSizeCategory.stride, ContentSizeCategory.cachedStride)
    }

    func testContentSizeCategoryCachedStrideValue() {
        let expected = 1 / CGFloat(ContentSizeCategory.allCases.count - 1)
        XCTAssertEqual(ContentSizeCategory.cachedStride, expected, accuracy: 1e-12)
    }

    func testContentSizeCategoryFirstCaseHasZeroFloatValue() throws {
        let first = try XCTUnwrap(ContentSizeCategory.allCases.first)
        XCTAssertEqual(first.floatValue, 0, accuracy: 1e-12)
    }

    func testContentSizeCategoryLastCaseHasOneFloatValue() throws {
        let last = try XCTUnwrap(ContentSizeCategory.allCases.last)
        XCTAssertEqual(last.floatValue, 1, accuracy: 1e-12)
    }

    func testContentSizeCategoryFloatValueRoundTripForEveryCase() {
        for category in ContentSizeCategory.allCases {
            let restored = ContentSizeCategory.from(float: category.floatValue)
            XCTAssertEqual(restored, category, "Round-trip failed for \(category)")
        }
    }

    func testContentSizeCategoryInitFloatValueMatchesFrom() {
        for category in ContentSizeCategory.allCases {
            XCTAssertEqual(ContentSizeCategory(floatValue: category.floatValue), category)
        }
    }

    func testContentSizeCategoryClampsNegativeToFirst() {
        XCTAssertEqual(ContentSizeCategory.from(float: -5), ContentSizeCategory.allCases.first)
        XCTAssertEqual(ContentSizeCategory(floatValue: -1), ContentSizeCategory.allCases.first)
    }

    func testContentSizeCategoryClampsAboveOneToLast() {
        XCTAssertEqual(ContentSizeCategory.from(float: 2), ContentSizeCategory.allCases.last)
        XCTAssertEqual(ContentSizeCategory(floatValue: 50), ContentSizeCategory.allCases.last)
    }

    func testContentSizeCategoryNameMappings() {
        XCTAssertEqual(ContentSizeCategory.extraSmall.name, "XS")
        XCTAssertEqual(ContentSizeCategory.small.name, "S")
        XCTAssertEqual(ContentSizeCategory.medium.name, "M")
        XCTAssertEqual(ContentSizeCategory.large.name, "L (default)")
        XCTAssertEqual(ContentSizeCategory.extraLarge.name, "XL")
        XCTAssertEqual(ContentSizeCategory.extraExtraLarge.name, "XXL")
        XCTAssertEqual(ContentSizeCategory.extraExtraExtraLarge.name, "XXXL")
        XCTAssertEqual(ContentSizeCategory.accessibilityMedium.name, "Accessibility M")
        XCTAssertEqual(ContentSizeCategory.accessibilityLarge.name, "Accessibility L")
        XCTAssertEqual(ContentSizeCategory.accessibilityExtraLarge.name, "Accessibility XL")
        XCTAssertEqual(ContentSizeCategory.accessibilityExtraExtraLarge.name, "Accessibility XXL")
        XCTAssertEqual(ContentSizeCategory.accessibilityExtraExtraExtraLarge.name, "Accessibility XXXL")
    }
}
