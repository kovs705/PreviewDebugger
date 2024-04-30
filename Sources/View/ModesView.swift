//
//  ModesView.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.04.2024.
//  https://github.com/kovs705
//

import SwiftUI

struct ModesView: View {
    
    var params: ModeParameters
    @Binding var isHidden: Bool
    
    // MARK: - Body
    var body: some View {
        innerContent
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
            )
            .padding(70)
    }
    
    // MARK: - Components
    @ViewBuilder var innerContent: some View {
        VStack {
            themeToggler
            localesSelector
        }
    }
    
    @ViewBuilder var themeToggler: some View {
        Toggle("Light or dark theme", isOn: params.colorScheme.map(toValue:
                                                        { $0 == .dark },
                                                      fromValue: { $0 ? .dark : .light }))
    }
    
    @ViewBuilder var localesSelector: some View {
        HStack {
            Text("Locale")
            Spacer()
            Picker("", selection: params.locale.onChange({ _ in
                Haptic.toggleFeedback()
            })) {
                ForEach(params.locales, id: \.identifier) { locale in
                    Text(locale.identifier)
                }
            }.pickerStyle(.segmented)
        }
    }
    
    
}

// MARK: - Preview
#if DEBUG
#Preview {
    ModesView(params:
                ModeParameters(locales: [
                    Locale(identifier: "en"),
                    Locale(identifier: "ru"),
                    Locale(identifier: "jp")
                ],
                               locale: Binding<Locale>(wrappedValue: Locale(identifier: "en")),
                               colorScheme: Binding<ColorScheme>(wrappedValue: .light),
                               textSize: Binding<ContentSizeCategory>(wrappedValue: .medium),
                               layoutDirection: Binding<LayoutDirection>(wrappedValue: .leftToRight),
                               accessibilityEnabled: Binding<Bool>(wrappedValue: false),
                               accessibilityReduceMotionEnabled: Binding<Bool>(wrappedValue: false),
                               accessibilityInvertedColorsEnabled: Binding<Bool>(wrappedValue: false),
                               accessibilityDifferentiateWithoutColorEnabled: Binding<Bool>(wrappedValue: false)),
              isHidden: Binding<Bool>(wrappedValue: false))
}
#endif


