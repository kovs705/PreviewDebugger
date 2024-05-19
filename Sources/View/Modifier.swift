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
    @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    // Accessibility
    @Environment(\.accessibilityEnabled) private var accessibilityEnabled: Bool
    
    @State private var isHidden = true
    @State private var parameters = EnvironmentValues()
    let onChange: ((EnvironmentValues.Diff) -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, parameters.colorScheme)
            .environment(\.sizeCategory, parameters.sizeCategory)
            .environment(\.layoutDirection, parameters.layoutDirection)
#if DEBUG
            .overlay(alignment: isHidden ? .bottomTrailing : .center, content: {
                ModesView(params: modeParameters(), isHidden: $isHidden)
            })
#endif
            .environment(\.accessibilityEnabled, parameters.accessibilityEnabled)
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
    
//    private func overlayIfRequired<Content: View>(for content: Content) -> some View {
//        Group {
//#if DEBUG
//            content
//                .overlay(alignment: .bottomTrailing, content: {
//                    ModesView(params: modeParameters(), isHidden: $isHidden)
//                })
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//#else
//            content
//#endif
//        }
//    }
}
