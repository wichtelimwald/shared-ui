# ADR-0002 – Formatting UI Strategy: Three-Layer Approach

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot (based on product discovery interview)
**Source:** Interview §2.2, §9.1 #1

---

## Context

The AssistanceKit Markdown Editor currently uses the iOS context menu (long-press →
"Format") for all formatting actions (bold, italic, etc.). As the editor evolves toward
a Bear-style live preview experience, the formatting UI needs to scale across different
interaction contexts — text selection, focused editing, and fullscreen mode.

The product discovery interview identified Bear as the primary UX reference and defined
a three-layer approach for formatting interaction.

---

## Problem Statement

How should users apply formatting (bold, italic, headings, etc.) in the Markdown editor
across different contexts (selection, inline editing, fullscreen)?

---

## Options Considered

### Option 1 – Context Menu Only (Current)

**Description:**
Retain the iOS long-press context menu as the sole formatting mechanism.

**Pros:**
- Already implemented and working
- Familiar iOS interaction pattern
- No additional UI elements

**Cons:**
- Requires long-press → navigate menu hierarchy (slow)
- Not discoverable for new users
- No formatting access without text selection
- Doesn't align with Bear/Notion-style UX expectations

---

### Option 2 – Fixed Keyboard Toolbar Only

**Description:**
Replace context menu with a fixed toolbar above the keyboard (like Bear, iA Writer).

**Pros:**
- Always visible during editing
- Fast access to common formatting
- Works well with iPad hardware keyboards (shortcuts)

**Cons:**
- Takes vertical space in embedded editor contexts
- May feel heavy for short notes
- Loses the context-menu familiarity

---

### Option 3 – Three-Layer Approach ⭐

**Description:**
A progressive enhancement model with three complementary formatting surfaces:

1. **iOS Context Menu** — retained as fallback / power-user option
2. **Floating Toolbar on text selection** — appears contextually when text is selected
   (Notion-style). Shows only relevant formatting options for the selection.
3. **Fixed Toolbar** — only in fullscreen/focus mode. Provides persistent access to
   all formatting options (Bear-style).

**Pros:**
- Best UX per context: lightweight when embedded, full-featured in fullscreen
- Progressive disclosure: basic users see floating toolbar, power users use context menu
- Aligns with Bear (primary) and Notion (secondary) UX references
- Context menu becomes redundant gracefully if Live Preview is fully achieved
- Keyboard shortcuts on iPad fit naturally into fixed toolbar layer

**Cons:**
- Higher implementation complexity (three UI surfaces)
- Must ensure the three layers don't conflict (e.g., selection triggers both floating
  toolbar and context menu)
- More testing surface

---

## Decision Matrix

| Criterion | Weight | Option 1 (Context Menu) | Option 2 (Fixed Toolbar) | Option 3 (Three-Layer) |
|-----------|--------|:---:|:---:|:---:|
| Discoverability | 3 | 2 (6) | 4 (12) | 5 (15) |
| UX Quality | 3 | 3 (9) | 4 (12) | 5 (15) |
| Simplicity | 2 | 5 (10) | 4 (8) | 3 (6) |
| Context Adaptability | 3 | 2 (6) | 3 (9) | 5 (15) |
| Consistency (with Bear) | 2 | 2 (4) | 4 (8) | 5 (10) |
| iPad/Keyboard Support | 2 | 2 (4) | 5 (10) | 5 (10) |
| Implementation Effort | 1 | 5 (5) | 3 (3) | 2 (2) |
| **Weighted Total** | | **44** | **62** | **73** |

---

## Decision

**Chosen:** Option 3 – Three-Layer Approach

**Rationale:**
The product owner explicitly chose this approach in the interview. It provides the best
UX across all editor contexts (embedded, focused, fullscreen) and aligns with Bear
(primary UX reference) and Notion (secondary). Implementation can be incremental:
floating toolbar first, fixed toolbar in fullscreen mode later.

---

## Implementation Strategy

### MVP (Phase 1)
- Retain existing context menu as-is
- ~~Add floating toolbar on text selection~~ (removed — collided with iOS context menu)
- Add fixed toolbar above keyboard for persistent formatting access (Bear-style)

### Phase 2
- ~~Add fixed toolbar in fullscreen mode~~ (fixed toolbar is now always present)
- In focus mode, the fixed toolbar includes a "Done" button
- Add iPad keyboard shortcuts (Cmd+B, Cmd+I, etc.)

### Phase 3 (if Bear-style Live Preview is fully achieved)
- Evaluate removing context menu for basic formatting (keep for advanced actions)
- Floating toolbar remains available as opt-in via `showsFloatingToolbar: true`

---

## Invariants (Must Hold)

- All three layers must apply the same Markdown syntax transformations
- Formatting actions must go through a single `MarkdownFormattingAction` API
- Floating toolbar must not appear in read-only `MarkdownDocumentView`
- Fixed toolbar is always shown as `inputAccessoryView` during editing
- In focus mode, the fixed toolbar includes a "Done" button

---

## Consequences

### Positive
- Consistent with modern note-taking app UX (Bear, Notion)
- Progressive enhancement allows incremental delivery
- Each layer can be enabled/disabled per host app context

### Negative / Trade-offs
- Three UI surfaces to maintain and test
- Potential for interaction conflicts between layers
- Higher initial implementation cost

### Risks
- Floating toolbar may conflict with iOS text selection handles
  **Mitigation:** Use `UITextInteraction` delegate to coordinate
- Context menu may feel redundant once floating toolbar works well
  **Mitigation:** Plan graceful deprecation in Phase 3

---

## Follow-up Actions

- [x] Implement floating toolbar on text selection (AK-014)
- [x] Add iPad keyboard shortcuts (AK-018)
- [x] Implement fullscreen mode with fixed toolbar (AK-056)
- [ ] Evaluate context menu deprecation after Live Preview ships

---

## Supersedes / Superseded by

- **Supersedes:** N/A (context menu was default, not an ADR)
- **Superseded by:** N/A

---

## Related Code

- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownEditorView.swift`
- AK-010, AK-014, AK-018 in backlog

---

## References

- Interview §2.2 (Formatting Toolbar), §9.1 #1
- Bear app (primary UX reference)
- Notion (floating toolbar reference)
