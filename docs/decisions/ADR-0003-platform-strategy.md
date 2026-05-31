# ADR-0003 – Platform Strategy: iPhone + iPad MVP, macOS Post-MVP

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot (based on product discovery interview)
**Source:** Interview §5.1, §9.1 #2

---

## Context

The AssistanceKit Markdown Editor is currently iOS-only, built on `UITextView` and
`NSTextStorage`. As the editor becomes a shared module, we need to decide which
platforms to support and in what order.

---

## Problem Statement

Which Apple platforms should the Markdown editor support, and in what order, to
maximise value while controlling complexity?

---

## Options Considered

### Option 1 – iPhone Only

Keep the current iOS-only implementation.

**Pros:** Simplest, no additional work
**Cons:** Ignores iPad-specific opportunities (keyboard, multitasking)

### Option 2 – iPhone + iPad (shared codebase) ⭐

Single UIKit-based codebase for iPhone and iPad, with iPad-specific enhancements
(keyboard shortcuts, external keyboard support).

**Pros:** Same code runs on both, iPad adds keyboard shortcut value
**Cons:** Must test on both form factors

### Option 3 – iPhone + iPad + macOS (simultaneous)

Ship all three platforms together using Catalyst or AppKit + UIKit.

**Pros:** Maximum reach immediately
**Cons:** NSTextView has different API from UITextView; doubles view layer work

---

## Decision

**Chosen:** Option 2 for MVP, macOS in post-MVP phase

**Rationale:**
The product owner confirmed iPhone + iPad as MVP scope. iPad implies keyboard shortcut
support (Bear-style). macOS is explicitly deferred until the MVP is stable. visionOS
and watchOS are not planned.

---

## Implementation Strategy

### MVP
- Shared UIKit codebase for iPhone and iPad
- Add keyboard shortcuts for formatting on iPad (Cmd+B, Cmd+I, Cmd+K, etc.)
- Test on both iPhone and iPad simulators in CI

### Post-MVP
- Evaluate macOS support via:
  - Option A: Mac Catalyst (minimal effort, UIKit-based)
  - Option B: Native AppKit with `NSTextView` (best experience, more work)
- Decision deferred to a future ADR when MVP is stable

---

## Invariants (Must Hold)

- Parsing layer (`MarkdownBlockParser`, `MarkdownSectionParser`) must remain platform-agnostic
- `MarkdownTheme` uses hex strings (not UIColor/NSColor) to stay platform-independent
- Presentation layer uses `#if canImport(SwiftUI)` guards
- All keyboard shortcuts must use `UIKeyCommand` (iPad) or equivalent

---

## Consequences

### Positive
- Focused MVP scope reduces risk
- Parsing layer already works on all platforms
- Hex colour theme system is already macOS-ready

### Negative / Trade-offs
- macOS users must wait for post-MVP
- May need to refactor view layer when adding macOS

### Risks
- UITextView API differences between iPhone/iPad
  **Mitigation:** Test on both form factors; most differences are layout-related

---

## Follow-up Actions

- [ ] Add iPad keyboard shortcuts (AK-018)
- [ ] Add iPad simulator to CI test matrix
- [ ] Create future ADR for macOS strategy when post-MVP phase begins

---

## Supersedes / Superseded by

- **Supersedes:** N/A
- **Superseded by:** N/A

---

## Related Code

- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownEditorView.swift`
- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownTheme.swift`
- AK-011, AK-031 in backlog

---

## References

- Interview §5.1 (Platform Support)
- Interview §9.1 #2 (Platform Strategy ADR)
