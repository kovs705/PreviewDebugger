//
//  TestView.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 02.05.2024.
//  https://github.com/kovs705
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            Text("This is a test view")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    SwiftUIView()
        .modifier(PreviewModifier(onChange: { _ in
            //
        }))
}
