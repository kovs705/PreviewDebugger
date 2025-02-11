//
//  PreviewModifier.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 02.05.2024.
//  https://github.com/kovs705
//

import SwiftUI

public struct PreviewModifier: ViewModifier {
    
    // UI
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dynamicTypeSize) private var dynamicSize: DynamicTypeSize
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.locale) private var locale: Locale
    // Accessibility
    @Environment(\.accessibilityEnabled) private var accessibilityEnabled: Bool
    
    @State private var isHidden = true // hide in small icon
    @State private var parameters = EnvironmentValues()
    @Binding var isVisible: Bool // visibility in overlay
    
    let onChange: ((EnvironmentValues.Diff) -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, parameters.colorScheme)
            .environment(\.dynamicTypeSize, parameters.dynamicTypeSize)
            .environment(\.layoutDirection, parameters.layoutDirection)
            .environment(\.accessibilityEnabled, parameters.accessibilityEnabled)
            .environment(\.locale, parameters.locale)
            .overlay(alignment: isHidden ? .bottomTrailing : .center, content: {
                if isVisible {
                    ModesView(params: modeParameters(), isHidden: $isHidden)
                        .preferredColorScheme(colorScheme)
                }
            })
        
            .onAppear {
                updateValuesFromEnvironment()
            }
    }
    
    private func updateValuesFromEnvironment() {
        parameters.locale = EnvironmentValues.currentLocale ?? locale
        parameters.colorScheme = colorScheme
        parameters.dynamicTypeSize = dynamicSize
        parameters.layoutDirection = layoutDirection
        parameters.accessibilityEnabled = accessibilityEnabled
    }
    
    private func modeParameters() -> ModeParameters {
        return ModeParameters(
            locales: EnvironmentValues.supportedLocales,
            locale: $parameters.locale.onChange({ _ in
                self.onChange?(.locale)
            }),
            colorScheme: $parameters.colorScheme.onChange({ _ in
                self.onChange?(.colorScheme)
            }),
            textSize: $parameters.dynamicTypeSize.onChange({ _ in
                self.onChange?(.dynamicSize)
            }),
            layoutDirection: $parameters.layoutDirection.onChange({ _ in
                self.onChange?(.layoutDirection)
            }),
            accessibilityEnabled: $parameters.accessibilityEnabled.onChange({ _ in
                self.onChange?(.accessibilityEnabled)
            })
        )
    }
    
}
