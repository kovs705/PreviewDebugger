# ``PreviewDebugger``

A SwiftUI debugging overlay for exercising your views under different environment conditions, right from the preview canvas.

@Metadata {
    @DisplayName("Preview Debugger")
}

## Overview

Preview Debugger attaches a floating control panel to any SwiftUI view. From that
panel you can flip the color scheme, change the locale, scale Dynamic Type, swap
the layout direction, toggle accessibility, monitor the main thread for stalls,
and capture a screenshot — all in real time. It is designed to live inside a
`#Preview`, so you can validate light/dark, RTL, large text, and localization in
seconds.

Attach the debugger with a single modifier:

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

To react to changes, pass an `onChange` closure. It receives an
``EnvironmentValues/Diff`` describing what the user changed:

```swift
ContentView()
    .connectDebugger { diff in
        if diff.contains(.colorScheme) {
            print("Color scheme changed")
        }
    }
```

## Topics

### Essentials

- <doc:GettingStarted>

### Connecting the debugger

- ``SwiftUI/View/connectDebugger(isVisible:onChange:)``

### Describing changes

- ``EnvironmentValues/Diff``

### Locales

- ``EnvironmentValues/supportedLocales``
- ``EnvironmentValues/currentLocale``

### Main-thread monitoring

- ``Watchdog``
