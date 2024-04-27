//
//  ContentSize.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.04.2024.
//  https://github.com/kovs705
//

import SwiftUI

extension ContentSizeCategory {
    
    static var stride: CGFloat {
        return 1 / CGFloat(allCases.count - 1)
    }
    
    var floatValue: CGFloat {
        let index = CGFloat(ContentSizeCategory.allCases.firstIndex(of: self) ?? 0)
        return index * ContentSizeCategory.stride
    }
    
    init(floatValue: CGFloat) {
        let index = Int(round(floatValue / ContentSizeCategory.stride))
        self = ContentSizeCategory.allCases[index]
    }
    
    var name: String {
        switch self {
        case .extraSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
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
