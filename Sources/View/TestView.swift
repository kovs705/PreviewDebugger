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
        navigationWrapper {
            ScrollView {
                Text("This is a test view screen")
            }
            .navigationTitle("Test view title")
        }
    }
    
    @ViewBuilder func navigationWrapper<Content: View>(_ content: @escaping () -> Content) -> some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content()
            }
        } else {
            NavigationView {
                content()
            }
        }
    }
}

#Preview {
    SwiftUIView()
        .modifier(PreviewModifier(onChange: { _ in
            //
        }))
}
