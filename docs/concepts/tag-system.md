# Concept: Tag System

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot (based on product discovery interview)
**Related ADR:** ADR-0008 (Tag System Architecture)

---

## Goal

Define the tag system for the AssistanceKit Markdown Editor: highlighting, autocompletion,
and click-to-filter behaviour that works consistently across all consuming apps.

---

## Motivation

Tags are a cross-cutting feature used in multiple apps:
- **toogether-app:** Location tags for filtering and search
- **studienmap-app:** Topic/category tags for phases and appointments
- **General:** Content organisation without hierarchical structure

The parser already detects tag lines (`#tag1 #tag2`) and distinguishes them from headings.
The interview confirmed full tag support is desired: highlighting, autocompletion, and
clickable behaviour.

---

## Proposed Approach

### Tag Syntax

Tags follow the pattern `#tagname` where:
- `#` is immediately followed by a letter (distinguishes from `# heading`)
- Tag name is alphanumeric plus hyphens and underscores: `[a-zA-Z][a-zA-Z0-9_-]*`
- Tags can appear:
  - On dedicated tag lines: `#tag1 #tag2 #tag3`
  - Inline in paragraphs: `This is about #swift and #markdown`

### Feature 1: Highlighting

Tags appear in accent colour in both editor and renderer:

| Context | Appearance |
|---------|-----------|
| Editor (raw) | `#tagname` in `MarkdownTheme.accentColor`, no size change |
| Editor (Live Preview, inactive block) | `tagname` in accent colour, `#` hidden |
| Renderer (`MarkdownDocumentView`) | `tagname` in accent colour, pill-shaped background (optional) |

### Feature 2: Autocompletion

When the user types `#` in the editor:
1. A dropdown/popup appears after 1+ characters
2. Shows tags from the host app's tag registry (via `MarkdownTagProvider`)
3. Matches are case-insensitive prefix matches
4. User selects via tap or keyboard navigation
5. Full tag is inserted including `#` prefix

**Protocol:**
```swift
public protocol MarkdownTagProvider: AnyObject {
    func availableTags() -> [String]
}
```

**Behaviour:**
- If no `MarkdownTagProvider` is set, autocompletion is disabled
- Dropdown dismisses on: selection, Escape, tap outside, cursor moves past `#`
- Maximum 5–7 suggestions shown (scrollable if more)

### Feature 3: Click-to-Filter

In `MarkdownDocumentView` (read-only renderer), tags are tappable:
1. User taps a tag
2. `onTagTapped` callback fires with the tag name (without `#`)
3. Host app decides action (filter list, open search, navigate)

**Callback:**
```swift
public var onTagTapped: ((String) -> Void)?
```

---

## Implementation Strategy

### Phase 1 — Highlighting (MVP)
- Add `#tag` regex to `MarkdownTextStorage`: `#[a-zA-Z][a-zA-Z0-9_-]*`
- Apply `MarkdownTheme.accentColor` to matches
- Ensure no false positives with headings (`# heading` has space)
- Add tests for tag highlighting (positive and negative cases)

### Phase 2 — Autocompletion
- Define `MarkdownTagProvider` protocol in AssistanceKit
- Add dropdown UI component to `MarkdownEditorView`
- Track cursor position to detect `#` trigger
- Implement prefix matching and keyboard navigation
- Host app provides tag list (e.g., from SwiftData query)

### Phase 3 — Click-to-Filter
- Make tags tappable in `MarkdownDocumentView` using `TapGesture`
- Add `onTagTapped` callback
- Optional: pill-shaped background for tappable tags

---

## Scope

### In Scope
- Tag syntax definition and parsing rules
- Editor highlighting
- Autocompletion UI and protocol
- Renderer tap interaction and callback

### Out of Scope
- Tag management UI (create, rename, delete tags) — host app responsibility
- Tag colours per tag (all tags use accent colour) — future enhancement
- Tag hierarchies or namespaces — future enhancement

---

## Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | Should tags support Unicode characters beyond ASCII? (e.g., `#Übung`) | Engineering | Open |
| 2 | Should tag autocompletion show recently used tags first? | Product | Open |
| 3 | Should tags have individual colours (not just accent)? | Design | Deferred |

---

## Acceptance Criteria

- [ ] Tags are highlighted in accent colour in the editor
- [ ] Tag regex does not match headings
- [ ] Autocompletion appears when typing `#` + characters
- [ ] `MarkdownTagProvider` protocol defined and documented
- [ ] Tags are tappable in `MarkdownDocumentView`
- [ ] `onTagTapped` callback fires correctly

---

## References

- ADR-0008: Tag System Architecture
- Interview §2.6 (Hashtags/Tags)
- `MarkdownBlockParser.isTagLine()` — existing detection logic
