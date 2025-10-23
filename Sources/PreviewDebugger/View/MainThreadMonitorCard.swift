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
            } else {
                collapsedContent
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: status.event?.timestamp)
    }

    private var collapsedContent: some View {
        Text("Main Thread Monitor")
            .font(.caption)
            .foregroundStyle(Color.primary.opacity(0.7))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.secondary.opacity(0.12))
            )
            .overlay(
                Capsule()
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 0.5)
            )
    }

    private func expandedContent(for event: MainThreadMonitorViewModel.StallEvent) -> some View {
        let severity = MainThreadMonitorViewModel.Severity(duration: event.duration)

        return Label {
            Text(message(for: event))
                .font(.callout)
        } icon: {
            Image(systemName: "exclamationmark.triangle.fill")
        }
        .symbolRenderingMode(.palette)
        .foregroundStyle(borderColor(for: severity), Color.primary)
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(backgroundColor(for: severity))
        )
        .overlay(
            Capsule()
                .stroke(borderColor(for: severity), lineWidth: 1)
        )
        .accessibilityLabel("Main thread stall: \(message(for: event))")
    }

    private func message(for event: MainThreadMonitorViewModel.StallEvent) -> String {
        let durationString = String(format: "%.1f", event.duration)
        let timeString = Self.timeFormatter.string(from: event.timestamp)
        return "Main thread blocked \(durationString) s at \(timeString)"
    }

    private func backgroundColor(for severity: MainThreadMonitorViewModel.Severity) -> Color {
        switch severity {
        case .green:
            return Color.green.opacity(0.2)
        case .yellow:
            return Color.yellow.opacity(0.25)
        case .orange:
            return Color.orange.opacity(0.25)
        case .red:
            return Color.red.opacity(0.3)
        }
    }

    private func borderColor(for severity: MainThreadMonitorViewModel.Severity) -> Color {
        switch severity {
        case .green:
            return Color.green.opacity(0.6)
        case .yellow:
            return Color.yellow.opacity(0.7)
        case .orange:
            return Color.orange.opacity(0.8)
        case .red:
            return Color.red.opacity(0.9)
        }
    }
}

#if DEBUG
struct MainThreadMonitorCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MainThreadMonitorCard(status: .healthy)
            MainThreadMonitorCard(status: .stalled(.init(duration: 0.4, timestamp: Date())))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
