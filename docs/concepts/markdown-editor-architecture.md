# Concept: Markdown Editor – Component Architecture

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot
**Related ADR:** ADR-0001 (Markdown Module Architecture)

---

## Goal

Define the internal architecture of AssistanceKit's Markdown module as a reusable
"internal product" — a powerful, easy-to-use Markdown editor that any app in the
mono-repo can embed with minimal configuration.

---

## Motivation

Multiple apps need Markdown editing and rendering:

| App | Current State | Needs |
|-----|---------------|-------|
| toogether-app | Uses AssistanceKit Markdown (primary consumer) | Full editor + renderer |
| studienmap-app | Own MarkdownParser + LiveMarkdownView | Could migrate to shared |
| mosQuit-app | AdaptiveMarkdownText (local, simple) | Inline rendering only |
| Future apps | — | Drop-in Markdown support |

A unified, well-documented Markdown module eliminates duplication, ensures consistent
UX, and reduces onboarding time for new projects.

---

## Scope

### In Scope
- Architecture documentation for existing 7 Markdown files
- Layer boundaries and dependency rules
- Extension points for consuming apps
- Theme customization model
- Image provider protocol for app-specific content

### Out of Scope
- macOS/visionOS platform variants (future)
- Toolbar-based formatting UI (future — currently uses context menu)
- Collaborative editing / real-time sync
- Markdown-to-HTML export

---

## Proposed Approach

### Three-Layer Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                            │
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌───────────────┐  │
│  │MarkdownEditorView│  │MarkdownDocument- │  │ MarkdownText  │  │
│  │ (UIViewRepr.)    │  │     View         │  │ (inline)      │  │
│  │                  │  │ (SwiftUI)        │  │               │  │
│  │ • Live editing   │  │ • Block render   │  │ • Bold/italic │  │
│  │ • Context menu   │  │ • Images         │  │ • Code/links  │  │
│  │ • Format actions │  │ • Lists/quotes   │  │               │  │
│  └───────┬──────────┘  └───────┬──────────┘  └───────────────┘  │
│          │                     │                                  │
├──────────┼─────────────────────┼─────────────────────────────────┤
│          │        RENDERING LAYER                                │
│          ▼                     │                                  │
│  ┌──────────────────┐         │  ┌────────────────┐              │
│  │MarkdownText-     │         │  │ MarkdownTheme  │              │
│  │   Storage         │         │  │                │              │
│  │ (NSTextStorage)  │         │  │ • Hex colours  │              │
│  │                  │         │  │ • Codable      │              │
│  │ • 14 regex       │         │  │ • Sendable     │              │
│  │   patterns       │         │  │                │              │
│  │ • Live highlight │         │  │ • defaultLight │              │
│  └──────────────────┘         │  │ • defaultDark  │              │
│                               │  └────────────────┘              │
├───────────────────────────────┼──────────────────────────────────┤
│                    PARSING LAYER                                 │
│                               ▼                                  │
│  ┌──────────────────┐  ┌──────────────────┐                      │
│  │MarkdownBlock-    │  │MarkdownSection-  │                      │
│  │   Parser         │  │   Parser         │                      │
│  │                  │  │                  │                      │
│  │ • H1–H3         │  │ • Split at ##    │                      │
│  │ • Lists (nested) │  │ • Join sections  │                      │
│  │ • Blockquotes   │  │ • Roundtrip-safe │                      │
│  │ • Images        │  │                  │                      │
│  │ • Rules         │  │                  │                      │
│  │ • Tag detection │  │                  │                      │
│  └──────────────────┘  └──────────────────┘                      │
│                                                                  │
│  Types: MarkdownBlock (enum), MarkdownSection (struct)           │
│  All Sendable, Equatable, zero framework dependencies            │
└──────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Dependencies |
|-----------|---------------|-------------|
| `MarkdownBlockParser` | Markdown → `[MarkdownBlock]` structured blocks | None (pure logic) |
| `MarkdownSectionParser` | Split/join at `## ` headings for section editing | None (pure logic) |
| `MarkdownBlock` | Enum of block types (h1, h2, h3, paragraph, list, etc.) | None |
| `MarkdownSection` | Heading + body pair with stable UUID | Foundation (UUID) |
| `MarkdownTheme` | Colour configuration using hex strings | Foundation (Codable) |
| `MarkdownTextStorage` | `NSTextStorage` with regex-based syntax highlighting | UIKit |
| `MarkdownEditorView` | Live editor (UITextView + SwiftUI bridge) | UIKit, SwiftUI |
| `MarkdownDocumentView` | Read-only Obsidian-style block renderer | SwiftUI |
| `MarkdownText` | Inline Markdown text (bold, italic, code, links) | SwiftUI |

