//
//  View+Ext.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 02.05.2024.
//  https://github.com/kovs705
//

import SwiftUI

extension View {
    @ViewBuilder func applyIfDebug<Modifier: ViewModifier>(with modifier: Modifier) -> some View {
#if DEBUG
        self
            .modifier(modifier)
#else
        self
#endif
    }
}
