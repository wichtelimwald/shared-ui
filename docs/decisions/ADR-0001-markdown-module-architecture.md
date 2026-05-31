# ADR-0001 – Markdown Module: Three-Layer Architecture

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot

---

## Context

AssistanceKit's Markdown module is the primary "internal product" of the shared-ui
package. It provides a live Markdown editor, a read-only document renderer, and
inline Markdown text rendering — used across multiple apps in the mono-repo.

The module was extracted from toogether-app's Markdown implementation and generalised
for cross-project reuse. As it evolves into a standalone reusable product, its
architecture must support independent development, testing, and extension without
coupling to any specific consuming app.

---

## Problem Statement

How should the Markdown module be architecturally organised to support independent
evolution as a reusable internal product while maintaining zero external dependencies?

---

## Options Considered

### Option 1 – Three-Layer Architecture (Parsing → Rendering → Presentation)

**Description:**
Separate the module into three layers with strict downward-only dependencies:
- **Parsing Layer:** Pure logic types (`MarkdownBlockParser`, `MarkdownSectionParser`)
  with no UI or framework dependencies. Fully testable on any platform.
- **Rendering Layer:** `NSTextStorage`-based syntax highlighting (`MarkdownTextStorage`)
  and theme configuration (`MarkdownTheme`). Depends on UIKit text system.
- **Presentation Layer:** SwiftUI views (`MarkdownEditorView`, `MarkdownDocumentView`,
  `MarkdownText`). Depends on SwiftUI and UIKit.

**Pros:**
- Parsing logic is independently testable on Linux and macOS
- Each layer can evolve independently
- Clear boundary for adding macOS/visionOS support later
- Aligns with Clean Architecture principles used across the mono-repo

**Cons:**
- Slightly more files than a flat structure
- Requires discipline to maintain layer boundaries

---

### Option 2 – Flat Module Structure

**Description:**
All Markdown types in a single directory with no explicit layering.

**Pros:**
- Simpler initial setup
- Fewer directories

**Cons:**
- Harder to identify what depends on what
- Testing pure logic requires importing the full module
- No clear extension points

---

## Decision Matrix

| Criterion | Weight | Option 1 (Layered) | Option 2 (Flat) |
|-----------|--------|:---:|:---:|
| Simplicity | 3 | 4 (12) | 5 (15) |
| Maintainability | 3 | 5 (15) | 3 (9) |
| Extendability | 2 | 5 (10) | 2 (4) |
| Reusability | 2 | 5 (10) | 3 (6) |
| Performance | 2 | 4 (8) | 4 (8) |
| Consistency | 2 | 5 (10) | 3 (6) |
| Human Readability | 2 | 4 (8) | 4 (8) |
| *Testability* | *2* | 5 (10) | 3 (6) |
| **Weighted Total** | | **83** | **62** |

---

## Decision

**Chosen:** Option 1 – Three-Layer Architecture

**Rationale:**
The layered approach provides clear boundaries that support independent testing,
future platform expansion, and clean API design. The parsing layer is already pure
logic (no UI deps), making this a formalisation of the existing structure rather
than a refactor.

---

## Invariants (Must Hold)

- Parsing layer types (`MarkdownBlockParser`, `MarkdownSectionParser`, `MarkdownBlock`,
  `MarkdownSection`) must have **zero** UIKit/SwiftUI imports.
- All parsing layer types must be `Sendable`.
- `MarkdownTheme` uses hex strings, not `UIColor`/`NSColor`, for platform independence.
- Presentation layer types are guarded with `#if canImport(SwiftUI)`.

---

## How to Change Safely

- To add a new Markdown feature: determine which layer it belongs to. Parser
  improvements go in the parsing layer. New views go in the presentation layer.
- To split into separate SPM targets: create `AssistanceMarkdownCore` (parsing)
  and `AssistanceMarkdown` (rendering + presentation) targets. Update imports in
  consuming projects.
- To add macOS support: parsing layer works already. Add `#if os(macOS)` variants
  for NSTextStorage/NSTextView in the rendering/presentation layers.

---

## Consequences

### Positive
- Pure parsing logic is testable without simulator
- New apps get a complete Markdown solution via `import AssistanceKit`
- macOS/visionOS support can be added incrementally
- Clear contribution guidelines for each layer

### Negative / Trade-offs
- Developers must understand which layer to modify
- Single SPM target means all layers are imported together (acceptable for now)

### Risks
- Over-engineering: splitting into separate SPM targets too early
  **Mitigation:** Keep single `AssistanceKit` target. Split only when needed.

---

## Follow-up Actions

- [x] Document architecture in `shared-ui/copilot-instructions.md`
- [x] Create concept document for Markdown editor
- [ ] Add DocC documentation to all public Markdown APIs
- [ ] Add tests for MarkdownTextStorage syntax highlighting
- [ ] Add tests for MarkdownEditorView formatting actions

---

## Supersedes / Superseded by

- **Supersedes:** N/A
- **Superseded by:** N/A

---

## Related Code

- `shared-ui/Sources/AssistanceKit/Markdown/` (all 7 files)
- `shared-ui/Tests/AssistanceKitTests/MarkdownBlockParserTests.swift`
- `shared-ui/Tests/AssistanceKitTests/MarkdownSectionParserTests.swift`
- `docs/decisions/ADR-0006-shared-swift-package.md` (parent decision)

---

## References

- ADR-0006: Shared Swift Package for Cross-Project UI Components
- `shared-ui/docs/concepts/markdown-editor-architecture.md`
