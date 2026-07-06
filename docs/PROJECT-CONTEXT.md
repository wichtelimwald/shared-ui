# SharedUI — Project Context

## Purpose

SharedUI is the **foundational Swift package** for the `wichtelimwald` ecosystem. It
ships four reusable UI modules — Backgrounds, Buttons, Compatibility, Styles — that
are shared across multiple iOS/macOS apps and serve as a dependency for sibling
packages (e.g. `wichtelimwald/glass-overlay`).

## Repo

`wichtelimwald/shared-ui` — spun off from `wichtelimwald/assistance` mono-repo.
See `docs/decisions/ADR-0010-spinoff-from-monorepo.md` for migration context.

## Project Type

Swift Package (SPM) — no Xcode project file. Build and test with:

```bash
swift build
swift test
```

## Modules

| Module | Description |
|--------|-------------|
| `Backgrounds` | `BackgroundPicture` — full-bleed background image view |
| `Buttons` | `ActionButton`, `ScaledButtonStyle` — glassmorphic circle button and press-feedback style |
| `Compatibility` | `onChangeCompat` — backward-compatible SwiftUI `onChange` modifier |
| `Styles` | `NeonTextStyle`, `NeonTextModifier`, `AnimationDuration`, `SpringPreset` — neon glow text style and animation constants |

All four modules compile into a **single `SharedUI` product target**. Consumers add one SPM
dependency and write `import SharedUI`.

## Package Structure

```
shared-ui/
├── Package.swift                       # Swift 5.9+, iOS 17+, macOS 14+
├── Sources/SharedUI/
│   ├── Backgrounds/
│   │   └── BackgroundPicture.swift
│   ├── Buttons/
│   │   ├── ActionButton.swift
│   │   └── ScaledButtonStyle.swift
│   ├── Compatibility/
│   │   └── ViewCompatibility.swift
│   └── Styles/
│       ├── AnimationConstants.swift
│       └── NeonTextStyle.swift
└── Tests/SharedUITests/
    └── SharedUITests.swift
```

## Key Invariants

- **Zero external dependencies** — no third-party packages
- **All public APIs must have DocC documentation**
- **All SwiftUI code is guarded with `#if canImport(SwiftUI)`** — the package builds on Linux
- **Breaking API changes require an ADR + explicit user approval + major-version bump**
  (see `.github/instructions/execution-rules.instructions.md` §9)

## Ecosystem Position

| Repo | Product | Depends on SharedUI |
|------|---------|---------------------|
| `wichtelimwald/shared-ui` *(this repo)* | `SharedUI` | — |
| `wichtelimwald/glass-overlay` | `GlassOverlay` | ✅ |
| `wichtelimwald/coverflow` | `CoverFlow` | — |
| `wichtelimwald/markdown-ui` | `MarkdownUI` | — |

Consumers pin `upToNextMajorVersion` from `v0.1.0`. Import line: `import SharedUI`
(replaces the former `import AssistanceKit`).

## Consuming Apps

| App | Status |
|-----|--------|
| `wichtelimwald/org-spirits` | First remote consumer; migrated in ADR-0010 |
| Remaining mono-repo apps | Still using local `../shared-ui` path reference (migration tracked in backlog) |

## Coding Guidelines

- Follow all rules from `.github/copilot-instructions.md`
- `#if canImport(SwiftUI)` guards on all SwiftUI view types (cross-platform builds)
- `Sendable` conformance for all value types
- `@MainActor` for any UIKit-touching code (none currently in this package)

## Documentation

- ADRs: `docs/decisions/`
- Concepts: `docs/concepts/`
- Plans: `docs/plans/`
- Backlog: `docs/todo.md`
- Lessons: `docs/lessons.md`

## Relevant Agents

Use global engineering agents (code-review, architecture-review, security-audit, tester).
