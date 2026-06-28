//
//  ModeParam.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.04.2024.
//  https://github.com/kovs705
//

import SwiftUI

/// Refers to `public extension EnvironmentValues`.
/// Consider to add a new property there in order to control it from ModesView.
/// Parameters model to keep the track of values
struct ModeParameters {
    // locale
    let locales: [Locale]
    let locale: Binding<Locale>

    // UI
    let colorScheme: Binding<ColorScheme>
    let textSize: Binding<DynamicTypeSize>
    let layoutDirection: Binding<LayoutDirection>
    let tint: Binding<Color?>

    // Accessibility
    let accessibilityEnabled: Binding<Bool>

    // Debugging tools
    let mainThreadMonitorEnabled: Binding<Bool>
    let gridEnabled: Binding<Bool>
    let layoutGuidesEnabled: Binding<Bool>

    // Actions
    let onReset: () -> Void
    let onScreenshot: () -> Void
}
