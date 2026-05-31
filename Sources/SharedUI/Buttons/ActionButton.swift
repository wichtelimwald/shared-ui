//
//  ActionButton.swift
//  AssistanceKit
//
//  Extracted from SoundCheck/ActionButton.swift for cross-project reuse.
//

#if canImport(SwiftUI)
import SwiftUI

/// Reusable glassmorphic circle button.
///
/// Renders an SF Symbol inside a frosted-glass circle with a subtle border
/// and shadow. Uses ``ScaledButtonStyle`` for press feedback.
public struct ActionButton: View {
    public let systemName: String
    public let size: CGFloat
    public let action: () -> Void

    public init(systemName: String, size: CGFloat, action: @escaping () -> Void) {
        self.systemName = systemName
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .strokeBorder(.white.opacity(0.5), lineWidth: size * 0.04)
                    )
                    .shadow(color: .black.opacity(0.3), radius: size * 0.3, x: 0, y: size * 0.16)

                Image(systemName: systemName)
                    .font(.system(size: size * 0.38, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .white.opacity(0.5), radius: size * 0.08, x: 0, y: 0)
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(ScaledButtonStyle())
    }
}

#endif
