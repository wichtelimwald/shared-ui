> ✅ **Completed** — 2026-04-13. All 8 steps implemented across 2 PRs.
> See progress log for session references.

# Implementation Plan: Live Preview MVP & Core Features

**Plan ID:** plan-002
**Date:** 2026-04-12
**Status:** ✅ Complete
**Scope:** shared-ui (AssistanceKit)
**Source:** Product discovery interview, ADR-0002, ADR-0004, ADR-0005, ADR-0008
**Estimated Effort:** L (5–8 sessions)

---

## Goal

Implement the core features identified in the product discovery interview to transform
the Markdown editor from a basic syntax-highlighted text editor into a Bear-style
live preview experience. After this plan, the editor will have: theme redesign (JSON
schema), tag highlighting, task list support, and the foundation for live preview
rendering.

---

## Steps

| # | Task | Type | Effort | Status | Notes |
|---|------|------|--------|--------|-------|
| 1 | Redesign MarkdownTheme with JSON schema (ADR-0005) | 🤖 Code | M | ✅ | AK-052. Light/Dark variants, typography, Codable |
| 2 | Add tag highlighting regex to MarkdownTextStorage | 🤖 Code | S | ✅ | AK-051. Pattern: `#[a-zA-Z][a-zA-Z0-9_-]*` |
| 3 | Add task list support (parser + renderer) | 🤖 Code | M | ✅ | AK-016. `- [ ]` / `- [x]` with tap-to-toggle |
| 4 | Active block detection (cursor position tracking) | 🤖 Code | M | ✅ | AK-063. Foundation for Live Preview |
| 5 | Block-level render toggling in MarkdownTextStorage | 🤖 Code | L | ✅ | AK-064. Raw vs. rendered per block |
| 6 | Add Dynamic Type support | 🤖 Code | M | ✅ | AK-015. MarkdownFontProvider, notification observer, usesDynamicType |
| 7 | Implement floating toolbar on text selection | 🤖 Code | M | ✅ | AK-014. Notion-style, 5 formatting actions |
| 8 | Add section collapse/expand in renderer | 🤖 Code | M | ✅ | AK-053. Tap heading to toggle, chevron indicator, animated |

### Step Details

#### Step 1 — Redesign MarkdownTheme
- **What:** Replace 4-colour theme with full JSON-serializable schema (ADR-0005)
- **Where:** `Sources/AssistanceKit/Markdown/MarkdownTheme.swift`
- **Acceptance:** Theme encodes/decodes to/from JSON, includes Light/Dark + typography
- **Dependencies:** None. Must update consuming apps (toogether-app) in same PR.

#### Step 2 — Tag Highlighting
- **What:** Add regex pattern for `#tag` highlighting using accent colour
- **Where:** `Sources/AssistanceKit/Markdown/MarkdownTextStorage.swift`
- **Acceptance:** Tags highlighted in accent colour, headings not misidentified
- **Dependencies:** None

#### Step 3 — Task List Support
- **What:** Parse `- [ ]` and `- [x]`, render as checkboxes, support tap-to-toggle
- **Where:** `MarkdownBlockParser.swift`, `MarkdownDocumentView.swift`, `MarkdownTextStorage.swift`
- **Acceptance:** Task lists parse, render with checkboxes, toggle on tap
- **Dependencies:** None

#### Step 4 — Active Block Detection
- **What:** Track cursor position in `MarkdownEditorView`, determine which `MarkdownBlock` is active
- **Where:** `MarkdownEditorView.swift`, `MarkdownBlockParser.swift`
- **Acceptance:** Active block identified on every cursor move, delegate/callback fires
- **Dependencies:** None

#### Step 5 — Block-Level Render Toggling
- **What:** In `MarkdownTextStorage`, render inactive blocks (hide control chars, apply formatting), show raw syntax for active block
- **Where:** `MarkdownTextStorage.swift`
- **Acceptance:** Inactive blocks look rendered, active block shows raw Markdown
- **Dependencies:** Step 4

#### Step 6 — Dynamic Type Support
- **What:** Make editor respect `UIContentSizeCategory` changes
- **Where:** `MarkdownTextStorage.swift`, `MarkdownEditorView.swift`, `MarkdownTheme.swift`
- **Acceptance:** Changing iOS font size in Settings immediately updates the editor
- **Dependencies:** Step 1 (typography in theme)

#### Step 7 — Floating Toolbar
- **What:** Show a floating toolbar when text is selected (Bold, Italic, Strikethrough, Code, Link)
- **Where:** `MarkdownEditorView.swift` (new subview)
- **Acceptance:** Toolbar appears on selection, applies formatting, dismisses correctly
- **Dependencies:** Step 4 (needs cursor/selection tracking)

#### Step 8 — Section Collapse/Expand
- **What:** In `MarkdownDocumentView`, headings can be tapped to collapse/expand their content
- **Where:** `MarkdownDocumentView.swift`, `MarkdownSectionParser.swift`
- **Acceptance:** Tapping a heading toggles its section visibility with animation
- **Dependencies:** None

---

## Progress Log

| Date | Session | Steps Completed | Notes |
|------|---------|-----------------|-------|
| 2026-04-13 | PR copilot/focus-assistance-kit-markdown | 1, 2 | MarkdownTheme redesigned per ADR-0005. Tag highlighting added per ADR-0008 Phase 1. 143 tests pass. |
| 2026-04-13 | PR copilot/focus-assistance-kit-markdown | 3 | Task list support: parser + renderer + tap-to-toggle. 9 new tests. 152 total tests pass. |
| 2026-04-13 | PR copilot/focus-assistance-kit-markdown | 4 | Active block detection: blockIndex(at:in:) + onActiveBlockChange callback in editor. 10 new tests. 162 total. |
| 2026-04-13 | PR copilot/focus-assistance-kit-markdown | 5 | Block-level render toggling: livePreviewEnabled flag, activeBlockIndex property, syntax hiding in inactive blocks. Bear-style Live Preview foundation complete. |
| 2026-04-13 | PR copilot/assistancekit-markdown-continue | 6 | Dynamic Type: MarkdownFontProvider, usesDynamicType flag in Typography, content size category notification observer. 7 new tests. 169 total. |
| 2026-04-13 | PR copilot/assistancekit-markdown-continue | 7 | Floating toolbar: MarkdownFloatingToolbar with Bold/Italic/Strikethrough/Code/Link. Shows above selection, hides on deselect. showsFloatingToolbar property. |
| 2026-04-13 | PR copilot/assistancekit-markdown-continue | 8 | Section collapse/expand: sectionsCollapsible property, collapsedSections state, chevron indicator, animated transitions, heading-level-aware collapse. Plan complete. |

---

## Completion Criteria

- [x] MarkdownTheme redesigned with JSON schema (Codable, Light/Dark, typography)
- [x] Tags highlighted in editor with accent colour
- [x] Task lists parsed, rendered, and toggleable
- [x] Active block detection working
- [x] Live Preview rendering (inactive blocks rendered, active block raw)
- [x] Dynamic Type support working
- [x] Floating toolbar on text selection
- [x] Section collapse/expand in renderer
- [x] All existing tests pass
- [x] New tests added for each feature
- [x] Backlog updated
