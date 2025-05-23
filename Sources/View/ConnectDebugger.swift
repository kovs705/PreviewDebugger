//
//  ConnectDebugger.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 19.05.2024.
//  https://github.com/kovs705
//

import SwiftUI

public extension View {
    func connectDebugger(
        isVisible: Binding<Bool> = .constant(true),
        onChange: ((EnvironmentValues.Diff) -> Void)? = nil
    ) -> some View {
        modifier(PreviewModifier(isVisible: isVisible, onChange: onChange))
        }
}
