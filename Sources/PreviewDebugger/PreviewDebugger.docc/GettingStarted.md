# Getting Started

Add the debugger overlay to a view and explore it under different environment conditions.

## Overview

Preview Debugger is best used inside a `#Preview`, where the overlay can drive the
SwiftUI environment without launching the app. This article walks through adding
it, controlling its visibility, reacting to changes, and enabling the
main-thread watchdog.

## Add the overlay

Import the library and attach `.connectDebugger()` to the parent view you want to
inspect:

```swift
import SwiftUI
import PreviewDebugger

#if DEBUG
#Preview {
    ContentView()
        .connectDebugger()
}
#endif
```

A floating control panel appears over your view. Use it to switch color scheme,
locale, Dynamic Type size, layout direction, and accessibility, monitor the main
thread, or take a screenshot.

## Control visibility

``SwiftUI/View/connectDebugger(isVisible:onChange:)`` accepts a `Binding<Bool>`
so you can show or hide the overlay programmatically. It defaults to always
visible.

```swift
struct DebugWrapper: View {
    @State private var showDebugger = true

    var body: some View {
        ContentView()
            .connectDebugger(isVisible: $showDebugger)
    }
}
```

## React to changes

The `onChange` closure fires whenever a mode changes. The
``EnvironmentValues/Diff`` option set tells you what changed:

```swift
ContentView()
    .connectDebugger { diff in
        if diff.contains(.colorScheme) { /* ... */ }
        if diff.contains(.locale) { /* ... */ }
        if diff.contains(.dynamicSize) { /* ... */ }
        if diff.contains(.layoutDirection) { /* ... */ }
        if diff.contains(.accessibilityEnabled) { /* ... */ }
    }
```

## Preview localized content

The locale selector lists the locales your app supports, exposed through
``EnvironmentValues/supportedLocales`` and ``EnvironmentValues/currentLocale``.
Pick one to preview localized strings instantly.

## Monitor the main thread

Use ``Watchdog`` to detect main-thread stalls (UI hangs). Start and stop the
shared instance where you need it:

```swift
Watchdog.shared.start()
// ...
Watchdog.shared.stop()
```

When the main thread stalls, the watchdog posts
`Watchdog.Notifications.didStall` with timing details in the notification's
`userInfo`.

## Requirements

- SwiftUI, iOS 15+ and iPadOS (macOS 13 support is in progress).
- For screenshots, add the `NSPhotoLibraryAddUsageDescription` key to your
  app's `Info.plist`.
