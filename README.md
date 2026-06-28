<div align="center">
  <img width="300" height="300" src="/Resources/Preview Debugger.png" alt="Preview Debugger Logo">
  <h1><b>Preview Debugger</b></h1>
  <p>
    Library for debugging views in the SwiftUI environment. Implement it easily in previews or directly in your app using the <code>connectDebugger</code> method on your view.
    <br>
    <i>Compatible with iOS 15.0 and later</i>
  </p>
</div>

<div align="center">
  <a href="https://swift.org">
<!--     <img src="https://img.shields.io/badge/Swift-5.9%20%7C%206-orange.svg" alt="Swift Version"> -->
    <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift Version">
  </a>
  <a href="https://www.apple.com/ios/">
    <img src="https://img.shields.io/badge/iOS-15%2B-blue.svg" alt="iOS">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT">
  </a>
</div>

## Showcase

> **Ship pixel-perfect SwiftUI — without ever leaving the canvas.**
> One modifier. Every environment. Real time.

<table>
  <tr>
    <td width="33%" align="center"><img src="https://raw.githubusercontent.com/kovs705/ScreenshotResources/main/PreviewDebugger/control-panel.png" alt="UI Helper control panel"></td>
    <td width="33%" align="center"><img src="https://raw.githubusercontent.com/kovs705/ScreenshotResources/main/PreviewDebugger/layout-guides.png" alt="Layout guides overlay"></td>
    <td width="33%" align="center"><img src="https://raw.githubusercontent.com/kovs705/ScreenshotResources/main/PreviewDebugger/pixel-grid.png" alt="Pixel grid overlay"></td>
  </tr>
  <tr>
    <td align="center"><b>One panel, every mode.</b><br>Dark mode, tint, locale, Dynamic Type &amp; RTL — flip them all from a single floating panel.</td>
    <td align="center"><b>Nail the layout.</b><br>Safe area, rule-of-thirds &amp; dead-centre guides drawn right over your view.</td>
    <td align="center"><b>Pixel-perfect, literally.</b><br>A precision grid so every margin, gap &amp; corner lands exactly where you meant it.</td>
  </tr>
</table>

**Why you'll love it:**

- 🌗 **Light or dark, instantly** — catch contrast bugs before your users do.
- 🌐 **Speak every language** — jump between locales and proofread your UI in seconds.
- 🔠 **Big text won't break you** — drag a slider and watch your layout survive Dynamic Type.
- ↔️ **Right-to-left, done right** — mirror the whole layout with one toggle.
- 🎨 **Try on any tint** — preview your brand color live, no rebuild required.
- ♿️ **Accessible by default** — switch on accessibility and ship for everyone.
- ▦ **Precision grid** — align to the pixel with a major/minor overlay.
- 📐 **Layout guides** — safe area, thirds &amp; centre, always on tap.
- ⏱️ **Catch the hangs** — the main-thread watchdog flags UI stalls the moment they happen.
- 📸 **Snap &amp; share** — capture the canvas straight to your photo library.

## Overview

Preview Debugger is a lightweight SwiftUI overlay that lets you exercise your views under different environment conditions without leaving the canvas. Attach a single modifier to any view and a floating control panel appears, letting you flip the color scheme, change the locale, scale Dynamic Type, swap layout direction, toggle accessibility, watch the main thread for stalls, and capture a screenshot — all in real time. It is designed to live inside a `#Preview`, so you can validate light/dark, RTL, large text, and localization in seconds.

## Features

