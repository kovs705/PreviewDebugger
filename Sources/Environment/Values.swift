//
//  File.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.04.2024.
//  https://github.com/kovs705
//

import SwiftUI

/// a collection of environment values, propagated through a view hierarchy
public extension EnvironmentValues {
    struct Diff: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let locale = Diff(rawValue: 1 << 0)
        public static let colorScheme = Diff(rawValue: 1 << 1)
        public static let sizeCategory = Diff(rawValue: 1 << 2)
        public static let layoutDirection = Diff(rawValue: 1 << 3)
        
        public static let accessibilityEnabled = Diff(rawValue: 1 << 4)
//        public static let accessibilityReduceMotionEnabled = Diff(rawValue: 1 << 5)
//        public static let accessibilityInvertedColorsEnabled = Diff(rawValue: 1 << 6)
//        public static let accessibilityDifferentiateWithoutColorEnabled = Diff(rawValue: 1 << 7)
//        public static let reducedTransparencyEnabled = Diff(rawValue: 1 << 8)
        
    }
}

public extension EnvironmentValues {
    static var supportedLocales: [Locale] = {
        let bundle = Bundle.main
        return bundle.localizations.map { Locale(identifier: $0) }
    }()
    
    static var currentLocale: Locale? {
        let current = Locale.current
        let fullId = current.identifier
        let shortId = String(fullId.prefix(2))
        return supportedLocales.locale(withId: fullId) ??
            supportedLocales.locale(withId: shortId)
    }
}

private extension Array where Element == Locale {
    func locale(withId identifier: String) -> Element? {
        first(where: { $0.identifier.hasPrefix(identifier) })
    }
}
