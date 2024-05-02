//
//  PreviewModifier.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 02.05.2024.
//  https://github.com/kovs705
//

import SwiftUI

struct PreviewModifier: ViewModifier {
    
    // UI
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    // Accessibility
    @Environment(\.accessibilityEnabled) private var accessibilityEnabled: Bool
//    @Environment(\.accessibilityReduceMotion) private var reduceMotionEnabled: Bool
//    @Environment(\.accessibilityInvertColors) private var invertedColorsEnabled: Bool
//    @Environment(\.accessibilityDifferentiateWithoutColor) private var colorBlindnessEnabled: Bool
//    @Environment(\.accessibilityReduceTransparency) private var reducedTransparencyEnabled: Bool
    
    @State private var parameters = EnvironmentValues()
    let onChange: ((EnvironmentValues.Diff) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, parameters.colorScheme)
            .environment(\.sizeCategory, parameters.sizeCategory)
            .environment(\.layoutDirection, parameters.layoutDirection)
        
            .environment(\.accessibilityEnabled, parameters.accessibilityEnabled)
//            .environment(\.accessibilityReduceMotion, parameters.accessibilityReduceMotion)
//            .environment(\.accessibilityInvertColors, parameters.accessibilityInvertColors)
//            .environment(\.accessibilityDifferentiateWithoutColor, parameters.accessibilityDifferentiateWithoutColor)
//            .environment(\.accessibilityReduceTransparency, parameters.accessibilityReduceTransparency)
    }
}
