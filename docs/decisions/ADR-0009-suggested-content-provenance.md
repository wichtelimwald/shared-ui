# ADR-0009 – Suggested Content with Provenance Tracking

**Date:** 2026-04-12
**Status:** Proposed
**Author(s):** Copilot (based on product discovery interview)
**Source:** Interview §10.1, §9.1 #11

---

## Context

The product discovery interview surfaced a new requirement: content extracted from
websites (e.g., via share extension or import) should be visually distinct from
user-authored content. Users should be able to accept suggested content with a single
tap, and a source link should be retained even after acceptance. This is closely tied
to the extension/hook system for host apps.

---

## Problem Statement

How should the editor distinguish between user-authored content and imported/suggested
content, and how should source provenance be tracked and displayed?

---

## Options Considered

### Option 1 – No Distinction

Imported content is inserted as regular Markdown. No visual difference, no provenance.

**Pros:** Zero implementation effort
**Cons:** Users can't distinguish imported from authored content, no source tracking

### Option 2 – Visual Distinction + Tap-to-Accept + Source Link ⭐

Three-part approach:
1. **Visual distinction:** Imported content has a different background or subtle marker
   (e.g., faded colour, left border, or icon indicator)
2. **Tap-to-accept:** User taps to confirm imported content, converting it to regular
   content with full styling
3. **Persistent source link:** A small icon or link to the original source remains
   even after acceptance (e.g., a tiny 🔗 or favicon)

**Pros:**
- Users always know where content came from
- One-tap acceptance reduces friction
- Source provenance aids trust and attribution
- Supports the "content curation" use case in toogether-app

**Cons:**
- Requires metadata layer in the Markdown model
- Visual distinction adds rendering complexity
- Source link persistence needs a storage strategy

### Option 3 – Metadata Comments in Markdown

Use HTML comments (`<!-- source: https://... -->`) to embed provenance in the Markdown.

**Pros:** No model changes, provenance stored in the text itself
**Cons:** Fragile (users may edit/delete comments), clutters raw Markdown

---

## Decision

**Chosen:** Option 2 – Visual Distinction + Tap-to-Accept + Source Link

**Status:** Proposed (not yet Accepted — requires further design of the metadata model
and integration with the extension/hook system from ADR §9.1 #6)

**Rationale:**
The product owner specifically described this feature in §10.1 as important for content
curation workflows. It enhances trust and usability when importing content from external
sources.

---

## Proposed Architecture

### Content States

```
┌─────────────┐    tap-to-accept    ┌─────────────┐
│  Suggested   │ ──────────────────► │  Accepted    │
│  (imported)  │                     │  (authored)  │
│              │                     │              │
│ • Faded bg   │                     │ • Normal bg  │
│ • Source icon │                     │ • Source 🔗  │
│ • Accept btn │                     │ (retained)   │
└─────────────┘                     └─────────────┘
```

### Metadata Model

```swift
public struct ContentProvenance: Codable, Sendable {
    public let sourceURL: URL?
    public let sourceName: String?       // e.g., "Wikipedia"
    public let importDate: Date
    public var isAccepted: Bool
}
```

### Storage Strategy

Provenance metadata is stored separately from the Markdown text:
- The Markdown `@Binding<String>` remains pure Markdown (no metadata embedded)
- Host app stores provenance mapping (block ID → `ContentProvenance`)
- Editor receives provenance via an optional `MarkdownProvenanceProvider` protocol

---

## Invariants (Must Hold)

- Markdown text must never contain provenance metadata inline
- `@Binding<String>` always returns clean, valid Markdown
- Provenance is optional — editor works fully without it
- Source links must survive content editing (re-link after acceptance)

---

## Consequences

### Positive
- Users can trust and attribute imported content
- One-tap acceptance streamlines content curation
- Clean separation: Markdown stays pure, metadata is separate

### Negative / Trade-offs
- Requires metadata layer (not just text)
- Host app must implement provenance storage
- Block-level provenance mapping may be fragile during editing

### Risks
- Block identity changes when user edits content (provenance becomes stale)
  **Mitigation:** Use content hashing or fuzzy matching for re-association
- Complexity creep: this feature touches editor, renderer, and host app
  **Mitigation:** Implement as optional extension, not core requirement

---

## Follow-up Actions

- [x] Design `MarkdownProvenanceProvider` protocol (AK-071, plan-007)
- [x] Create visual design for suggested content styling (AK-072, plan-008)
- [x] Prototype tap-to-accept interaction (AK-073, plan-008)
- [ ] Define integration with extension/hook system (ADR §9.1 #6)
- [ ] Add backlog items for each component

---

## Supersedes / Superseded by

- **Supersedes:** N/A
- **Superseded by:** N/A

---

## References

- Interview §10.1 (Suggested Content with Provenance)
- Interview §9.1 #11 (Suggested Content ADR)
- Interview §9.1 #6 (Extension/Hook System — related)
