//
//  DebugSurface.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 28.06.2026.
//  https://github.com/kovs705
//

import SwiftUI

/// The frosted-glass backing used by the helper's collapsed button and expanded
/// panel: a material fill, a hairline stroke, and a drop shadow.
///
/// The shadow is the only effect that must re-rasterize as the surface moves, so
/// it is suppressed while ``EnvironmentValues/isHelperDragging`` is `true`,
/// keeping drags cheap. It returns the instant the drag ends.
struct DebugSurface<S: Shape>: View {

    let shape: S
    var shadowRadius: CGFloat = 18
    var shadowOpacity: Double = 0.22
    var shadowY: CGFloat = 8

    @Environment(\.isHelperDragging) private var isDragging

    var body: some View {
        shape
            .fill(.ultraThinMaterial)
            .overlay(shape.stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
            .shadow(
                color: .black.opacity(isDragging ? 0 : shadowOpacity),
                radius: isDragging ? 0 : shadowRadius,
                y: isDragging ? 0 : shadowY
            )
    }
}
