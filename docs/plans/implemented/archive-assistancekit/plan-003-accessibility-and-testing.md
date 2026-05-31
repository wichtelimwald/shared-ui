> ✅ **Completed** — 2026-04-14. All 6 steps implemented in a single session.
> See progress log for session references.

# Implementation Plan: Accessibility & Editor Testing Sprint

**Plan ID:** plan-003
**Date:** 2026-04-14
**Status:** ✅ Complete
**Scope:** shared-ui (AssistanceKit)
**Source:** AK-017, AK-004, AK-062, AK-065, AK-060, AK-018 from `docs/todo.md`
**Estimated Effort:** L (6 steps, ~2–3 sessions)

---

## Goal

Make the Markdown editor production-ready by adding full VoiceOver accessibility,
comprehensive unit tests for formatting actions, tag interaction support, smooth
Live Preview transitions, and iPad keyboard shortcuts. After this plan the editor
meets the accessibility bar set in the product discovery interview and has the
test coverage needed for confident refactoring.

---

## Steps

| # | Task | Type | Effort | Status | Notes |
|---|------|------|--------|--------|-------|
| 1 | Add VoiceOver block navigation & Rotor actions | 🤖 Code | M | ✅ | AK-017. Heading traits, block labels, formatting announcements |
| 2 | Add unit tests for MarkdownEditorView formatting actions | 🤖 Code | M | ✅ | AK-004. 18 tests for wrap/prefix logic |
| 3 | Add tag click-to-filter callback in renderer | 🤖 Code | S | ✅ | AK-062. `onTagTapped` + `.tagLine` block type |
| 4 | Add smooth Live Preview transition animations | 🤖 Code | M | ✅ | AK-065. UIView.transition crossfade on block change |
| 5 | Define MarkdownTagProvider protocol | 🤖 Code | S | ✅ | AK-060. Protocol + MarkdownTag model + 8 tests |
| 6 | Add keyboard shortcuts for formatting (iPad) | 🤖 Code | S | ✅ | AK-018. ⌘B/I/K, ⌘⇧S/C with discoverability titles |

### Step Details

#### Step 1 — VoiceOver Block Navigation (AK-017)
- **What:** Make MarkdownDocumentView and MarkdownEditorView fully VoiceOver-accessible
- **Where:** `MarkdownDocumentView.swift`, `MarkdownEditorView.swift`
- **Details:**
  - Set `accessibilityElements` per block in MarkdownDocumentView
  - Add custom UIAccessibilityCustomRotor for heading navigation (jump between headings)
  - Announce block type + content (e.g. "Heading level 2: Location")
  - Task list items announce checked/unchecked state
  - Section collapse announces expanded/collapsed state
  - Editor announces formatting when applied ("Bold applied")
- **Acceptance:** VoiceOver can navigate block-by-block, heading rotor works, formatting announced

#### Step 2 — Formatting Action Unit Tests (AK-004)
- **What:** Platform-independent unit tests for all 7 formatting actions
- **Where:** New `MarkdownFormattingTests.swift`
- **Details:**
  - Test `wrapSelection` for bold, italic, strikethrough, inline code
  - Test `formatLink` with and without selection
  - Test `insertLinePrefix` for list items and headings
  - Test placeholder insertion when no text selected
  - Test cursor position after formatting
  - Use NSTextStorage + NSTextView stubs or test the logic directly
- **Acceptance:** All 7 formatting actions tested with positive + negative cases

#### Step 3 — Tag Click-to-Filter (AK-062)
- **What:** Add `onTagTapped` callback to MarkdownDocumentView
- **Where:** `MarkdownDocumentView.swift`, `MarkdownBlockParser.swift` (if tag extraction needed)
- **Details:**
  - Detect `#tagname` in paragraph text and make it tappable
  - Fire `onTagTapped(String)` callback with the tag name (without `#`)
  - Style tapped tags with accent colour (already done by parser)
  - Add accessibility trait `.isButton` to tag elements
- **Acceptance:** Tapping a tag in the rendered view fires the callback

#### Step 4 — Smooth Live Preview Transitions (AK-065)
- **What:** Animate syntax character show/hide with ~150ms fade
- **Where:** `MarkdownTextStorage.swift`
- **Details:**
  - When `activeBlockIndex` changes, animate the foregroundColor/font changes
  - Use `UIView.transition` or `NSTextStorage` attribute animation
  - Preserve cursor position during transition
  - Ensure performance: no frame drops on iPhone 12-era hardware
- **Acceptance:** Visible smooth fade when moving between blocks, no cursor jump

#### Step 5 — MarkdownTagProvider Protocol (AK-060)
- **What:** Define protocol for tag autocompletion data source
- **Where:** New `MarkdownTagProvider.swift`
- **Details:**
  - `protocol MarkdownTagProvider: Sendable`
  - `func availableTags(matching prefix: String) async -> [MarkdownTag]`
  - `struct MarkdownTag: Identifiable, Sendable` with name, colour, usage count
  - Wire into `MarkdownEditorView` as optional property
  - No UI yet (that's AK-061) — just the protocol + data model
- **Acceptance:** Protocol compiles, documented with DocC, simple test for a mock provider

#### Step 6 — iPad Keyboard Shortcuts (AK-018)
- **What:** Add standard keyboard shortcuts for formatting on iPad
- **Where:** `MarkdownTextView` (key commands)
- **Details:**
  - ⌘B → Bold, ⌘I → Italic, ⌘K → Link
  - ⌘⇧S → Strikethrough, ⌘⇧C → Inline code
  - Override `keyCommands` on MarkdownTextView
  - Shortcuts must work when MarkdownTextView is first responder
- **Acceptance:** All 5 shortcuts work on iPad simulator with hardware keyboard

---

## Progress Log

| Date | Session | Steps Completed | Notes |
|------|---------|-----------------|-------|
| 2026-04-14 | PR copilot/assistancekit-markdown-continue | 1, 3, 5, 6 | VoiceOver, tag click-to-filter, tag provider, keyboard shortcuts |
| 2026-04-14 | PR copilot/assistancekit-markdown-continue | 2, 4 | Formatting tests (18), smooth transitions. All 6 steps done. 198 tests. |

---

## Completion Criteria

- [x] VoiceOver navigates blocks, heading rotor works
- [x] All 7 formatting actions have unit tests
- [x] Tags are tappable in MarkdownDocumentView
- [x] Live Preview transitions are animated (~150ms)
- [x] MarkdownTagProvider protocol defined and documented
- [x] iPad keyboard shortcuts work (⌘B, ⌘I, ⌘K, ⌘⇧S, ⌘⇧C)
- [x] All existing tests pass
- [x] New tests added for each feature
- [x] Backlog updated
