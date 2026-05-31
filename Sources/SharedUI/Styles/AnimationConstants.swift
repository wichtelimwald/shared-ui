//
//  AnimationConstants.swift
//  AssistanceKit
//
//  Extracted from SoundCheck/AnimationConstants.swift for cross-project reuse.
//

#if canImport(SwiftUI)
import SwiftUI

/// Centralized animation durations used across apps.
///
/// Keeps hardcoded numeric literals out of view code and makes
/// timing adjustments a single-line change.
public enum AnimationDuration {
    /// Quick state transitions (edit button toggle, overlay dismiss).
    public static let fast: TimeInterval = 0.15
    /// Standard transitions (overlay appear/disappear, phase changes).
    public static let standard: TimeInterval = 0.2
}

/// Centralized spring animation presets.
public enum SpringPreset {
    /// Snappy focus spring used by CoverFlow scroll snap.
    public static let coverFlowSnap = Animation.spring(response: 0.28, dampingFraction: 0.9, blendDuration: 0.1)
    /// Smooth spring for card gap animation during drag-and-drop.
    public static let cardGap = Animation.spring(response: 0.3, dampingFraction: 0.85)
    /// Gentle spring for card transfer animation.
    public static let cardTransfer = Animation.spring(response: 0.35, dampingFraction: 0.8)
}

#endif
