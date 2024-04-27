//
//  File.swift
//  PreviewDebugger
//
//  Created by Eugene Kovs on 27.04.2024.
//  https://github.com/kovs705
//

import SwiftUI

extension Binding {
    
    func map<T>(toValue: @escaping (Value) -> T,
                fromValue: @escaping (T) -> Value) -> Binding<T> {
        return .init(get: {
            toValue(self.wrappedValue)
        }, set: { value in
            self.wrappedValue = fromValue(value)
        })
    }
    
    func onChange(_ perform: @escaping (Value) -> Void) -> Binding<Value> {
        return .init(get: {
            self.wrappedValue
        }, set: { value in
            self.wrappedValue = value
            perform(value)
        })
    }
}
