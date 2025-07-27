<div align="center">
  <img width="300" height="300" src="/Resources/Preview Debugger.png" alt="LogOutLoud Logo">
  <h1><b>Preview debugger</b></h1>
  <p>
    Library for debugging views in SwiftUI environment. Implement easily in previews or app directly, using connectDebugger method on your view.
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

## Features
There are features like:
 - Change from `Light` to `Dark` color cheme in one click
 - Change `font size` dynamically using simple slider
 - Switch between left-to-right and right-to-left `layout direction`
 - Turn on `accessibility` to make sure everyone could use your app
 
 ## Instalation
 - Add package dependency through Xcode using SPM
 - Use `main` branch for the latest features

 ## Usage
 - Use extension View `connectDebugger(isVisible: Binding<Bool> = .constant(true)` method on your parent view to see the instrument on screen 
 - Best to use inside #Preview canvas environment!
 
 ## Requirements
 - SwiftUI iOS 15+
 - iOS & iPadOS only (MacOS in progress)
 - `For taking screenshots`, app should has `NSPhotoLibraryAddUsageDescription` permission in plist file

