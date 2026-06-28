//
//  ModesView.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.04.2024.
//  https://github.com/kovs705
//

#if os(macOS)
import AppKit
#endif
import SwiftUI

struct ModesView: View {

    var params: ModeParameters
    @Binding var isHidden: Bool
    @Namespace private var nspace

    @State private var dragOffset: CGSize = .zero
    @GestureState private var activeDrag: CGSize = .zero

    private static let tintPresets: [Color] = [
        .blue, .purple, .pink, .red, .orange, .yellow, .green, .teal
    ]

    // MARK: - Body
    var body: some View {
        Group {
            if isHidden {
                collapsedButton
            } else {
                expandedPanel
            }
        }
        .offset(x: dragOffset.width + activeDrag.width,
                y: dragOffset.height + activeDrag.height)
    }

    // MARK: - Collapsed
    private var collapsedButton: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                isHidden = false
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(Circle().stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                        .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
                )
        }
        .buttonStyle(.plain)
        .matchedGeometryEffect(id: "panel", in: nspace)
        .padding(20)
    }

    // MARK: - Expanded
    private var expandedPanel: some View {
        VStack(spacing: 0) {
            dragHandle
            header
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    appearanceSection
                    localizationSection
                    typographySection
                    layoutSection
                    accessibilitySection
                    diagnosticsSection
                    actionsSection
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: 360)
        .frame(maxHeight: 520)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.22), radius: 18, y: 8)
        )
        .matchedGeometryEffect(id: "panel", in: nspace)
        .padding(24)
    }

    private var dragHandle: some View {
        Capsule()
            .fill(Color.secondary.opacity(0.4))
            .frame(width: 36, height: 5)
            .padding(.top, 10)
            .padding(.bottom, 4)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .updating($activeDrag) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        dragOffset.width += value.translation.width
                        dragOffset.height += value.translation.height
                    }
            )
    }

    private var header: some View {
        HStack {
            Label {
                Text("UI Helper", bundle: .module)
            } icon: {
                Image(systemName: "wrench.and.screwdriver.fill")
            }
            .font(.headline)
            .labelStyle(.titleAndIcon)

            Spacer()

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    isHidden = true
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.secondary)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(Color.primary.opacity(0.06)))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }

    // MARK: - Appearance
    private var appearanceSection: some View {
        DebugSection(title: "Appearance") {
            DebugRow(icon: "moon.fill", tint: .indigo, title: "Dark mode") {
                Toggle("", isOn: params.colorScheme.map(
                    toValue: { $0 == .dark },
                    fromValue: { $0 ? .dark : .light }
                ))
                .labelsHidden()
            }
            Divider()
            DebugRow(icon: "paintpalette.fill", tint: .pink, title: "Tint color") {
                EmptyView()
            }
            tintPicker
                .padding(.bottom, 8)
        }
    }

    private var tintPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                tintSwatch(color: nil)
                ForEach(Self.tintPresets, id: \.self) { color in
                    tintSwatch(color: color)
                }
            }
            .padding(.horizontal, 2)
        }
    }

    private func tintSwatch(color: Color?) -> some View {
        let isSelected = params.tint.wrappedValue == color
        return Button {
            params.tint.wrappedValue = color
            Haptic.toggleFeedback()
        } label: {
            ZStack {
                if let color {
                    Circle().fill(color)
                } else {
                    Circle()
                        .fill(Color.secondary.opacity(0.15))
                        .overlay(Image(systemName: "slash.circle").font(.caption).foregroundStyle(.secondary))
                }
            }
            .frame(width: 26, height: 26)
            .overlay(
                Circle().stroke(Color.primary.opacity(isSelected ? 0.9 : 0), lineWidth: 2)
            )
            .padding(2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Localization
    private var localizationSection: some View {
        DebugSection(title: "Localization") {
            DebugRow(icon: "globe", tint: .blue, title: "Locale") {
                Picker("", selection: params.locale.onChange({ _ in Haptic.toggleFeedback() })) {
                    ForEach(params.locales, id: \.identifier) { locale in
                        Text(locale.identifier.uppercased()).tag(locale)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
            }
        }
    }

    // MARK: - Typography
    private var typographySection: some View {
        DebugSection(title: "Typography") {
            DebugRow(icon: "textformat.size", tint: .orange, title: "Font size") {
                Text(params.textSize.wrappedValue.name)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Slider(
                value: params.textSize.map(
                    toValue: { $0.floatValue },
                    fromValue: { DynamicTypeSize(floatValue: $0) }
                ),
                in: 0 ... 1,
                step: DynamicTypeSize.stride
            )
            .padding(.bottom, 8)
        }
    }

    // MARK: - Layout
    private var layoutSection: some View {
        DebugSection(title: "Layout") {
            DebugRow(icon: "arrow.left.arrow.right", tint: .teal, title: "Right-to-left") {
                Toggle("", isOn: params.layoutDirection.map(
                    toValue: { $0 == .rightToLeft },
                    fromValue: { $0 ? .rightToLeft : .leftToRight }
                ))
                .labelsHidden()
            }
            Divider()
            DebugRow(icon: "grid", tint: .gray, title: "Pixel grid") {
                Toggle("", isOn: params.gridEnabled.onChange({ _ in Haptic.toggleFeedback() }))
                    .labelsHidden()
            }
            Divider()
            DebugRow(icon: "ruler", tint: .green, title: "Layout guides") {
                Toggle("", isOn: params.layoutGuidesEnabled.onChange({ _ in Haptic.toggleFeedback() }))
                    .labelsHidden()
            }
        }
    }

    // MARK: - Accessibility
    private var accessibilitySection: some View {
        DebugSection(title: "Accessibility") {
            DebugRow(icon: "accessibility", tint: .blue, title: "Accessibility") {
                Toggle("", isOn: params.accessibilityEnabled).labelsHidden()
            }
        }
    }

    // MARK: - Diagnostics
    private var diagnosticsSection: some View {
        DebugSection(title: "Diagnostics") {
            DebugRow(icon: "waveform.path.ecg", tint: .red, title: "Main thread monitor") {
                Toggle("", isOn: params.mainThreadMonitorEnabled.onChange({ _ in Haptic.toggleFeedback() }))
                    .labelsHidden()
            }
        }
    }

    // MARK: - Actions
    private var actionsSection: some View {
        DebugSection(title: "Actions") {
            Button {
                params.onScreenshot()
            } label: {
                DebugRow(icon: "camera.fill", tint: .purple, title: "Take a screenshot") {
                    Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
                }
            }
            .buttonStyle(.plain)
            Divider()
            Button {
                params.onReset()
            } label: {
                DebugRow(icon: "arrow.counterclockwise", tint: .red, title: "Reset all") {
                    Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    ZStack {
        LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                       startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        ModesView(
            params: ModeParameters(
                locales: [Locale(identifier: "en"), Locale(identifier: "ru"), Locale(identifier: "jp")],
                locale: Binding<Locale>(wrappedValue: Locale(identifier: "en")),
                colorScheme: Binding<ColorScheme>(wrappedValue: .light),
                textSize: Binding<DynamicTypeSize>(wrappedValue: .medium),
                layoutDirection: Binding<LayoutDirection>(wrappedValue: .leftToRight),
                tint: Binding<Color?>(wrappedValue: nil),
                accessibilityEnabled: Binding<Bool>(wrappedValue: true),
                mainThreadMonitorEnabled: Binding<Bool>(wrappedValue: false),
                gridEnabled: Binding<Bool>(wrappedValue: false),
                layoutGuidesEnabled: Binding<Bool>(wrappedValue: false),
                onReset: {},
                onScreenshot: {}
            ),
            isHidden: Binding<Bool>(wrappedValue: false)
        )
    }
}
#endif
