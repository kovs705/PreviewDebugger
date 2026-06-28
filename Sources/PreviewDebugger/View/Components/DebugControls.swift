//
//  DebugControls.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.06.2026.
//  https://github.com/kovs705
//

import SwiftUI

/// A titled group of debug controls rendered as a soft card.
struct DebugSection<Content: View>: View {

    let title: LocalizedStringKey
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title, bundle: .module)
                .font(.caption2.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.primary.opacity(0.04))
            )
        }
    }
}

/// A single debug control row: a tinted SF Symbol badge, a title and a trailing control.
struct DebugRow<Trailing: View>: View {

    let icon: String
    let tint: Color
    let title: LocalizedStringKey
    @ViewBuilder var trailing: Trailing

    init(
        icon: String,
        tint: Color = .accentColor,
        title: LocalizedStringKey,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.icon = icon
        self.tint = tint
        self.title = title
        self.trailing = trailing()
    }

    var body: some View {
        HStack(spacing: 12) {
            IconBadge(systemName: icon, tint: tint)
            Text(title, bundle: .module)
                .font(.subheadline)
                .lineLimit(1)
            Spacer(minLength: 8)
            trailing
        }
        .padding(.vertical, 8)
    }
}

/// A rounded, tinted icon container used to give each row a clear visual anchor.
struct IconBadge: View {

    let systemName: String
    var tint: Color = .accentColor

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(tint)
            .frame(width: 26, height: 26)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(tint.opacity(0.16))
            )
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 16) {
        DebugSection(title: "Appearance") {
            DebugRow(icon: "moon.fill", tint: .indigo, title: "Dark mode") {
                Toggle("", isOn: .constant(true)).labelsHidden()
            }
            Divider()
            DebugRow(icon: "paintpalette.fill", tint: .pink, title: "Tint") {
                Circle().fill(.pink).frame(width: 20, height: 20)
            }
        }
    }
    .padding()
}
#endif
