//
//  ContentSize.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.04.2024.
//  https://github.com/kovs705
//

import SwiftUI

// MARK: - Protocol
protocol DynamicSizeProtocol: Equatable {
    static var allCases: [Self] { get }
    static var cachedStride: CGFloat { get }
    static var stride: CGFloat { get }
    
    var name: String { get }
}

// MARK: - Protocol extension
extension DynamicSizeProtocol {
    
    static var cachedStride: CGFloat {
        return 1 / CGFloat(allCases.count - 1)
    }
    
    static var stride: CGFloat {
        return cachedStride
    }
    
    var floatValue: CGFloat {
        guard let index = Self.allCases.firstIndex(of: self) else {
            return 0
        }
        return CGFloat(index) * Self.cachedStride
    }
    
    static func from(float: CGFloat) -> Self {
        let index = min(max(0, Int(round(float / Self.cachedStride))), Self.allCases.count - 1)
        return Self.allCases[index]
    }
    
    init(floatValue: CGFloat) {
        self = Self.from(float: floatValue)
    }
    
}

// MARK: - ContentSizeCategory
extension ContentSizeCategory: DynamicSizeProtocol {
    
    var name: String {
        switch self {
        case .extraSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L (default)"
        case .extraLarge: return "XL"
        case .extraExtraLarge: return "XXL"
        case .extraExtraExtraLarge: return "XXXL"
        case .accessibilityMedium: return "Accessibility M"
        case .accessibilityLarge: return "Accessibility L"
        case .accessibilityExtraLarge: return "Accessibility XL"
        case .accessibilityExtraExtraLarge: return "Accessibility XXL"
        case .accessibilityExtraExtraExtraLarge: return "Accessibility XXXL"
        @unknown default: return "Unknown"
        }
    }
    
}

// MARK: - DynamicTypeSize
extension DynamicTypeSize: DynamicSizeProtocol {
    
    var name: String {
        switch self {
        case .xSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L (default)"
        case .xLarge: return "XL"
        case .xxLarge: return "XXL"
        case .xxxLarge: return "XXXL"
        case .accessibility1: return "Accessibility M"
        case .accessibility2: return "Accessibility L"
        case .accessibility3: return "Accessibility XL"
        case .accessibility4: return "Accessibility XXL"
        case .accessibility5: return "Accessibility XXXL"
        @unknown default: return "Unknown"
        }
    }
    
}
