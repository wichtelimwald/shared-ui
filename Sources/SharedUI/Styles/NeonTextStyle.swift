//
//  NeonTextStyle.swift
//  AssistanceKit
//
//  Extracted from SoundCheck/NeonTextStyle.swift for cross-project reuse.
//

#if canImport(SwiftUI)
import SwiftUI

/// A multi-layered glow style for text and views, producing a neon light effect.
public struct NeonTextStyle: Equatable, Sendable {
    public struct Glow: Equatable, Sendable {
        public let opacity: Double
        public let radius: CGFloat

        public init(opacity: Double, radius: CGFloat) {
            self.opacity = opacity
            self.radius = radius
        }
    }

    public let color: Color
    public let innerGlow: Glow
    public let middleGlow: Glow
    public let outerGlow: Glow

    public init(color: Color, innerGlow: Glow, middleGlow: Glow, outerGlow: Glow) {
        self.color = color
        self.innerGlow = innerGlow
        self.middleGlow = middleGlow
        self.outerGlow = outerGlow
    }

    public static let hero = standard(color: .white, intensity: NeonTextConstants.heroIntensity)
    public static let title = standard(color: .white, intensity: NeonTextConstants.titleIntensity)
    public static let header = standard(color: .white, intensity: NeonTextConstants.headerIntensity)
    public static let headline = standard(color: .white, intensity: NeonTextConstants.headlineIntensity)
    public static let subheadline = standard(color: .white, intensity: NeonTextConstants.subheadlineIntensity)
    public static let subtitle = standard(
        color: .white.opacity(NeonTextConstants.subtitleOpacity),
        intensity: NeonTextConstants.subtitleIntensity
    )
    public static let muted = standard(
        color: .white.opacity(NeonTextConstants.mutedOpacity),
        intensity: NeonTextConstants.mutedIntensity
    )
    public static let mutedCaption = standard(
        color: .white.opacity(NeonTextConstants.mutedCaptionOpacity),
        intensity: NeonTextConstants.mutedCaptionIntensity
    )
    public static let artist = standard(
        color: .white.opacity(NeonTextConstants.artistOpacity),
        intensity: NeonTextConstants.artistIntensity
    )
    public static let album = standard(
        color: .white.opacity(NeonTextConstants.albumOpacity),
        intensity: NeonTextConstants.albumIntensity
    )

    public static func listTitle(_ color: Color) -> NeonTextStyle {
        standard(color: color, intensity: NeonTextConstants.listTitleIntensity)
    }

    public static func listSubtitle(_ color: Color) -> NeonTextStyle {
        standard(color: color, intensity: NeonTextConstants.listSubtitleIntensity)
    }

    public static func playerName(_ color: Color) -> NeonTextStyle {
        standard(color: color, intensity: NeonTextConstants.playerNameIntensity)
    }

    public static func editorName(_ color: Color) -> NeonTextStyle {
        standard(color: color, intensity: NeonTextConstants.editorNameIntensity)
    }

    /// Creates a standard neon style with the given colour and intensity multiplier.
    public static func standard(color: Color, intensity: Double) -> NeonTextStyle {
        NeonTextStyle(
            color: color,
            innerGlow: Glow(
                opacity: NeonTextConstants.innerGlowOpacity * intensity,
                radius: NeonTextConstants.innerGlowRadius * CGFloat(intensity)
            ),
            middleGlow: Glow(
                opacity: NeonTextConstants.middleGlowOpacity * intensity,
                radius: NeonTextConstants.middleGlowRadius * CGFloat(intensity)
            ),
            outerGlow: Glow(
                opacity: NeonTextConstants.outerGlowOpacity * intensity,
                radius: NeonTextConstants.outerGlowRadius * CGFloat(intensity)
            )
        )
    }
}

private enum NeonTextConstants {
    static let innerGlowOpacity: Double = 0.9
    static let middleGlowOpacity: Double = 0.6
    static let outerGlowOpacity: Double = 0.4

    static let innerGlowRadius: CGFloat = 6
    static let middleGlowRadius: CGFloat = 16
    static let outerGlowRadius: CGFloat = 26

    static let heroIntensity: Double = 1.1
    static let titleIntensity: Double = 1.0
    static let headerIntensity: Double = 0.9
    static let headlineIntensity: Double = 0.8
    static let subheadlineIntensity: Double = 0.7
    static let subtitleIntensity: Double = 0.6
    static let mutedIntensity: Double = 0.6
    static let mutedCaptionIntensity: Double = 0.5
    static let artistIntensity: Double = 0.9
    static let albumIntensity: Double = 0.8

    static let listTitleIntensity: Double = 0.8
    static let listSubtitleIntensity: Double = 0.5
    static let playerNameIntensity: Double = 0.8
    static let editorNameIntensity: Double = 1.0

    static let subtitleOpacity: Double = 0.75
    static let mutedOpacity: Double = 0.7
    static let mutedCaptionOpacity: Double = 0.65
    static let artistOpacity: Double = 0.9
    static let albumOpacity: Double = 0.85
}

/// ViewModifier that applies a multi-layered neon glow effect.
public struct NeonTextModifier: ViewModifier {
    public let style: NeonTextStyle

    public init(style: NeonTextStyle) {
        self.style = style
    }

    public func body(content: Content) -> some View {
        content
            .foregroundStyle(style.color)
            .shadow(color: style.color.opacity(style.innerGlow.opacity), radius: style.innerGlow.radius, x: 0, y: 0)
            .shadow(color: style.color.opacity(style.middleGlow.opacity), radius: style.middleGlow.radius, x: 0, y: 0)
            .shadow(color: style.color.opacity(style.outerGlow.opacity), radius: style.outerGlow.radius, x: 0, y: 0)
            .shadow(color: .black, radius: style.outerGlow.radius)
    }
}

extension View {
    /// Applies a neon glow effect to the view.
    public func neon(_ style: NeonTextStyle) -> some View {
        modifier(NeonTextModifier(style: style))
    }
}

#endif
