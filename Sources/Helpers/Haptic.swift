//
//  Haptic.swift
//
//
//  Created by user on 27.04.2024.
//

import Foundation
import CoreHaptics

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
