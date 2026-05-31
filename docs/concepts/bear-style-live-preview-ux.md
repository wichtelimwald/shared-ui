# Concept: Bear-Style Live Preview UX

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot (based on product discovery interview)
**Related ADR:** ADR-0004 (Live Preview Rendering Strategy)

---

## Goal

Define the UX model for Bear-style Live Preview — the core editing experience of the
AssistanceKit Markdown Editor. This is the single most defining UX decision: the editor
always shows rendered content, and only the actively edited block reveals its Markdown
syntax characters.

---

## Motivation

The product discovery interview established clear UX principles:

- **Primary audience:** Non-technical users unfamiliar with Markdown syntax
- **Core principle:** WYSIWYG by default — control characters disappear immediately
  after input. Users always see the rendered result.
- **UX goal:** "It must be fun — meaning: fluid, reliable, and simple enough for
  non-experts to use without thinking."
- **References:** Bear (fluidity, iOS nativity), Obsidian (ecosystem thinking),
  Duolingo (playfulness, humour)

---

## UX Model

### States

The editor has two visual states per block:

| State | When | What User Sees |
|-------|------|---------------|
| **Rendered** | Cursor is NOT in this block | Clean rendered output (bold text, large headings, bullet lists, etc.) |
| **Editing** | Cursor IS in this block | Markdown syntax characters visible with syntax highlighting |

### Transition Rules

1. **Entering a block:** When the cursor moves into a block, syntax characters
   appear (animated fade-in, ~150ms)
2. **Leaving a block:** Syntax characters disappear, replaced by rendered form
   (animated fade-out, ~150ms)
3. **New content:** When typing Markdown syntax (e.g., `**bold**`), characters
   render immediately upon leaving the block
4. **Multi-block selection:** All selected blocks show syntax characters

### Block Types and Their Rendered Forms

| Block Type | Editing (Raw) | Rendered |
|------------|---------------|----------|
| Heading H1 | `# Title` | Large bold text (headingScale × bodyFontSize) |
| Heading H2 | `## Subtitle` | Medium bold text |
| Heading H3 | `### Section` | Small bold text |
| Bold | `**bold**` | **bold** (no asterisks) |
| Italic | `*italic*` | *italic* (no asterisks) |
| Strikethrough | `~~strike~~` | ~~strike~~ (no tildes) |
| Inline code | `` `code` `` | `code` with background (no backticks) |
| Link | `[text](url)` | Coloured text (underlined, no URL visible) |
| Unordered list | `- Item` | • Item (bullet replaces dash) |
| Ordered list | `1. Item` | 1. Item (styled number) |
| Blockquote | `> Quote` | Indented with left border (no `>` visible) |
| Task list | `- [ ] Todo` | ☐ Todo (checkbox replaces `- [ ]`) |
| Task done | `- [x] Done` | ☑ Done (checked box, strikethrough) |
| Horizontal rule | `---` | Horizontal line (full width) |
| Image | `![alt](url)` | Inline image (no syntax visible) |
| Tag | `#tagname` | Coloured tag text (accent colour) |

### Interactive Elements (Renderer)

In the rendered state, certain elements are interactive:
- **Links:** Tap to open in browser
- **Images:** Tap to enlarge (full-screen preview)
- **Task lists:** Tap checkbox to toggle
- **Sections:** Tap heading to collapse/expand (MVP — important for toogether-app)
- **Tags:** Tap to trigger filter/search callback

### Fullscreen / Focus Mode

- Activated when user taps into the editor (optional, host app configurable)
- Shows fixed toolbar at bottom (Bear-style)
- Editor takes full screen, immersive experience
- Deactivated by tapping "Done" or swiping down

---

## Implementation Approach

### Phase 1 — Active Block Detection

The `MarkdownBlockParser` determines block boundaries. As the cursor moves:
1. Determine which block the cursor is in (by line range)
2. Mark that block as "active" (show raw Markdown)
3. Mark the previously active block as "inactive" (render)

### Phase 2 — Block-Level Rendering

`MarkdownTextStorage` must support two modes per text range:
- **Raw mode:** Current syntax highlighting (Markdown characters visible)
- **Rendered mode:** Characters hidden/replaced, styled output shown

This requires changes to `processEditing()` and `applyMarkdownHighlighting()`:
- Track the active block's character range
- Apply "raw" highlighting to the active block
- Apply "rendered" styling (hide control chars, apply formatting) to all other blocks

### Phase 3 — Transitions

- Use `NSTextStorage` attribute animations for smooth transitions
- Fade syntax characters in/out over ~150ms
- Ensure cursor position is preserved during transitions

### Phase 4 — Pro Mode

An optional toggle that keeps all blocks in "raw" mode (current behaviour).
Useful for Markdown-savvy users who prefer seeing all syntax.

```swift
public enum MarkdownDisplayMode: Sendable {
    case livePreview  // Bear-style (default)
    case rawMarkdown  // Pro mode (all syntax visible)
}
```

---

## Scope

### In Scope (MVP)
- Active block detection based on cursor position
- Rendered state for: headings, bold, italic, strikethrough, inline code, links
- Editing state with full syntax highlighting
- Smooth transitions between states

### In Scope (Post-MVP)
- Rendered state for: lists, blockquotes, code blocks, images, task lists
- Section collapse/expand
- Pro Mode toggle
- Fullscreen/focus mode with fixed toolbar

### Out of Scope
- Collaborative editing / real-time sync
- Split view (explicitly rejected in interview)
- Markdown export (separate feature)

---

## Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | How to handle multi-line blocks (code blocks, nested lists) in the transition? | Engineering | Open |
| 2 | Should the transition animation be configurable by theme? | Design | Open |
| 3 | How to preserve cursor position when control characters appear/disappear? | Engineering | Open |

---

## Acceptance Criteria

- [x] Active block shows raw Markdown syntax
- [x] Inactive blocks show rendered output
- [x] Transitions are smooth (~150ms)
- [x] All inline formatting types render correctly
- [x] Cursor position is preserved during transitions
- [x] Performance: no visible lag when moving between blocks

---

## References

- ADR-0004: Live Preview Rendering Strategy
- Interview §3.1 (Rendering Style), §3.3 (No Split View), §8.1 (Vision)
- Bear app (primary UX reference)
- Typora (originator of Live Preview concept)
