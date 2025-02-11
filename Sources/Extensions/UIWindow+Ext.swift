//
//  UIWindow+Ext.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 11.02.2025.
//  https://github.com/kovs705
//

#if !os(macOS)
import UIKit

extension UIWindow {
    
    /// Makes a `screenshot` of the current window
    /// - Returns: screenshot image
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
    }
}
#endif
