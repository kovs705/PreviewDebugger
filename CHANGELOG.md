# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Redesigned, **draggable** control panel: sectioned layout (Appearance,
  Localization, Typography, Layout, Accessibility, Diagnostics, Actions) with
  icon-led rows, material background and a floating collapsed button.
- **Tint color** tool to preview a view under different accent colors.
- **Pixel grid** overlay with major/minor lines and a centre cross-hair.
- **Layout guides** overlay visualising the safe area, rule-of-thirds and centre.
- **Reset all** action to restore every option to its environment default.
- Configurable watchdog stall threshold via `Watchdog.shared.start(threshold:)`
  and `Watchdog.shared.configure(threshold:)`; rolling stall history and count on
  the monitor view model.
- Main-thread watchdog monitor (`Watchdog.shared`) that observes the main run
  loop and posts a notification when the main thread stalls, with an in-overlay
  monitor card to toggle it.
- A `WatchdogSupport` Objective-C target backing the run-loop observer.
- macOS build support so the package compiles on macOS 13.
- Localized debugger UI (English & Russian) and locale selection from the overlay.
- Screenshot capture from the overlay.
- A comprehensive unit-test suite (60 tests), GitHub Actions CI, a DocC
  documentation catalog, `LICENSE`, `CONTRIBUTING.md` and this changelog.

### Changed

- Color scheme changes are now applied to the whole application rather than only
  the active screen.
- Replaced `print` logging in the watchdog with `os.Logger`.
