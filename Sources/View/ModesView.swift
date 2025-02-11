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
    @Namespace var nspace
    
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
            Button {
                withAnimation(.easeInOut) {
                    isHidden = false
                }
            } label: {
                Image(systemName: "chart.bar.doc.horizontal")
                    .font(.body)
            }
            .matchedGeometryEffect(id: "geoeffect1", in: nspace)
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
            .matchedGeometryEffect(id: "geoeffect1", in: nspace)
        }
    }
    
    @ViewBuilder var hideButton: some View {
        HStack {
            Text("UI Helper")
                .bold()
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut) {
                    isHidden = true
                }
            } label: {
                Image(systemName: "xmark")
                    .padding(5)
                    .background(Circle().fill(Color(uiColor: .systemBackground)))
            }
        }
    }
    
    // MARK: - Theme
    @ViewBuilder var themeToggler: some View {
        Toggle("Light or dark theme", isOn: params.colorScheme.map(toValue:
                                                                    { $0 == .dark },
                                                                   fromValue: { $0 ? .dark : .light }))
    }
    
    // MARK: - Locales
    @ViewBuilder var localesSelector: some View {
        HStack {
            Text("Locale")
            Spacer()
            Picker("", selection: params.locale.onChange({ _ in
                Haptic.toggleFeedback()
            })) {
                ForEach(params.locales, id: \.identifier) { locale in
                    Text(locale.identifier)
                        .tag(locale)  // Добавляем тег для каждого элемента
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // MARK: - Size
    @ViewBuilder var sizeSlider: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Font size")
                Slider(value: params.textSize.map(toValue: { $0.floatValue },
                                                  fromValue: { DynamicTypeSize(floatValue: $0) }),
                       in: 0 ... 1,
                       step: DynamicTypeSize.stride)
            }
            textSizeText
        }
    }
    
    @ViewBuilder var textSizeText: some View {
        HStack {
            Spacer()
            Text(params.textSize.wrappedValue.name)
                .frame(alignment: .trailing)
        }
    }
    
    // MARK: - Direction
    @ViewBuilder var directionToggle: some View {
        Toggle("Layout direction", isOn: params.layoutDirection.map(toValue: { $0 == .rightToLeft },
                                                                    fromValue: { $0 ? .rightToLeft : .leftToRight }))
    }
    
    // MARK: - Accessibility
    @ViewBuilder var accessibilityToggler: some View {
        Toggle("Accessibility", isOn: params.accessibilityEnabled)
    }
    
    // MARK: - Screenshot
    @ViewBuilder var screenshotter: some View {
        HStack {
            Button(action: {
                takeScreenshot()
            }, label: {
                Text("Take a screenshot")
            })
        }
    }
    
#if !os(macOS)
    private func takeScreenshot() {
        // Trying to take the current window of the active scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            let image = window.snapshot()
            // Saving image to the album
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            Haptic.successFeedback()
        } else {
            Haptic.errorFeedback()
        }
    }
#else
    private func takeScreenshot() {
        // TODO: - Different realizaiton on macOS
        print("Screenshot not supported on macOS")
    }
#endif
    
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
                               textSize: Binding<DynamicTypeSize>(wrappedValue: .medium),
                               layoutDirection: Binding<LayoutDirection>(wrappedValue: .leftToRight),
                               accessibilityEnabled: Binding<Bool>(wrappedValue: false)),
              isHidden: Binding<Bool>(wrappedValue: false))
}
#endif
