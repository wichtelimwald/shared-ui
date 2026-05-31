# Implementation Plan: Fullscreen Focus Mode + iPad CI

**Plan ID:** plan-006
**Date:** 2026-04-14
**Status:** ✅ Complete
**Scope:** shared-ui (AssistanceKit)
**Source:** AK-056, AK-082 from `docs/todo.md`; ADR-0002 Phase 2
**Estimated Effort:** M (6 steps, ~2 sessions)

---

## Goal

Implement the fullscreen/focus mode editor with a Bear-style fixed toolbar (ADR-0002
Phase 2). The fixed toolbar provides persistent formatting access (Heading, List, Quote,
Image, Undo/Redo) without needing text selection. Also add iPad simulator to CI.

---

## Steps

| # | Task | Type | Effort | Status | Notes |
|---|------|------|--------|--------|-------|
| 1 | Add iPad simulator to CI test matrix | 🤖 Code | XS | ✅ | AK-082. Add iPad destination to shared-ui CI job. |
| 2 | Create `MarkdownFixedToolbar` UIView | 🤖 Code | S | ✅ | Bear-style fixed toolbar above keyboard |
| 3 | Create `MarkdownFocusEditorView` SwiftUI wrapper | 🤖 Code | M | ✅ | AK-056. Fullscreen editor with fixed toolbar, dismiss button |
| 4 | Add Quote formatting action | 🤖 Code | XS | ✅ | `> ` line prefix, wired in fixed toolbar |
| 5 | Tests for new components | 🤖 Code | S | ✅ | 4 quote formatting tests (223 total) |
| 6 | Update backlog, ADR-0002 follow-ups, and lessons | 📝 Docs | XS | ✅ | Mark AK-056, AK-082 done |

### Step Details

#### Step 1 — iPad CI (AK-082)
- **What:** Add iPad Simulator destination to shared-ui CI test job
- **Where:** `.github/workflows/ci.yml`
- **Acceptance:** CI runs tests on both iPhone and iPad simulators

#### Step 2 — MarkdownFixedToolbar
- **What:** Create a fixed toolbar view (sits above keyboard / at bottom of editor)
- **Where:** `MarkdownEditorView.swift` (new class)
- **Details:**
  - Bear-style toolbar: Heading, List, Quote, Image, separator, Undo/Redo
  - `inputAccessoryView` on MarkdownTextView in focus mode
  - Same button style as MarkdownFloatingToolbar
  - VoiceOver labels on all buttons
  - Responds to same formatting actions on MarkdownTextView
- **Acceptance:** Fixed toolbar renders with correct buttons

#### Step 3 — MarkdownFocusEditorView (AK-056)
- **What:** SwiftUI view that presents MarkdownEditorView in fullscreen with the fixed toolbar
- **Where:** New file `MarkdownFocusEditorView.swift` or inline in MarkdownEditorView.swift
- **Details:**
  - SwiftUI wrapper using `.fullScreenCover` or standalone NavigationStack
  - Dismiss button (✕) in top-right
  - Word count display (optional)
  - Uses MarkdownEditorView with `fixedToolbarEnabled: true`
  - Floating toolbar hidden in focus mode (redundant with fixed toolbar)
- **Acceptance:** Full-screen editor works with fixed toolbar

#### Step 4 — Quote Formatting
- **What:** Add `> ` quote prefix formatting action to MarkdownTextView
- **Where:** `MarkdownTextView` formatting actions
- **Acceptance:** Quote button inserts `> ` prefix at line start

#### Step 5 — Tests
- **What:** Tests for quote formatting and fixed toolbar configuration
- **Where:** Existing test files + new if needed
- **Acceptance:** All tests pass (219 existing + new)

#### Step 6 — Docs
- **What:** Update backlog, ADR-0002, lessons
- **Where:** `docs/todo.md`, ADR-0002, `docs/lessons.md`
- **Acceptance:** Backlog reflects completion

---

## Progress Log

| Date | Session | Steps Completed | Notes |
|------|---------|-----------------|-------|
| 2026-04-14 | PR copilot/assistancekitmarkdown-update | 1, 2, 3, 4, 5, 6 | All steps done. 223 tests pass. |

---

## Completion Criteria

- [x] iPad simulator in CI
- [x] Fixed toolbar renders above keyboard in focus mode
- [x] Fullscreen focus editor view works
- [x] Quote formatting action works
- [x] All tests pass (223)
- [x] Backlog and ADR updated
