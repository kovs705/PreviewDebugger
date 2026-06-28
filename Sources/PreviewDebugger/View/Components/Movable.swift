//
//  Movable.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 28.06.2026.
//  https://github.com/kovs705
//

import SwiftUI

/// Makes a view draggable with smooth, 1:1 finger tracking.
///
/// The accumulated position is stored in the caller-owned `offset` binding so it
/// survives view rebuilds, while the in-flight translation is held in a
/// `@GestureState` (which automatically resets to `.zero` when the gesture ends).
///
/// Performance: because the gesture state lives *inside* this modifier, only the
/// modifier's body re-evaluates while dragging. The wrapped `content` is built
/// once by the parent and reused on every frame, so even an expensive panel
/// (materials, shadows, a `ScrollView` full of controls) tracks the finger
/// without rebuilding — the key to staying smooth at 120fps.
struct Movable: ViewModifier {

    @Binding var offset: CGSize
    @GestureState private var translation: CGSize = .zero

    func body(content: Content) -> some View {
        content
            // `.offset` is a render-time transform: it moves the layer without
            // re-running layout, so dragging never re-flows the panel.
            .offset(x: offset.width + translation.width,
                    y: offset.height + translation.height)
            // Attached to the whole content but as a low-priority (ancestor)
            // gesture, so descendant gestures win inside their bounds:
            // a `ScrollView` still scrolls and `Button`s still tap, while drags
            // on the surrounding chrome reposition the view.
            .gesture(
                DragGesture(minimumDistance: 4, coordinateSpace: .global)
                    .updating($translation) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        offset.width += value.translation.width
                        offset.height += value.translation.height
                    }
            )
    }
}

extension View {
    /// Adds a smooth, isolated drag interaction that accumulates movement into
    /// `offset`. See ``Movable`` for the performance rationale.
    func movable(offset: Binding<CGSize>) -> some View {
        modifier(Movable(offset: offset))
    }
}
