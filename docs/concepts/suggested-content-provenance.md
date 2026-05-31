# Concept: Suggested Content with Provenance Tracking

**Date:** 2026-04-12
**Status:** Draft
**Author(s):** Copilot (based on product discovery interview)
**Related ADR:** ADR-0009 (Suggested Content with Provenance)

---

## Goal

Define a system for visually distinguishing imported/suggested content from user-authored
content, with tap-to-accept functionality and persistent source provenance tracking.

---

## Motivation

In toogether-app, content is frequently extracted from websites (e.g., location
descriptions, event details). The product owner identified a need to:

1. **Visually distinguish** imported content — users should immediately see what they
   wrote vs. what was imported
2. **One-tap acceptance** — imported content starts as "suggested" and becomes "accepted"
   with a single tap
3. **Source tracking** — even after acceptance, a small source link/icon is retained
   for attribution and trust

This feature is closely related to the extension/hook system (Interview §9.1 #6)
that allows host apps to extend the editor without modifying core code.

---

## Proposed Approach

### Content Lifecycle

```
              Import                      Tap-to-Accept
  Website ──────────►  Suggested   ─────────────────────►  Accepted
                       (unconfirmed)                        (user-owned)

  Visual:              Faded bg                             Normal bg
                       Source icon                          Source 🔗 (small)
                       "Accept" btn                         (retained)
```

### Visual Design

| State | Background | Source Indicator | Actions |
|-------|-----------|-----------------|---------|
| Suggested | Subtle highlight (e.g., light blue tint) | Source favicon + domain name | Tap to accept, swipe to delete |
| Accepted | Normal (matches surrounding content) | Small 🔗 icon linking to source | Tap 🔗 to revisit source |

### Data Model

Provenance is stored **separately** from the Markdown text. The Markdown binding
(`@Binding<String>`) always contains clean, valid Markdown — no metadata embedded.

```swift
/// Tracks the origin of imported content
public struct ContentProvenance: Codable, Sendable, Equatable {
    /// URL of the original source (nil for user-authored content)
    public let sourceURL: URL?

    /// Human-readable source name (e.g., "Wikipedia", "booking.com")
    public let sourceName: String?

    /// When the content was imported
    public let importDate: Date

    /// Whether the user has accepted the suggested content
    public var isAccepted: Bool

    /// Range of the content in the Markdown text (line-based)
    public var lineRange: Range<Int>
}
```

### Integration Architecture

```
Host App                         AssistanceKit
─────────                        ─────────────
                                 ┌──────────────────┐
┌────────────────┐   provides    │MarkdownEditorView │
│Provenance Store│──────────────►│                    │
│ (SwiftData)    │               │ • Renders suggested│
│                │◄──────────────│   vs. accepted     │
│                │   callbacks   │ • Tap-to-accept    │
└────────────────┘               │ • Source link tap  │
                                 └──────────────────┘
```

**Protocol:**
```swift
public protocol MarkdownProvenanceProvider: AnyObject {
    /// Returns provenance info for content at the given line
    func provenance(forLine line: Int) -> ContentProvenance?

    /// Called when user accepts suggested content
    func acceptContent(at lineRange: Range<Int>)

    /// Called when user taps a source link
    func openSource(url: URL)
}
```

---

## Scope

### In Scope
- `ContentProvenance` data model
- `MarkdownProvenanceProvider` protocol
- Visual distinction for suggested vs. accepted content
- Tap-to-accept interaction
- Source link display and tap action

### Out of Scope
- Content extraction from websites (host app responsibility)
- Web scraping or share extension (host app responsibility)
- Provenance storage implementation (host app uses SwiftData or any persistence)
- Content diffing or version tracking

---

## Implementation Strategy

### Phase 1 — Data Model & Protocol
- Define `ContentProvenance` struct
- Define `MarkdownProvenanceProvider` protocol
- Add optional `provenanceProvider` to `MarkdownEditorView` and `MarkdownDocumentView`

### Phase 2 — Visual Rendering
- Add suggested-content styling to `MarkdownTextStorage` (tinted background)
- Add source indicator UI (favicon + domain)
- Add "accept" button/gesture

### Phase 3 — Interactions
- Tap-to-accept: update provenance state, animate transition
- Source link tap: delegate to `MarkdownProvenanceProvider`
- Swipe-to-delete: remove suggested content

### Phase 4 — Host App Integration (toogether-app)
- Implement `MarkdownProvenanceProvider` in toogether-app
- Store provenance in SwiftData alongside activity content
- Wire share extension to import content with provenance

---

## Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | How should provenance survive content editing? (Line ranges change when text is edited) | Engineering | Open |
| 2 | Should multiple sources be supported in a single document? | Product | Open |
| 3 | How should provenance work with copy/paste? | Engineering | Open |
| 4 | Should the source link be visible in exported content? | Product | Open |

---

## Acceptance Criteria

- [ ] `ContentProvenance` struct defined and documented
- [ ] `MarkdownProvenanceProvider` protocol defined
- [ ] Suggested content visually distinct from authored content
- [ ] Tap-to-accept transitions content from suggested to accepted
- [ ] Source link is retained after acceptance
- [ ] Source link is tappable

---

## References

- ADR-0009: Suggested Content with Provenance
- Interview §10.1 (Suggested Content with Provenance — ADR #11)
- Interview §9.1 #6 (Extension/Hook System — related)
