//
//  ScaledButtonStyle.swift
//  AssistanceKit
//
//  Extracted from SoundCheck/ScaledButtonStyle.swift for cross-project reuse.
//

#if canImport(SwiftUI)
import SwiftUI

/// A button style that scales down slightly when pressed, providing tactile feedback.
public struct ScaledButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#endif
