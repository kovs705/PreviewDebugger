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
/// Handy for verifying that content respects the safe area and sits where you
/// expect relative to the screen.
struct LayoutGuidesOverlay: View {

    var tint: Color = .pink

    var body: some View {
        GeometryReader { proxy in
            let insets = proxy.safeAreaInsets
            let full = proxy.frame(in: .local)
            let safe = CGRect(
                x: full.minX + insets.leading,
                y: full.minY + insets.top,
                width: max(0, full.width - insets.leading - insets.trailing),
                height: max(0, full.height - insets.top - insets.bottom)
            )

            ZStack {
                thirds(in: full)
                safeArea(safe)
                center(in: full)
            }
            .ignoresSafeArea()
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func safeArea(_ rect: CGRect) -> some View {
        Rectangle()
            .path(in: rect)
            .stroke(tint.opacity(0.9), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
    }

    private func thirds(in rect: CGRect) -> some View {
        Path { path in
            for fraction in [1.0 / 3.0, 2.0 / 3.0] {
                let x = rect.width * fraction
                let y = rect.height * fraction
                path.addLines([CGPoint(x: x, y: 0), CGPoint(x: x, y: rect.height)])
                path.addLines([CGPoint(x: 0, y: y), CGPoint(x: rect.width, y: y)])
            }
        }
        .stroke(tint.opacity(0.35), lineWidth: 0.5)
    }

    private func center(in rect: CGRect) -> some View {
        Path { path in
            let length: CGFloat = 12
            let cx = rect.width / 2
            let cy = rect.height / 2
            path.addLines([CGPoint(x: cx - length, y: cy), CGPoint(x: cx + length, y: cy)])
            path.addLines([CGPoint(x: cx, y: cy - length), CGPoint(x: cx, y: cy + length)])
        }
        .stroke(tint, lineWidth: 1.5)
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
