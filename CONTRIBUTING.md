# Contributing to Preview Debugger

Thanks for your interest in improving Preview Debugger! This document explains
how to build, test, and lint the project, and what to expect when opening a pull
request.

## Prerequisites

- Xcode 15 or later (Swift 5.9+)
- macOS with the SwiftUI / iOS SDKs installed
- [SwiftLint](https://github.com/realm/SwiftLint) for linting (optional locally,
  enforced in CI)

## Building

```bash
swift build
```

## Testing

```bash
swift test
```

Please add or update tests under `Tests/` when you change behavior.

## Linting

The repository ships a `.swiftlint.yml` configuration that enables a curated set
of rules via `only_rules`. Run the linter from the repository root:

```bash
brew install swiftlint   # if you don't have it yet
swiftlint
```

CI runs SwiftLint as a separate job, so make sure it passes before pushing.

## Pull requests

- Branch off `main` and keep your branch focused on a single change.
- Make sure `swift build`, `swift test`, and `swiftlint` all pass.
- Update `CHANGELOG.md` under the `## [Unreleased]` section when your change is
  user-facing.
- Update documentation (README and the DocC catalog) when you add or change
  public API.
- Write a clear PR description explaining the motivation and the change.

By contributing, you agree that your contributions will be licensed under the
project's [MIT License](LICENSE).
