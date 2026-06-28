//
//  LayoutGuidesOverlay.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.06.2026.
//  https://github.com/kovs705
//

import SwiftUI

/// A non-interactive overlay that visualises layout references: the safe-area
/// inset rectangle, the rule-of-thirds lines and the centre cross-hair.
///
/// The geometry is read from a `GeometryReader` that *respects* the safe area
/// (so the real insets are known), then the drawing canvas is expanded by those
/// insets and offset back to the screen origin. This lets the guides bleed to
/// the physical screen edges while still drawing the safe-area rectangle in the
/// correct place.
struct LayoutGuidesOverlay: View {

    var tint: Color = .pink

    var body: some View {
        GeometryReader { proxy in
            let insets = proxy.safeAreaInsets
            let fullWidth = proxy.size.width + insets.leading + insets.trailing
            let fullHeight = proxy.size.height + insets.top + insets.bottom
            let safeRect = CGRect(
                x: insets.leading,
                y: insets.top,
                width: proxy.size.width,
                height: proxy.size.height
            )

            Canvas { context, size in
                drawThirds(in: &context, size: size)
                drawSafeArea(in: &context, rect: safeRect)
                drawCenter(in: &context, size: size)
            }
            .frame(width: fullWidth, height: fullHeight)
            .offset(x: -insets.leading, y: -insets.top)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func drawSafeArea(in context: inout GraphicsContext, rect: CGRect) {
        let path = Path { $0.addRect(rect) }
        context.stroke(
            path,
            with: .color(tint.opacity(0.9)),
            style: StrokeStyle(lineWidth: 1, dash: [4, 3])
        )
    }

    private func drawThirds(in context: inout GraphicsContext, size: CGSize) {
        var path = Path()
        for fraction in [1.0 / 3.0, 2.0 / 3.0] {
            let x = size.width * fraction
            let y = size.height * fraction
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: size.height))
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))
        }
        context.stroke(path, with: .color(tint.opacity(0.35)), lineWidth: 0.5)
    }

    private func drawCenter(in context: inout GraphicsContext, size: CGSize) {
        let centerX = size.width / 2
        let centerY = size.height / 2
        let length: CGFloat = 12
        var path = Path()
        path.move(to: CGPoint(x: centerX - length, y: centerY))
        path.addLine(to: CGPoint(x: centerX + length, y: centerY))
        path.move(to: CGPoint(x: centerX, y: centerY - length))
        path.addLine(to: CGPoint(x: centerX, y: centerY + length))
        context.stroke(path, with: .color(tint), lineWidth: 1.5)
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color(white: 0.95)
        LayoutGuidesOverlay()
    }
}
#endif
