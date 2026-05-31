// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SharedUI",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]
        ),
    ],
    dependencies: [
        // Zero external dependencies — see docs/decisions/ADR-0010-spinoff-from-monorepo.md
    ],
    targets: [
        // Single library target. Subdirectories Backgrounds/, Buttons/,
        // Compatibility/, Styles/ are flat-aggregated into the SharedUI
        // module so the umbrella-style `import SharedUI` continues to
        // surface every symbol (just like the old `import AssistanceKit`).
        .target(
            name: "SharedUI",
            dependencies: [],
            path: "Sources/SharedUI",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "SharedUITests",
            dependencies: ["SharedUI"],
            path: "Tests/SharedUITests"
        ),
    ]
)
