//
//  TestView.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 02.05.2024.
//  https://github.com/kovs705
//

import SwiftUI

struct SwiftUIView: View {
    
    @State private var counter = 0
    
    var body: some View {
        navigationWrapper {
            ScrollView {
                Text("This is a test view screen")
                
                counterView
            }
            .navigationTitle(String(localized: "title"))
        }
    }
    
    @ViewBuilder private func navigationWrapper<Content: View>(_ content: @escaping () -> Content) -> some View {
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
    
    @ViewBuilder var counterView: some View {
        VStack(spacing: 20) {
            Text("Counter: \(counter)")
                .font(.largeTitle)
                .accessibilityLabel("Count label")
                .accessibilityValue("\(counter)")
            
            Button(action: {
                counter += 1
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("To count up")
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Count up button")
            .accessibilityHint("By clicking this button, the counter will be increased")
        }
        .padding()
    }
}

#if DEBUG
#Preview {
    SwiftUIView()
        .connectDebugger()
}
#endif