### Extension Points for Consuming Apps

1. **Custom themes:** Pass `MarkdownTheme` with app-specific accent/code colours
2. **Custom image providers:** Implement `MarkdownImageDataProvider` for app-specific
   URL schemes (e.g., `local://` for cached images)
3. **Section-based editing:** Use `MarkdownSectionParser` to split documents into
   independently editable sections
4. **Selective import:** Use only the parsing layer for Markdown processing without UI

### Concurrency Model

| Type | Isolation | Reason |
|------|-----------|--------|
| `MarkdownBlockParser` | `nonisolated` (enum) | Pure logic, no mutable state |
| `MarkdownSectionParser` | `nonisolated` (enum) | Pure logic, no mutable state |
| `MarkdownBlock` | `Sendable` | Value type (enum) |
| `MarkdownSection` | `Sendable` | Value type (struct) |
| `MarkdownTheme` | `Sendable` | Value type (struct) |
| `MarkdownTextStorage` | `@MainActor` | UIKit text system (must be main thread) |
| `MarkdownEditorView` | `@MainActor` | UIKit view bridge |
| `MarkdownDocumentView` | implicit `@MainActor` | SwiftUI View |
| `MarkdownText` | implicit `@MainActor` | SwiftUI View |

---

## Open Questions

| # | Question | Owner | Due Date | Status |
|---|----------|-------|----------|--------|
| 1 | Should we add a SwiftUI-native toolbar for formatting (in addition to context menu)? | Product | — | ✅ Answered — ADR-0002: Three-layer approach (Context Menu + Floating Toolbar + Fixed Toolbar in fullscreen) |
| 2 | Should studienmap-app migrate to AssistanceKit Markdown? | Team | — | ✅ Answered — ADR-0006: Yes, migration planned. Delta requirements documented. |
| 3 | Should we support tables in the block parser? | Product | — | ✅ Answered — Not for MVP. Added to backlog for later version. |
| 4 | Should MarkdownEditorView support macOS via NSTextView? | Team | — | ✅ Answered — ADR-0003: macOS post-MVP. iPhone+iPad first. |
| 5 | Should we add Markdown export (to HTML, PDF, AttributedString)? | Product | — | Deferred — Not mentioned as priority in interview. Remains in backlog (AK-020). |

---

## Acceptance Criteria

- [x] Architecture documented with layer diagram
- [x] Component responsibilities defined
- [x] Extension points documented
- [x] Concurrency model defined
- [x] All public APIs have DocC documentation
- [x] Architecture validated via product discovery interview

---

## Impact Assessment

| Area | Impact | Notes |
|------|--------|-------|
| Performance | None | Architecture formalises existing structure |
| Security | None | No new attack surface |
| Backwards Compatibility | None | No API changes |
| Test Coverage | New tests needed | MarkdownTextStorage, MarkdownEditorView |
| Documentation | Update needed | DocC for all public APIs |

---

## References

- ADR-0001: Markdown Module Architecture (`shared-ui/docs/decisions/`)
- ADR-0006: Shared Swift Package (`docs/decisions/`)
- `shared-ui/docs/concepts/markdown-editor-interview.md` (product discovery)
