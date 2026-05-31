# ADR-0004 – Live Preview Rendering Strategy: Bear-Style

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot (based on product discovery interview)
**Source:** Interview §3.1, §3.3, §9.1 #7

---

## Context

The Markdown editor currently uses live syntax highlighting — Markdown control characters
remain visible at all times. The product discovery interview established a clear
direction: Bear-style "Live Preview" where the rendered result is always shown and
only the actively edited block briefly reveals its syntax characters.

---

## Problem Statement

How should the editor render Markdown content during editing — always showing syntax
characters, showing a split view, or using live preview that hides syntax?

---

## Options Considered

### Option 1 – Raw Markdown with Syntax Highlighting (Current)

**Description:**
All Markdown control characters remain visible. Colours and fonts indicate semantics.

**Pros:** Already implemented, simplest, familiar to Markdown-savvy users
**Cons:** Intimidating for non-technical users, visual clutter

### Option 2 – Split View (Editor + Preview)

**Description:**
Side-by-side raw editor and rendered preview (like many web-based editors).

**Pros:** Clear separation, easy to implement
**Cons:** Takes double the space, not suited for mobile, feels dated

### Option 3 – Bear-Style Live Preview ⭐

**Description:**
Content is always shown in its rendered form. Only the currently active line or block
reveals its Markdown syntax characters temporarily. Syntax characters disappear as
soon as the cursor leaves the block. Inspired by Typora's "Live Preview" model,
refined by Bear's implementation.

**Pros:**
- Calm, distraction-free writing experience
- No mode switching, no split view needed
- Non-technical users see clean output at all times
- Power users can still type Markdown syntax naturally
- Aligns perfectly with the product vision ("fun, fluid, simple")

**Cons:**
- Significantly more complex to implement (cursor tracking, block-level re-rendering)
- Must handle edge cases (multi-line blocks, nested lists, code blocks)
- Harder to debug syntax issues (characters are hidden)

---

## Decision

**Chosen:** Option 3 – Bear-Style Live Preview

**Rationale:**
The product owner was explicit: Bear-style Live Preview is the target. Split view is
explicitly rejected as redundant. The editor's primary audience is non-technical users
who should never have to see Markdown control characters unless actively editing a
block. A "Markdown Pro Mode" showing raw syntax is planned for later as an opt-in.

This is the single most impactful UX decision for the editor and defines its identity.

---

## How It Works

1. **Default state:** All content is rendered (headings are large, bold text is bold,
   lists have bullets, etc.). No Markdown syntax characters visible.
2. **Active block:** When the cursor enters a block (heading, list item, paragraph),
   that block reveals its Markdown syntax characters with syntax highlighting.
3. **Leaving a block:** Syntax characters fade/disappear instantly, replaced by the
   rendered form.
4. **Typing Markdown:** Users can type `**bold**` — as soon as they move the cursor
   away, it renders as **bold** and the `**` characters disappear.

### Pro Mode (Post-MVP)

An optional "Markdown Pro Mode" toggle that keeps syntax characters visible everywhere
(like the current implementation). This serves power users who prefer to see raw Markdown.

---

## Implementation Strategy

### Phase 1 — Foundation
- Track active block/line via cursor position
- Implement block-level rendering toggle (raw vs. rendered)
- Handle: headings, bold, italic, strikethrough, code (inline)

### Phase 2 — Complex Blocks
- Lists (ordered, unordered, nested)
- Blockquotes
- Code blocks
- Horizontal rules

### Phase 3 — Polish
- Smooth transitions between raw and rendered states
- Handle edge cases (cursor at block boundary, multi-cursor)
- Add "Pro Mode" toggle

---

## Invariants (Must Hold)

- The underlying Markdown string must never be modified by the rendering toggle
- `@Binding<String>` must always contain valid Markdown (not rendered HTML/AttributedString)
- The parsing layer is unaffected — only the presentation/rendering layer changes
- Pro Mode must be a simple boolean toggle, not a separate code path

---

## Consequences

### Positive
- Editor UX matches Bear — the gold standard for Markdown on iOS
- Non-technical users get a WYSIWYG-like experience
- Clean, distraction-free writing
- Differentiates AssistanceKit from basic Markdown editors

### Negative / Trade-offs
- Significant implementation complexity in the rendering layer
- Must redesign `MarkdownTextStorage` to support block-level render toggling
- Debugging Markdown issues becomes harder for users (syntax is hidden)

### Risks
- Performance: block-level re-rendering on every cursor move
  **Mitigation:** Only re-render the entering/leaving blocks, not the full document
- Complexity: nested blocks (list inside blockquote) are hard to render partially
  **Mitigation:** Start with flat blocks, add nested support incrementally

---

## Follow-up Actions

- [x] Create implementation concept for Live Preview rendering engine
- [x] Prototype cursor-aware block toggling in `MarkdownTextStorage`
- [x] Define "active block" detection logic in `MarkdownBlockParser`
- [x] Add backlog items for each implementation phase

---

## Supersedes / Superseded by

- **Supersedes:** N/A (current raw highlighting was default, not an ADR)
- **Superseded by:** N/A

---

## Related Code

- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownTextStorage.swift`
- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownEditorView.swift`
- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownBlockParser.swift`

---

## References

- Interview §3.1 (Rendering Style), §3.3 (Split View → No), §8.1 (Vision)
- Bear app — primary UX reference
- Typora — originator of "Live Preview" concept
