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

    @State private var isHidden = true // hide in small icon
    @State private var parameters = PreviewModifier.defaultParameters()
    @State private var tintColor: Color?
    @State private var isMainThreadMonitorEnabled = false
    @State private var isGridEnabled = false
    @State private var isLayoutGuidesEnabled = false
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
            .tint(tintColor)
            .overlay { toolsOverlay }
            .overlay(alignment: isHidden ? .bottomTrailing : .center) {
                if isVisible {
                    ModesView(params: modeParameters(), isHidden: $isHidden)
                        .preferredColorScheme(colorScheme)
                }
            }
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

    @ViewBuilder private var toolsOverlay: some View {
        ZStack {
            if isGridEnabled {
                GridOverlay()
            }
            if isLayoutGuidesEnabled {
                LayoutGuidesOverlay()
            }
        }
    }

    private func updateValuesFromEnvironment() {
        parameters.locale = EnvironmentValues.currentLocale ?? locale
        parameters.colorScheme = colorScheme
        parameters.dynamicTypeSize = dynamicSize
        parameters.layoutDirection = layoutDirection
        parameters.accessibilityEnabled = true
    }

    static func defaultParameters() -> EnvironmentValues {
        var parameters = EnvironmentValues()
        parameters.accessibilityEnabled = true
        return parameters
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
            tint: $tintColor,
            accessibilityEnabled: $parameters.accessibilityEnabled.onChange({ _ in
                self.onChange?(.accessibilityEnabled)
            }),
            mainThreadMonitorEnabled: $isMainThreadMonitorEnabled,
            gridEnabled: $isGridEnabled,
            layoutGuidesEnabled: $isLayoutGuidesEnabled,
            onReset: resetAll,
            onScreenshot: takeScreenshot
        )
    }

    private func handleMainThreadMonitorChange(_ isEnabled: Bool) {
        if isEnabled {
            monitorViewModel.startMonitoring()
        } else {
            monitorViewModel.stopMonitoring()
        }
    }

    private func resetAll() {
        withAnimation(.easeInOut) {
            updateValuesFromEnvironment()
            tintColor = nil
            isGridEnabled = false
            isLayoutGuidesEnabled = false
            isMainThreadMonitorEnabled = false
        }
        applyColorSchemeToApplication(parameters.colorScheme)
        Haptic.successFeedback()
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

#if canImport(UIKit) && !os(macOS)
    private func takeScreenshot() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            let image = window.snapshot()
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            Haptic.successFeedback()
        } else {
            Haptic.errorFeedback()
        }
    }
#else
    private func takeScreenshot() {
        // Screenshot capture is not yet supported on macOS.
    }
#endif

}
