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
                    .background(
                        .ultraThinMaterial
                    )
                    .clipShape(.rect(cornerRadius: 15))
            )
            .padding(50)
    }
    
    // MARK: - Components
    @ViewBuilder var innerContent: some View {
        if isHidden {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.body)
        } else {
            VStack {
                hideButton
                themeToggler
                localesSelector
                sizeSlider
                directionToggle
                accessibilityToggler
                //            invertedColorsToggle
                //            colorBlindnessToggler
                screenshotter
            }
        }
    }
    
    @ViewBuilder var hideButton: some View {
        HStack {
            Text("UI Helper")
                .bold()
            
            Spacer()
            
            Image(systemName: "xmark")
                .padding(5)
                .background(Circle().fill(Color(uiColor: .systemBackground)))
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
    
    @ViewBuilder var sizeSlider: some View {
        HStack {
            Text("**Size slider coming soon**")
            Spacer()
        }
    }
    
    @ViewBuilder var directionToggle: some View {
        Toggle("Layout direction", isOn: params.layoutDirection.map(toValue: { $0 == .rightToLeft },
                                                                    fromValue: { $0 ? .rightToLeft : .leftToRight }))
    }
    
    @ViewBuilder var accessibilityToggler: some View {
        Toggle("Accessibility", isOn: params.accessibilityEnabled)
    }
    
    @ViewBuilder var screenshotter: some View {
        HStack {
            Button(action: {
                
            }, label: {
                Text("Take a screenshot")
            })
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
                               accessibilityEnabled: Binding<Bool>(wrappedValue: false)),
              isHidden: Binding<Bool>(wrappedValue: false))
}
#endif
