//
//  Haptic.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.04.2024.
//  https://github.com/kovs705
//

import SwiftUI

struct Haptic {
    
    static func successFeedback() {
        #if !os(macOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }
    
    static func errorFeedback() {
        #if !os(macOS)
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        #endif
    }
    
    static func toggleFeedback() {
        #if !os(macOS)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
    }
}
