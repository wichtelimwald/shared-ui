//
//  BackgroundPicture.swift
//  AssistanceKit
//
//  Extracted from SoundCheck/BackgroundPicture.swift for cross-project reuse.
//

#if canImport(SwiftUI)
import SwiftUI

/// A full-bleed background image that fills the available space.
///
/// Centers the image so it stays visually balanced on wide screens.
/// The image name is configurable to allow each app to supply its own
/// background asset.
public struct BackgroundPicture: View {
    public let imageName: String
    public let size: CGSize

    /// Creates a background picture view.
    /// - Parameters:
    ///   - imageName: The name of the image asset to display.
    ///   - size: The minimum size the background should fill.
    public init(imageName: String, size: CGSize) {
        self.imageName = imageName
        self.size = size
    }

    public var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .clipped()
            .frame(minWidth: size.width, minHeight: size.height)
            .ignoresSafeArea()
    }
}

#endif
