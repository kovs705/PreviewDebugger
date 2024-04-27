//
//  Locale.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.04.2024.
//  https://github.com/kovs705
//


import Foundation

private extension Array where Element == Locale {
    func locale(withId identifier: String) -> Element? {
        first(where: { $0.identifier.hasPrefix(identifier) })
    }
}
