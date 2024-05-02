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
    
    @State private var isHidden = false
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
            .onAppear {
                updateValuesFromEnvironment()
            }
    }
    
    private func updateValuesFromEnvironment() {
        parameters.colorScheme = colorScheme
        parameters.sizeCategory = sizeCategory
        parameters.layoutDirection = layoutDirection
        parameters.accessibilityEnabled = accessibilityEnabled
    }
    
    private func modeParameters() -> ModeParameters {
        return ModeParameters(locales: [],
                              locale: $parameters.locale.onChange({ _ in
            self.onChange?(.locale)
        }),
                              colorScheme: $parameters.colorScheme.onChange({ _ in
            self.onChange?(.colorScheme)
        }),
                              textSize: $parameters.sizeCategory.onChange({ _ in
            self.onChange?(.sizeCategory)
        }),
                              layoutDirection: $parameters.layoutDirection.onChange({ _ in
            self.onChange?(.layoutDirection)
        }),
                              accessibilityEnabled: $parameters.accessibilityEnabled.onChange({ _ in
            self.onChange?(.accessibilityEnabled)
        }))
    }
    
    @ViewBuilder private func overlayIfRequired<Content: View>(for content: Content) -> some View {
        Group {
#if DEBUG
            content
                .overlay(ModesView(params: modeParameters(), isHidden: $isHidden))
#else
            content
#endif
        }
    }
}