| | Feature | Description |
| :-: | :--- | :--- |
| 🌗 | Color scheme | Switch the whole app between `Light` and `Dark` color scheme in one click. |
| 🌐 | Locale | Switch between the locales supported by your app to preview localized content. |
| 🔠 | Dynamic Type | Change the `font size` dynamically with a simple slider. |
| ↔️ | Layout direction | Switch between left-to-right and right-to-left `layout direction`. |
| 🎨 | Tint color | Preview your view under different accent/tint colors on the fly. |
| ♿️ | Accessibility | Turn on `accessibility` to make sure everyone can use your app. |
| ▦ | Pixel grid | Overlay an alignment grid with major/minor lines for pixel-perfect spacing. |
| 📐 | Layout guides | Visualise the safe area, rule-of-thirds and screen centre. |
| ⏱️ | Main-thread watchdog | Monitor the main run loop and get notified when it stalls (UI hangs). |
| 📸 | Screenshot | Capture the current view and save it to the photo library. |
| ♻️ | Reset all | Restore every option back to the environment defaults in one tap. |

The control panel is **draggable** (grab the handle at the top), collapses into a floating button, and its own UI is **localized** (English & Russian included).

## Installation

Preview Debugger is distributed via the [Swift Package Manager](https://www.swift.org/package-manager/).

### Xcode

1. In Xcode, go to **File ▸ Add Package Dependencies…**
2. Paste the repository URL: `https://github.com/kovs705/PreviewDebugger`
3. Choose the `main` branch (recommended for the latest features) or a version rule.
4. Add the **PreviewDebugger** library product to your target.

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/kovs705/PreviewDebugger", branch: "main")
]
```

Then add it to your target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["PreviewDebugger"]
)
```

## Usage

Import the library and attach `.connectDebugger()` to the parent view you want to inspect. It is best used inside a `#Preview` canvas, where the overlay can drive the environment.

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

### Controlling visibility

`connectDebugger(isVisible:)` accepts a `Binding<Bool>` so you can show or hide the overlay programmatically (it defaults to always visible):

```swift
struct DebugWrapper: View {
    @State private var showDebugger = true

    var body: some View {
        ContentView()
            .connectDebugger(isVisible: $showDebugger)
    }
}
```

### Reacting to changes with `onChange`

The `onChange:` callback fires whenever the user changes one of the debugger's modes. The closure receives an `EnvironmentValues.Diff` option set describing what changed:

```swift
ContentView()
    .connectDebugger { diff in
        if diff.contains(.colorScheme) {
            print("Color scheme changed")
        }
        if diff.contains(.locale) {
            print("Locale changed")
        }
        if diff.contains(.dynamicSize) {
            print("Dynamic Type size changed")
        }
        if diff.contains(.layoutDirection) {
            print("Layout direction changed")
        }
        if diff.contains(.accessibilityEnabled) {
            print("Accessibility toggled")
        }
    }
```

### Main-thread watchdog

The watchdog observes the main run loop and posts a notification when the main thread stalls. Start and stop it wherever you need to track potential UI hangs:

```swift
Watchdog.shared.start()
// ...
Watchdog.shared.stop()
```

The stall threshold is configurable (defaults to `Watchdog.defaultThreshold`, 4 seconds):

```swift
Watchdog.shared.start(threshold: 0.25) // flag stalls longer than 250 ms
Watchdog.shared.configure(threshold: 1) // adjust on the fly, even while running
```

> **Tip:** Preview Debugger is best used inside a `#Preview`, where you can validate light/dark mode, localization, Dynamic Type, and RTL layouts without launching the app.

## Requirements

- SwiftUI, iOS 15+ and iPadOS
- macOS 13 support is in progress
- For taking screenshots, your app needs the `NSPhotoLibraryAddUsageDescription` key in its `Info.plist`

## Documentation

API documentation is available as a [DocC](https://www.swift.org/documentation/docc/) catalog in `Sources/PreviewDebugger/PreviewDebugger.docc`. Build it from Xcode via **Product ▸ Build Documentation**, or generate it from the command line with `swift package generate-documentation` (requires the [Swift-DocC Plugin](https://github.com/apple/swift-docc-plugin)). Start with the **Getting Started** article.

## License

Preview Debugger is available under the MIT license. See the [LICENSE](LICENSE) file for details.
