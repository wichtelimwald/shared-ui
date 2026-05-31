# Implementation Plan: Markdown Export, Pro Mode, ContentProvenance

**Plan ID:** plan-007
**Date:** 2026-04-14
**Status:** ✅ Complete
**Scope:** shared-ui (AssistanceKit)
**Source:** AK-020, AK-066, AK-070 from `docs/todo.md`
**Estimated Effort:** M (7 steps, ~2 sessions)

---

## Goal

Add Markdown export pipeline (HTML + NSAttributedString), a Pro Mode toggle for raw
Markdown display, and the ContentProvenance model as foundation for ADR-0009
(suggested content).

---

## Steps

| # | Task | Type | Effort | Status | Notes |
|---|------|------|--------|--------|-------|
| 1 | Create `MarkdownExporter` — HTML export from `[MarkdownBlock]` | 🤖 Code | S | ✅ | AK-020. Pure Foundation, no UIKit |
| 2 | Add `NSAttributedString` export to `MarkdownExporter` | 🤖 Code | S | ✅ | AK-020. UIKit-gated |
| 3 | Tests for HTML and AttributedString export | 🤖 Code | S | ✅ | AK-020. 22 tests in MarkdownExporterTests |
| 4 | Add `proModeEnabled` to editor + storage toggle | 🤖 Code | S | ✅ | AK-066. Overrides live preview |
| 5 | Define `ContentProvenance` model + protocol | 🤖 Code | S | ✅ | AK-070 + AK-071. Per ADR-0009 |
| 6 | Tests for Pro Mode and ContentProvenance | 🤖 Code | S | ✅ | 13 tests in ContentProvenanceTests |
| 7 | Update backlog, lessons; archive plan-007 | 📝 Docs | XS | ✅ | AK-020, AK-066, AK-070, AK-071 done |

### Step Details

#### Step 1 — HTML Export
- **What:** `MarkdownExporter.html(from:)` converts `[MarkdownBlock]` → HTML string
- **Where:** New file `MarkdownExporter.swift`
- **Details:** Maps each block type to HTML elements. Inline Markdown (bold, italic,
  code, links) converted via regex. Pure Foundation — testable on Linux.
- **Acceptance:** `MarkdownExporter.html(from:)` produces valid HTML

#### Step 2 — NSAttributedString Export
- **What:** `MarkdownExporter.attributedString(from:theme:)` → `NSAttributedString`
- **Where:** Same file, `#if canImport(UIKit)` gated
- **Details:** Uses theme colours for headings, quotes, code. Inline Markdown via
  `NSAttributedString(markdown:)` or manual styling.
- **Acceptance:** Styled attributed string matches theme

#### Step 3 — Export Tests
- **What:** Tests for all block types → HTML and → AttributedString
- **Where:** New `MarkdownExporterTests.swift`
- **Acceptance:** 20+ tests covering headings, lists, tasks, quotes, images, inline

#### Step 4 — Pro Mode Toggle
- **What:** `proModeEnabled` property on `MarkdownEditorView`, pushes to storage
- **Where:** `MarkdownEditorView.swift`, `MarkdownTextStorage.swift`
- **Details:** When `true`, live preview is disabled and raw syntax always shown.
  Overrides `livePreviewEnabled`. Opt-in per ADR-0004 discussion.
- **Acceptance:** Toggle switches between live preview and raw syntax

#### Step 5 — ContentProvenance Model
- **What:** `ContentProvenance` struct + `MarkdownProvenanceProvider` protocol
- **Where:** New file `ContentProvenance.swift`
- **Details:** Per ADR-0009. Model: sourceURL, sourceName, importDate, isAccepted.
  Protocol: async method to query provenance for a text range.
- **Acceptance:** Types compile, DocC documented, Sendable

#### Step 6 — Pro Mode & Provenance Tests
- **What:** Tests for provenance model Codable roundtrip, pro mode flag behaviour
- **Acceptance:** All new tests pass

#### Step 7 — Docs
- **What:** Update backlog, lessons, archive plan
- **Acceptance:** Backlog reflects completion

---

## Progress Log

| Date | Session | Steps Completed | Notes |
|------|---------|-----------------|-------|
| 2026-04-15 | PR copilot/fix-markdown-rendering-issues | 1–7 (all) | Steps 1-3 pre-existing. Steps 4-7 in this session. 258 tests pass. |

---

## Completion Criteria

- [x] HTML export works for all block types
- [x] NSAttributedString export with theme colours
- [x] Pro Mode toggle overrides live preview
- [x] ContentProvenance model + protocol defined
- [x] All tests pass (258 total: 245 existing + 13 new)
- [x] Backlog updated
