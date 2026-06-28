//
//  GridOverlay.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.06.2026.
//  https://github.com/kovs705
//

import SwiftUI

/// A non-interactive pixel grid drawn on top of the inspected view.
///
/// Minor lines are spaced every ``spacing`` points, with an emphasized major line
/// every ``majorEvery`` cells and a cross-hair through the centre. Useful for
/// eyeballing alignment, rhythm and spacing while debugging a layout.
struct GridOverlay: View {

    var spacing: CGFloat = 8
    var majorEvery: Int = 8
    var tint: Color = .accentColor

    var body: some View {
        Canvas { context, size in
            drawLines(in: &context, size: size)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func drawLines(in context: inout GraphicsContext, size: CGSize) {
        guard spacing > 0 else { return }

        var minorPath = Path()
        var majorPath = Path()

        appendVerticalLines(minor: &minorPath, major: &majorPath, size: size)
        appendHorizontalLines(minor: &minorPath, major: &majorPath, size: size)

        context.stroke(minorPath, with: .color(tint.opacity(0.18)), lineWidth: 0.5)
        context.stroke(majorPath, with: .color(tint.opacity(0.45)), lineWidth: 1)
    }

    private func appendVerticalLines(minor: inout Path, major: inout Path, size: CGSize) {
        var index = 0
        var x: CGFloat = 0
        while x <= size.width {
            let isMajor = index % majorEvery == 0
            let line = CGRect(x: x, y: 0, width: 0, height: size.height)
            if isMajor {
                major.addLines([CGPoint(x: line.minX, y: 0), CGPoint(x: line.minX, y: size.height)])
            } else {
                minor.addLines([CGPoint(x: line.minX, y: 0), CGPoint(x: line.minX, y: size.height)])
            }
            x += spacing
            index += 1
        }
    }

    private func appendHorizontalLines(minor: inout Path, major: inout Path, size: CGSize) {
        var index = 0
        var y: CGFloat = 0
        while y <= size.height {
            let isMajor = index % majorEvery == 0
            if isMajor {
                major.addLines([CGPoint(x: 0, y: y), CGPoint(x: size.width, y: y)])
            } else {
                minor.addLines([CGPoint(x: 0, y: y), CGPoint(x: size.width, y: y)])
            }
            y += spacing
            index += 1
        }
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color(white: 0.95)
        GridOverlay(tint: .blue)
    }
    .ignoresSafeArea()
}
#endif
