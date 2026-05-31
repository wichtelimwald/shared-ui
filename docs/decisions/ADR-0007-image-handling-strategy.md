# ADR-0007 – Image Handling Strategy

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot (based on product discovery interview)
**Source:** Interview §2.5, §9.1 #10

---

## Context

Images are a core feature in toogether-app (visual identity of locations depends on
them). The editor currently supports image rendering via `MarkdownImageDataProvider`
but has no image insertion capability in the editor itself. The interview defined
an MVP and post-MVP scope for image handling.

---

## Problem Statement

How should the Markdown editor handle image insertion, storage, and rendering across
different consuming apps?

---

## Options Considered

### Option 1 – URL-Only (Manual Markdown Syntax)

Users type `![alt](url)` manually. No picker, no upload.

**Pros:** Zero implementation effort
**Cons:** Terrible UX, only usable by Markdown experts

### Option 2 – Photo Library + URL Import (MVP) ⭐

Provide two insertion methods:
1. **Photo library picker** — select from device photos, app stores/manages the image
2. **URL-based import** — paste or share a web URL, image is referenced by URL

Host app provides a `MarkdownImageDataProvider` to resolve image references.

**Pros:** Covers the two most common image insertion patterns, reasonable effort
**Cons:** No camera capture, no drag & drop (iPad)

### Option 3 – Full Image Suite (All Methods)

Photo library + Camera + URL + Drag & Drop + Paste.

**Pros:** Maximum convenience
**Cons:** Significantly more effort, camera/drag-drop can be added later

---

## Decision

**Chosen:** Option 2 for MVP, Option 3 post-MVP

**MVP scope:**
- Photo library picker (integrated into editor toolbar/menu)
- URL-based import (manual or via share/import from websites)

**Post-MVP scope:**
- Camera capture (direct photo taking)
- Drag & Drop (iPad-specific)

**Rationale:**
Photo library and URL import cover the vast majority of image insertion use cases.
Camera and drag & drop are convenience features that can be added incrementally.

---

## Architecture

### Image Insertion Flow

```
User taps "Insert Image"
  ├── Photo Library → PHPicker → Host app stores image → Returns local:// URL
  └── URL Import    → User pastes URL → Markdown syntax inserted directly

Editor inserts: ![description](url)

Renderer calls: MarkdownImageDataProvider.imageData(for: url)
  ├── local:// → Host app resolves from cache/storage
  └── https:// → Host app downloads and caches
```

### Host App Responsibility

The editor does NOT store images. The host app:
1. Provides a `MarkdownImageDataProvider` to resolve image URLs
2. Handles storage (file system, CloudKit, cache)
3. Returns image data or a loading/error placeholder

### Protocol (Existing)

```swift
public protocol MarkdownImageDataProvider {
    func imageData(for url: URL) async -> Data?
}
```

---

## Invariants (Must Hold)

- Editor stores only Markdown text with image URLs — never binary image data
- `MarkdownImageDataProvider` is the single abstraction for image resolution
- Host app owns image storage and lifecycle
- Photo library picker uses `PHPickerViewController` (privacy-safe, no permissions dialog)

---

## Consequences

### Positive
- Clean separation: editor handles Markdown, host app handles images
- `MarkdownImageDataProvider` already exists and works in toogether-app
- Photo library picker is privacy-safe (no blanket photo access)

### Negative / Trade-offs
- No camera capture in MVP
- No drag & drop in MVP (iPad users must use picker)
- Host app must implement `MarkdownImageDataProvider`

### Risks
- Large images may impact editor performance
  **Mitigation:** Host app should provide thumbnails for inline display
- URL-based images may break if remote server goes down
  **Mitigation:** Host app should cache fetched images locally

---

## Follow-up Actions

- [x] Add photo library picker to editor (AK-054)
- [x] Add URL-based image import (AK-055)
- [ ] Document `MarkdownImageDataProvider` usage in README
- [ ] Post-MVP: Camera capture, Drag & Drop

---

## Supersedes / Superseded by

- **Supersedes:** N/A
- **Superseded by:** N/A

---

## Related Code

- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownDocumentView.swift` (image rendering)
- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownEditorView.swift` (image insertion)

---

## References

- Interview §2.5 (Image Insertion)
- Interview §9.1 #10 (Image Handling ADR)
