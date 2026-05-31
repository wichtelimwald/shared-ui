# ADR-0008 – Tag System Architecture

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot (based on product discovery interview)
**Source:** Interview §2.6, §9.1 #8

---

## Context

The `MarkdownBlockParser` already detects tag lines (`#tag1 #tag2`) and distinguishes
them from headings. The product discovery interview confirmed that tags should be a
fully-supported feature with colour highlighting, autocompletion, and clickable
behaviour.

---

## Problem Statement

How should the tag system be architectured to provide consistent highlighting,
autocompletion, and click-to-filter behaviour across all consuming apps?

---

## Options Considered

### Option 1 – Parser-Only (Current)

Tags are detected and skipped by the parser. No editor or renderer support.

**Pros:** Already works, no effort
**Cons:** Tags are just plain text visually, no interactivity

### Option 2 – Full Tag System ⭐

Three-part implementation:
1. **Highlighting:** Tags appear in accent colour in both editor and renderer
2. **Autocompletion:** Typing `#` triggers a suggestion popup with known tags
3. **Clickable:** Tapping a tag in the renderer triggers a filter/search action

**Pros:** Rich tag experience, consistent across apps
**Cons:** Higher complexity, autocompletion requires tag registry

### Option 3 – Highlighting Only

Tags are coloured but not interactive.

**Pros:** Simple, visual benefit
**Cons:** Misses the most valuable features (autocompletion, click-to-filter)

---

## Decision

**Chosen:** Option 2 – Full Tag System

**Rationale:**
The product owner wants full tag support including highlighting, autocompletion, and
click-to-filter. The parser already has a foundation — the implementation builds on
existing detection logic.

---

## Architecture

### Tag Detection (Parsing Layer)

- `MarkdownBlockParser` already detects tag lines via `isTagLine()`
- Pattern: `#word` (no space after `#`, distinguishes from `# heading`)
- Tags can appear inline in paragraphs or as dedicated tag lines

### Tag Highlighting (Rendering Layer)

- `MarkdownTextStorage` adds colour highlighting for `#tagname` patterns
- Uses `MarkdownTheme.accentColor` for tag text
- Tags are styled differently from headings (no size change, only colour)

### Tag Autocompletion (Presentation Layer)

- Host app provides a list of known tags via a protocol:
  ```swift
  public protocol MarkdownTagProvider {
      func availableTags() -> [String]
  }
  ```
- Editor shows a dropdown/popup when user types `#` followed by characters
- Matching is case-insensitive prefix match
- Selection inserts the full tag

### Tag Interaction (Presentation Layer)

- In `MarkdownDocumentView` (renderer): tags are tappable
- Tap triggers a callback:
  ```swift
  public var onTagTapped: ((String) -> Void)?
  ```
- Host app decides what happens (filter, search, navigate)

---

## Implementation Strategy

### Phase 1 — Highlighting (MVP)
- Add `#tag` regex pattern to `MarkdownTextStorage`
- Use `MarkdownTheme.accentColor` for highlighting
- Distinguish from headings (no space after `#`)

### Phase 2 — Autocompletion
- Define `MarkdownTagProvider` protocol
- Implement dropdown UI in `MarkdownEditorView`
- Support keyboard navigation of suggestions

### Phase 3 — Click-to-Filter
- Make tags tappable in `MarkdownDocumentView`
- Add `onTagTapped` callback
- Host apps wire to their search/filter UI

---

## Invariants (Must Hold)

- Tag detection must never misidentify headings (`# Heading` has a space after `#`)
- `MarkdownTagProvider` is optional — editor works without it (no autocompletion)
- Tag interaction callbacks are optional — renderer works without them
- Tags are stored as plain text in Markdown (`#tag`) — no special encoding

---

## Consequences

### Positive
- Rich tag experience without leaving the editor
- Consistent tag UX across all consuming apps
- Building on existing parser foundation (low risk)

### Negative / Trade-offs
- Autocompletion requires host app to provide tag list
- Dropdown UI adds complexity to `MarkdownEditorView`
- Tag styling may conflict with custom themes

### Risks
- `#word` pattern may match content that's not intended as a tag (e.g., `#1 ranked`)
  **Mitigation:** Require tags to start with a letter: `#[a-zA-Z]\w+`

---

## Follow-up Actions

- [x] Add tag highlighting regex to `MarkdownTextStorage`
- [ ] Define `MarkdownTagProvider` protocol
- [ ] Implement autocompletion UI
- [ ] Add `onTagTapped` callback to `MarkdownDocumentView`
- [ ] Add tag-related tests

---

## Supersedes / Superseded by

- **Supersedes:** N/A
- **Superseded by:** N/A

---

## Related Code

- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownBlockParser.swift` (tag detection)
- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownTextStorage.swift` (highlighting)
- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownEditorView.swift` (autocompletion)
- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownDocumentView.swift` (click-to-filter)

---

## References

- Interview §2.6 (Hashtags/Tags)
- Interview §9.1 #8 (Tag System Architecture ADR)
