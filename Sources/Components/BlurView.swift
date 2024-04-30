//
//  BlurView.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 30.04.2024.
//  https://github.com/kovs705
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var effect: UIVisualEffect?

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView()
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}
