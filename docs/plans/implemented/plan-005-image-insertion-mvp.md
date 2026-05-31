# Implementation Plan: Image Insertion MVP + Backlog Hygiene

**Plan ID:** plan-005
**Date:** 2026-04-14
**Status:** ✅ Complete
**Scope:** shared-ui (AssistanceKit)
**Source:** AK-054, AK-055 from `docs/todo.md` Ready section; ADR-0007
**Estimated Effort:** M (7 steps, ~2 sessions)

---

## Goal

Enable image insertion in the Markdown editor via photo library picker and URL import,
per ADR-0007 MVP scope. Also clean up duplicate backlog entries from previous sessions.

---

## Steps

| # | Task | Type | Effort | Status | Notes |
|---|------|------|--------|--------|-------|
| 1 | Clean up duplicate backlog entries | 📝 Docs | XS | ✅ | AK-018, AK-060, AK-062, AK-065 removed from Backlog (already in Done) |
| 2 | Define `MarkdownImageInsertionDelegate` protocol | 🤖 Code | S | ✅ | Host app callback for storing picked images |
| 3 | Add "Insert Image" to context menu and floating toolbar | 🤖 Code | S | ✅ | Image button in toolbar + context menu action |
| 4 | Implement URL-based image import (AK-055) | 🤖 Code | S | ✅ | Alert with URL text field → inserts `![](url)` |
| 5 | Implement PHPicker-based photo library picker (AK-054) | 🤖 Code | M | ✅ | PHPickerViewController → delegate stores → inserts `![](local://id)` |
| 6 | Tests for image insertion logic | 🤖 Code | S | ✅ | 8 tests for syntax generation and filename helpers |
| 7 | Update backlog, ADR-0007 follow-ups, and lessons | 📝 Docs | XS | ✅ | Mark AK-054, AK-055 done |

### Step Details

#### Step 1 — Backlog Hygiene
- **What:** Remove AK-018, AK-060, AK-062 from the Backlog section (they're already in Done)
- **Where:** `shared-ui/docs/todo.md`
- **Acceptance:** No duplicate entries between Backlog and Done sections

#### Step 2 — MarkdownImageInsertionDelegate
- **What:** Define a protocol for the host app to handle image storage after PHPicker selection
- **Where:** New section in `MarkdownEditorView.swift` or new file
- **Details:**
  - `func storeImage(_ data: Data, suggestedName: String) async -> String?` → returns a URL string
  - Host app stores the image and returns the URL (e.g. `local://img-abc.jpg`)
  - Delegate is optional on `MarkdownEditorView` init
- **Acceptance:** Protocol compiles, DocC documented

#### Step 3 — Insert Image Button
- **What:** Add "Insert Image" action to context menu and floating toolbar
- **Where:** `MarkdownTextView` (context menu), `MarkdownFloatingToolbar` (toolbar button)
- **Details:**
  - SF Symbol: `photo` (for photo picker) or `photo.badge.plus`
  - Context menu action: "Insert Image" in Format submenu
  - Floating toolbar: add image button after link button
  - Shows action sheet: "Photo Library" / "From URL" / Cancel
- **Acceptance:** Image button appears in toolbar and context menu

#### Step 4 — URL-Based Image Import (AK-055)
- **What:** Present a URL input dialog, insert `![alt](url)` at cursor
- **Where:** `MarkdownEditorView.swift` (Coordinator)
- **Details:**
  - `UIAlertController` with text field for URL and optional alt text
  - Validates URL format (basic scheme check)
  - Inserts `![description](url)` at current cursor position
  - VoiceOver announcement: "Image inserted"
- **Acceptance:** URL dialog works, Markdown syntax inserted correctly

#### Step 5 — Photo Library Picker (AK-054)
- **What:** Present `PHPickerViewController`, host app stores image, insert Markdown
- **Where:** `MarkdownEditorView.swift` (Coordinator)
- **Details:**
  - Import `PhotosUI` for `PHPickerViewController`
  - Configuration: `.images` filter, selection limit 1
  - On selection: load `Data` from `NSItemProvider`
  - Call `MarkdownImageInsertionDelegate.storeImage(data, suggestedName:)`
  - Insert `![Photo](returned-url)` at cursor
  - Handle errors (user cancel, load failure)
- **Acceptance:** Photo picker works, delegate called, Markdown inserted
- **Dependencies:** Step 2 (delegate protocol)

#### Step 6 — Tests
- **What:** Unit tests for image insertion helpers
- **Where:** New `MarkdownImageInsertionTests.swift`
- **Details:**
  - Test `![alt](url)` syntax generation
  - Test URL validation helper
  - Test empty alt text / empty URL edge cases
  - Test suggested filename generation
- **Acceptance:** All new tests pass alongside existing 211

#### Step 7 — Backlog & Lessons
- **What:** Mark AK-054, AK-055 done, update ADR-0007 follow-ups
- **Where:** `docs/todo.md`, `docs/decisions/ADR-0007-image-handling-strategy.md`, `docs/lessons.md`
- **Acceptance:** Backlog and ADR reflect completion

---

## Progress Log

| Date | Session | Steps Completed | Notes |
|------|---------|-----------------|-------|
| 2026-04-14 | PR copilot/assistancekitmarkdown-update | 1, 2, 3, 4, 5, 6, 7 | All steps done. 219 tests pass. |

---

## Completion Criteria

- [x] No duplicate entries in backlog
- [x] Image insertion works via URL and photo library
- [x] Host app delegate protocol for image storage
- [x] Insert Image button in toolbar and context menu
- [x] All tests pass (219: 211 existing + 8 new)
- [x] Backlog and ADR-0007 updated
