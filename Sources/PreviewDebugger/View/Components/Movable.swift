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

    /// When `true` the drag wins over interactive descendants (used for the
    /// collapsed button, whose own press gesture would otherwise swallow the
    /// drag and only commit it on release). When `false` the drag stays a
    /// low-priority ancestor gesture so a child `ScrollView` keeps scrolling.
    var winsOverChildren: Bool = false

    @GestureState private var translation: CGSize = .zero

    func body(content: Content) -> some View {
        // `Group { if/else }` lets the two gesture-attachment forms (which have
        // distinct concrete types) live in one ViewBuilder.
        Group {
            if winsOverChildren {
                positioned(content).highPriorityGesture(dragGesture)
            } else {
                positioned(content).gesture(dragGesture)
            }
        }
    }

    private func positioned(_ content: Content) -> some View {
        content
            // Publish the drag state so surfaces can shed expensive effects
            // (e.g. shadows) while moving. This flips at most twice per drag —
            // on start and end — so it never invalidates the panel per frame.
            .environment(\.isHelperDragging, translation != .zero)
            // `.offset` is a render-time transform: it moves the layer without
            // re-running layout, so dragging never re-flows the panel.
            .offset(x: offset.width + translation.width,
                    y: offset.height + translation.height)
    }

    private var dragGesture: some Gesture {
        // `minimumDistance` keeps a stationary tap free so the collapsed button
        // still opens on tap; only real movement starts a drag.
        DragGesture(minimumDistance: 4, coordinateSpace: .global)
            .updating($translation) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                offset.width += value.translation.width
                offset.height += value.translation.height
            }
    }
}

extension View {
    /// Adds a smooth, isolated drag interaction that accumulates movement into
    /// `offset`. See ``Movable`` for the performance rationale.
    ///
    /// - Parameter winsOverChildren: pass `true` when the wrapped content is an
    ///   interactive control (e.g. a `Button`) that would otherwise capture the
    ///   touch; pass `false` (default) when it contains a scrollable child that
    ///   should keep receiving drags.
    func movable(offset: Binding<CGSize>, winsOverChildren: Bool = false) -> some View {
        modifier(Movable(offset: offset, winsOverChildren: winsOverChildren))
    }
}

// MARK: - Drag state environment

private struct HelperDraggingKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    /// `true` while the UI helper is being repositioned. Surfaces read this to
    /// drop costly, per-frame render effects (shadows, blurs) during a drag.
    var isHelperDragging: Bool {
        get { self[HelperDraggingKey.self] }
        set { self[HelperDraggingKey.self] = newValue }
    }
}
