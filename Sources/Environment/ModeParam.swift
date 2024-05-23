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
    
    // Accessibility
    let accessibilityEnabled: Binding<Bool>
}
