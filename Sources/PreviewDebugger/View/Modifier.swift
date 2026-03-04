//
//  PreviewModifier.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 02.05.2024.
//  https://github.com/kovs705
//

import SwiftUI
#if canImport(UIKit) && !os(macOS)
import UIKit
#endif

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
    @State private var isMainThreadMonitorEnabled = false
    @StateObject private var monitorViewModel = MainThreadMonitorViewModel()
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
            .overlay(alignment: .bottomLeading) {
                if isMainThreadMonitorEnabled {
                    MainThreadMonitorCard(status: monitorViewModel.status)
                        .padding(.leading, 40)
                        .padding(.bottom, 40)
                }
            }
        
            .onAppear {
                updateValuesFromEnvironment()
                if isMainThreadMonitorEnabled {
                    monitorViewModel.startMonitoring()
                }
            }
            .onDisappear {
                monitorViewModel.stopMonitoring()
            }
            .onChange(of: isMainThreadMonitorEnabled) { isEnabled in
                handleMainThreadMonitorChange(isEnabled)
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
            colorScheme: $parameters.colorScheme.onChange({ newScheme in
                applyColorSchemeToApplication(newScheme)
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
            }),
            mainThreadMonitorEnabled: $isMainThreadMonitorEnabled
        )
    }

    private func handleMainThreadMonitorChange(_ isEnabled: Bool) {
        if isEnabled {
            monitorViewModel.startMonitoring()
        } else {
            monitorViewModel.stopMonitoring()
        }
    }

    private func applyColorSchemeToApplication(_ colorScheme: ColorScheme) {
#if canImport(UIKit) && !os(macOS)
        let style: UIUserInterfaceStyle = colorScheme == .dark ? .dark : .light
        UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .forEach({ $0.overrideUserInterfaceStyle = style })
#endif
    }

}
