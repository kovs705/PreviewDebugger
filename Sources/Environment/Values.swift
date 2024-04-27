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
        public static let accessibilityReduceMotionEnabled = Diff(rawValue: 1 << 5)
        public static let accessibilityInvertedColorsEnabled = Diff(rawValue: 1 << 6)
        public static let accessibilityDifferentiateWithoutColorEnabled = Diff(rawValue: 1 << 7)
        
    }
}
