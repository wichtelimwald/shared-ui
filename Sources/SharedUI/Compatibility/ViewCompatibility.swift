//
//  ViewCompatibility.swift
//  AssistanceKit
//
//  Backward-compatible SwiftUI modifiers for cross-project use.
//

#if canImport(SwiftUI)
import SwiftUI

extension View {
    /// Backward-compatible `onChange` modifier.
    ///
    /// Uses the iOS 17+ / macOS 14+ API when available, otherwise falls back
    /// to the iOS 14+ / macOS 11+ variant. The closure receives no parameters
    /// (fire-and-forget style).
    @ViewBuilder
    public func onChangeCompat<V: Equatable>(of value: V, _ action: @escaping () -> Void) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            self.onChange(of: value) { action() }
        } else {
            self.onChange(of: value) { _ in action() }
        }
    }
}

#endif
