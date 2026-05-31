# Implementation Plan: Editor Polish & Tag Autocompletion

**Plan ID:** plan-004
**Date:** 2026-04-14
**Status:** ✅ Complete
**Scope:** shared-ui (AssistanceKit)
**Source:** AK-050, AK-032, AK-041, AK-057, AK-061 from `docs/todo.md`
**Estimated Effort:** M (5 steps, ~1–2 sessions)

---

## Goal

Close out completed backlog items (Live Preview MVP, CODEOWNERS, CI path filter),
add Undo/Redo buttons to the floating toolbar, and implement tag autocompletion UI
with dropdown suggestions when typing `#`.

---

## Steps

| # | Task | Type | Effort | Status | Notes |
|---|------|------|--------|--------|-------|
| 1 | Close out AK-050, AK-032, AK-041 in backlog | 📝 Docs | XS | ✅ | Mark as done, update concept acceptance criteria |
| 2 | Add Undo/Redo buttons to floating toolbar | 🤖 Code | S | ✅ | AK-057. Undo/Redo via undoManager + toolbar buttons |
| 3 | Implement tag autocompletion UI | 🤖 Code | M | ✅ | AK-061. Dropdown on `#` + characters, queries MarkdownTagProvider |
| 4 | Add tests for new features | 🤖 Code | S | ✅ | 13 tests for tag prefix extraction logic |
| 5 | Update backlog and lessons | 📝 Docs | XS | ✅ | Mark AK-057, AK-061 done |

### Step Details

#### Step 1 — Close Out Completed Items
- **What:** Mark AK-050 (Live Preview MVP), AK-032 (CODEOWNERS), AK-041 (CI) as done
- **Where:** `docs/todo.md`, `docs/concepts/bear-style-live-preview-ux.md`
- **Acceptance:** Items moved to Done section with completion dates

#### Step 2 — Undo/Redo Buttons (AK-057)
- **What:** Add Undo and Redo buttons to `MarkdownFloatingToolbar`
- **Where:** `MarkdownEditorView.swift` (MarkdownFloatingToolbar)
- **Details:**
  - Add `arrow.uturn.backward` (Undo) and `arrow.uturn.forward` (Redo) SF Symbols
  - Wire to `textView.undoManager?.undo()` / `textView.undoManager?.redo()`
  - Disable buttons when undo/redo not available
  - Add VoiceOver labels
  - Add ⌘Z / ⌘⇧Z keyboard shortcuts
- **Acceptance:** Undo/Redo buttons visible in toolbar, functional, accessible

#### Step 3 — Tag Autocompletion UI (AK-061)
- **What:** Show dropdown suggestions when user types `#` followed by characters
- **Where:** New `MarkdownTagCompletionView` + integration in `MarkdownEditorView`
- **Details:**
  - Detect `#` prefix at cursor position using text analysis
  - Query `MarkdownTagProvider.availableTags(matching:)` asynchronously
  - Show compact dropdown below cursor with matching tags
  - Tap tag to complete (replace `#prefix` with `#fullTagName`)
  - Dismiss on selection, Escape, or cursor move away
  - Style with theme colours (tag accent)
- **Acceptance:** Typing `#` shows dropdown, selecting inserts full tag, accessible

#### Step 4 — Tests
- **What:** Unit tests for undo/redo state and tag completion matching
- **Where:** `MarkdownFormattingTests.swift`, new `MarkdownTagCompletionTests.swift`
- **Details:**
  - Test tag prefix extraction from cursor position
  - Test tag insertion (replacing partial prefix)
  - Test edge cases: empty prefix, no matches, cursor at start of `#`
- **Acceptance:** All new tests pass alongside existing 198 tests

#### Step 5 — Backlog & Lessons
- **What:** Update todo.md with completed items, add lessons
- **Where:** `docs/todo.md`, `docs/lessons.md`
- **Acceptance:** Backlog reflects current state

---

## Progress Log

| Date | Session | Steps Completed | Notes |
|------|---------|-----------------|-------|
| 2026-04-14 | PR copilot/assistancekitmarkdown-update | 1, 2, 3, 4, 5 | All steps done. 211 tests pass. |

---

## Completion Criteria

- [x] AK-050, AK-032, AK-041 marked done in backlog
- [x] Undo/Redo buttons work in floating toolbar
- [x] Tag autocompletion dropdown appears on `#` typing
- [x] All tests pass (211: 198 existing + 13 new)
- [x] Backlog updated
