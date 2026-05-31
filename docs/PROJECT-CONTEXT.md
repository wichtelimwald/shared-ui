# AssistanceKit – Project-Specific Copilot Instructions

## Purpose

AssistanceKit is the **shared Swift Package** for the `assistance` mono-repo. It
provides reusable UI components and design tokens used across multiple iOS app
projects. Its primary product focus is a **powerful, easy-to-use Markdown editor**
that can be embedded in any app as a drop-in component.

## Project Type

Swift Package (SPM) — no Xcode project file. Build and test with:

```bash
cd shared-ui
swift build
swift test
```

## Architecture

### Package Structure

```
shared-ui/
├── Package.swift                       # Swift 5.9+, iOS 17+, macOS 14+
├── Sources/AssistanceKit/
│   ├── Markdown/                       # ⭐ Primary product: Markdown editor
│   │   ├── MarkdownEditorView.swift    # Live editor (UIKit + SwiftUI bridge)
│   │   ├── MarkdownDocumentView.swift  # Read-only renderer (block-level)
│   │   ├── MarkdownText.swift          # Inline Markdown renderer
│   │   ├── MarkdownBlockParser.swift   # Block-level parser (pure logic)
│   │   ├── MarkdownSectionParser.swift # Section splitter/joiner (pure logic)
│   │   ├── MarkdownTextStorage.swift   # NSTextStorage syntax highlighting
│   │   └── MarkdownTheme.swift         # Colour configuration (Codable)
│   ├── CoverFlow/                      # 3D card carousel
│   ├── GlassOverlay/                   # Full-screen glass overlay
│   ├── Buttons/                        # ActionButton, ScaledButtonStyle
│   ├── Backgrounds/                    # BackgroundPicture
│   ├── Styles/                         # NeonTextStyle, AnimationConstants
│   └── Compatibility/                  # ViewCompatibility helpers
└── Tests/AssistanceKitTests/
    ├── MarkdownBlockParserTests.swift  # 42 test cases
    ├── MarkdownSectionParserTests.swift # 25 test cases
    └── CoverFlowKernelTests.swift
```

### Markdown Module Layers

The Markdown module follows a clean three-layer architecture:

```
┌─────────────────────────────────────────────┐
│  Presentation Layer (SwiftUI / UIKit)       │
│  MarkdownEditorView · MarkdownDocumentView  │
│  MarkdownText                               │
├─────────────────────────────────────────────┤
│  Rendering Layer (NSTextStorage)            │
│  MarkdownTextStorage · MarkdownTheme        │
├─────────────────────────────────────────────┤
│  Parsing Layer (Pure Logic, no UI deps)     │
│  MarkdownBlockParser · MarkdownSectionParser│
└─────────────────────────────────────────────┘
```

Dependencies flow downward only. Parsing layer has zero framework dependencies.

## Key Invariants (from ADR-0006)

- **Zero external dependencies** — no third-party packages
- **All public APIs must have DocC documentation**
- **Breaking API changes must update all consuming projects in same PR**
- **Must compile independently via `swift build`**

## Consuming Projects

| Project | Usage |
|---------|-------|
| toogether-app | Full Markdown editor + document renderer (primary consumer) |
| studienmap-app | Has own Markdown implementation (unification candidate) |
| mosQuit-app | Simplified Markdown text (local implementation) |

## Coding Guidelines

- Follow all rules from `.github/copilot-instructions.md` (global)
- `@MainActor` for all UIKit-touching code (MarkdownEditorView, MarkdownTextStorage)
- `nonisolated` for pure parsing types (MarkdownBlockParser, MarkdownSectionParser)
- `Sendable` conformance for all value types (MarkdownTheme, MarkdownBlock, MarkdownSection)
- `#if canImport(SwiftUI)` guards on all SwiftUI view types
- Hex colour strings (not UIColor/NSColor) in MarkdownTheme for platform independence

## Documentation

- ADRs: `shared-ui/docs/decisions/`
- Concepts: `shared-ui/docs/concepts/`
- Plans: `shared-ui/docs/plans/`
- Backlog: `shared-ui/docs/todo.md`
- Lessons: `shared-ui/docs/lessons.md`

## Relevant Agents

Use global engineering agents (code-review, architecture-review, security-audit, tester).
When working on Markdown: check `shared-ui/docs/concepts/markdown-editor-architecture.md`
for the component design and `shared-ui/docs/concepts/markdown-editor-interview.md` for
product requirements.
