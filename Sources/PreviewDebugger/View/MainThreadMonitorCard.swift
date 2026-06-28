//
//  MainThreadMonitorCard.swift
//  PreviewDebugger
//
//  Created by ChatGPT on 21.11.2025.
//

import SwiftUI

struct MainThreadMonitorCard: View {

    let status: MainThreadMonitorViewModel.Status

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    var body: some View {
        Group {
            if let event = status.event {
                expandedContent(for: event)
                    .transition(.scale(scale: 0.92).combined(with: .opacity))
            } else {
                collapsedContent
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.32, dampingFraction: 0.78), value: status.event?.timestamp)
        .animation(.easeInOut(duration: 0.2), value: status.event == nil)
    }

    // MARK: - Collapsed

    private var collapsedContent: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.green)
                .frame(width: 7, height: 7)
            Text("Main Thread")
                .font(.caption.weight(.medium))
                .foregroundStyle(Color.primary.opacity(0.75))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(
            Capsule(style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.primary.opacity(0.08), lineWidth: 0.5)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Main thread healthy")
    }

    // MARK: - Expanded

    private func expandedContent(for event: MainThreadMonitorViewModel.StallEvent) -> some View {
        let severity = MainThreadMonitorViewModel.Severity(duration: event.duration)

        return HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.callout.weight(.semibold))
                .foregroundStyle(accentColor(for: severity))

            VStack(alignment: .leading, spacing: 1) {
                Text("Main thread blocked")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.primary)
                Text(detail(for: event))
                    .font(.caption2)
                    .foregroundStyle(Color.primary.opacity(0.6))
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule(style: .continuous)
                .fill(.thinMaterial)
        )
        .background(
            Capsule(style: .continuous)
                .fill(backgroundTint(for: severity))
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(accentColor(for: severity).opacity(0.85), lineWidth: 1)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Main thread stall: \(message(for: event))")
    }

    // MARK: - Text

    private func detail(for event: MainThreadMonitorViewModel.StallEvent) -> String {
        let durationString = String(format: "%.1f", event.duration)
        let timeString = Self.timeFormatter.string(from: event.timestamp)
        return "\(durationString)s · \(timeString)"
    }

    private func message(for event: MainThreadMonitorViewModel.StallEvent) -> String {
        let durationString = String(format: "%.1f", event.duration)
        let timeString = Self.timeFormatter.string(from: event.timestamp)
        return "Main thread blocked \(durationString) s at \(timeString)"
    }

    // MARK: - Severity colors

    private func accentColor(for severity: MainThreadMonitorViewModel.Severity) -> Color {
        switch severity {
        case .green:
            return .green
        case .yellow:
            return .yellow
        case .orange:
            return .orange
        case .red:
            return .red
        }
    }

    private func backgroundTint(for severity: MainThreadMonitorViewModel.Severity) -> Color {
        switch severity {
        case .green:
            return Color.green.opacity(0.18)
        case .yellow:
            return Color.yellow.opacity(0.22)
        case .orange:
            return Color.orange.opacity(0.22)
        case .red:
            return Color.red.opacity(0.26)
        }
    }
}

#if DEBUG
struct MainThreadMonitorCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MainThreadMonitorCard(status: .healthy)
            MainThreadMonitorCard(status: .stalled(.init(duration: 0.4, timestamp: Date())))
            MainThreadMonitorCard(status: .stalled(.init(duration: 1.2, timestamp: Date())))
            MainThreadMonitorCard(status: .stalled(.init(duration: 2.5, timestamp: Date())))
            MainThreadMonitorCard(status: .stalled(.init(duration: 4.2, timestamp: Date())))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
