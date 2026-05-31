# Implementation Plan: Suggested Content Visual Pipeline

**Plan ID:** plan-008
**Date:** 2026-04-15
**Status:** ✅ Complete
**Scope:** shared-ui (AssistanceKit)
**Source:** AK-072, AK-073, AK-074 from `docs/todo.md`; ADR-0009
**Estimated Effort:** M (6 steps, ~1–2 sessions)

---

## Goal

Add visual styling, tap-to-accept interaction, and persistent source link display
for suggested (imported) content in `MarkdownDocumentView`. Builds on the
`ContentProvenance` model and `MarkdownProvenanceProvider` protocol from plan-007.

---

## Steps

| # | Task | Type | Effort | Status | Notes |
|---|------|------|--------|--------|-------|
| 1 | Wire `provenanceProvider` into `MarkdownDocumentView` | 🤖 Code | XS | ✅ | New optional init param, async loading |
| 2 | Visual styling for suggested blocks (AK-072) | 🤖 Code | S | ✅ | Tinted bg, left accent border, source label |
| 3 | Tap-to-accept interaction (AK-073) | 🤖 Code | S | ✅ | Accept button, async provider call, animated transition |
| 4 | Source link display + tap action (AK-074) | 🤖 Code | S | ✅ | Persistent 🔗 icon, onSourceLinkTapped callback |
| 5 | Tests for provenance rendering pipeline | 🤖 Code | S | ✅ | 10 tests in MarkdownProvenanceRenderingTests |
| 6 | Update backlog, Ready section, lessons; archive plan-008 | 📝 Docs | XS | ✅ | AK-072/073/074 done |

### Step Details

#### Step 1 — Wire provenanceProvider
- **What:** Add optional `provenanceProvider` parameter to `MarkdownDocumentView.init`
- **Where:** `MarkdownDocumentView.swift`
- **Details:** Store as property. In `blockView(_:index:)`, query provenance async.
  Use `@State` dictionary to cache results per block index.
- **Acceptance:** Compiles, existing tests pass, provider is queryable

#### Step 2 — Visual Styling (AK-072)
- **What:** Wrap block content in a styled container when provenance exists and `!isAccepted`
- **Where:** `MarkdownDocumentView.swift` — new `suggestedBlockWrapper` modifier
- **Details:** Per ADR-0009:
  - Faded/tinted background (accent color at 6% opacity)
  - Left accent border (3pt, accent color at 40%)
  - Small source name label at top-right (caption, secondary color)
- **Acceptance:** Suggested blocks visually distinct from user-authored blocks

#### Step 3 — Tap-to-Accept (AK-073)
- **What:** Add "Accept" button overlay on suggested blocks; call provider on tap
- **Where:** `MarkdownDocumentView.swift`
- **Details:** Small "✓ Accept" button in bottom-right of suggested block.
  On tap: `await provider.acceptContent(atBlockIndex:)`, update local state,
  animate transition from suggested to accepted styling.
- **Acceptance:** Tap triggers accept, visual transition occurs

#### Step 4 — Source Link (AK-074)
- **What:** Show persistent 🔗 icon after acceptance (or for accepted provenance)
- **Where:** `MarkdownDocumentView.swift`
- **Details:** Small link icon with source display name. Tapping opens sourceURL
  via `onSourceLinkTapped` callback (not `UIApplication.open` — keep SwiftUI pure).
- **Acceptance:** Source link visible after acceptance, tappable

#### Step 5 — Tests
- **What:** Test provenance wiring, styling logic, accept flow
- **Where:** New `MarkdownProvenanceRenderingTests.swift`
- **Acceptance:** All new + existing tests pass

#### Step 6 — Docs
- **What:** Update backlog, archive plan
- **Acceptance:** Backlog reflects completion

---

## Progress Log

| Date | Session | Steps Completed | Notes |
|------|---------|-----------------|-------|
| 2026-04-15 | PR copilot/fix-markdown-rendering-issues | 1–6 (all) | 268 tests pass (258+10 new) |

---

## Completion Criteria

- [x] Suggested blocks have tinted background + accent border + source label
- [x] "Accept" button transitions block to accepted state
- [x] Source 🔗 icon persists after acceptance
- [x] All tests pass (268 total: 258 existing + 10 new)
- [x] Backlog updated
