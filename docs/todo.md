# AssistanceKit — Backlog

Task-ID-Prefix: **AK-**

---

## 🟢 Ready (unblocked)

| ID | Task | Priority | Effort | Notes |
|----|------|----------|--------|-------|
| AK-030 | Evaluate studienmap-app migration to AssistanceKit Markdown | P2 | S | ADR-0006 Phase 1: parser audit |
| AK-080 | waldigel/magicforest integration | P2 | M | Confirmed consumer |
| AK-081 | mosQuit-app migration to AssistanceKit rendering | P3 | S | Currently inline only |
| AK-019 | Performance optimization for large documents (>10K chars) | P3 | M | Incremental highlighting |
| AK-067 | Add camera capture for image insertion | P3 | S | Post-MVP per ADR-0007 |
| AK-075 | RTL language support (Arabic/Hebrew) | P3 | M | — |

---

## 📋 Backlog

### Markdown Editor — Core

| ID | Task | Priority | Effort | Blocker | Notes |
|----|------|----------|--------|---------|-------|
| AK-019 | Performance optimization for large documents (>10K chars) | P3 | M | — | Incremental highlighting. Interview: only when needed. |
| AK-058 | Add table support (rendering only) | P3 | M | — | Interview: not MVP, backlog for later |
| AK-059 | Add table editing support | P3 | L | AK-058 | Full table creation and editing |

### Markdown Editor — Live Preview

*No items remaining.*

### Markdown Editor — Images

| ID | Task | Priority | Effort | Blocker | Notes |
|----|------|----------|--------|---------|-------|
| AK-067 | Add camera capture for image insertion | P3 | S | AK-054 | Post-MVP per ADR-0007 |
| AK-068 | Add Drag & Drop image insertion (iPad) | P3 | M | AK-054 | Post-MVP per ADR-0007 |

### Markdown Editor — Suggested Content

*No items remaining.*

### Markdown Editor — Accessibility & i18n

| ID | Task | Priority | Effort | Blocker | Notes |
|----|------|----------|--------|---------|-------|
| AK-075 | RTL language support (Arabic/Hebrew) | P3 | M | — | Interview: backlog item |
| AK-076 | CJK language support (Chinese/Japanese/Korean) | P3 | M | — | Interview: backlog item |
| AK-077 | Language-specific code syntax highlighting | P3 | L | — | Post-MVP: Swift, Python, etc. |

### Cross-Project

| ID | Task | Priority | Effort | Blocker | Notes |
|----|------|----------|--------|---------|-------|
| AK-030 | Evaluate studienmap-app migration to AssistanceKit Markdown | P2 | S | — | ADR-0006 created. Phase 1: audit. |
| AK-031 | Add macOS support (NSTextView variant) | P3 | L | ~~AK-050~~ Done | Per ADR-0003: post-MVP |
| AK-080 | waldigel/magicforest integration | P2 | M | ~~AK-050~~ Done | Interview: confirmed consumer |
| AK-081 | mosQuit-app migration to AssistanceKit rendering | P3 | S | — | Currently inline only |

### Infrastructure

*No infrastructure items remaining.*

---

## ✅ Done

| ID | Task | Completed | PR/Session |
|----|------|-----------|------------|
| — | Extract Markdown module from toogether-app | 2026-03 | Initial shared-ui setup |
| — | Create MarkdownBlockParser + 42 tests | 2026-03 | — |
| — | Create MarkdownSectionParser + 25 tests | 2026-03 | — |
| — | Create product infrastructure (copilot-instructions, docs, ADRs) | 2026-04-12 | PR |
| AK-001 | Complete product discovery interview | 2026-04-12 | Interview conducted |
| AK-002 | Add DocC documentation to all public Markdown APIs | 2026-04-12 | PR |
| AK-003 | Add unit tests for MarkdownTextStorage (50 regex pattern tests) | 2026-04-12 | PR |
| AK-010 | ADR: Formatting UI (→ ADR-0002) | 2026-04-12 | This PR |
| AK-011 | ADR: Platform Strategy (→ ADR-0003) | 2026-04-12 | This PR |
| AK-012 | ADR: Table Support (→ noted in ADR-0004: not MVP) | 2026-04-12 | This PR |
| AK-013 | ADR: Theme System (→ ADR-0005) | 2026-04-12 | This PR |
| AK-040 | Update shared-ui README with Markdown documentation | 2026-04-12 | PR |
| AK-052 | Redesign MarkdownTheme with JSON schema (ADR-0005) | 2026-04-13 | PR copilot/focus-assistance-kit-markdown |
| AK-051 | Add tag highlighting in editor (ADR-0008 Phase 1) | 2026-04-13 | PR copilot/focus-assistance-kit-markdown |
| AK-016 | Add task list support — parser, renderer, tap-to-toggle | 2026-04-13 | PR copilot/focus-assistance-kit-markdown |
| AK-063 | Active block detection (cursor tracking) | 2026-04-13 | PR copilot/focus-assistance-kit-markdown |
| AK-064 | Block-level render toggling (Bear-style Live Preview) | 2026-04-13 | PR copilot/focus-assistance-kit-markdown |
| AK-015 | Dynamic Type support — MarkdownFontProvider, notification observer, usesDynamicType | 2026-04-13 | PR copilot/assistancekit-markdown-continue |
| AK-014 | Floating toolbar on text selection — Bold, Italic, Strikethrough, Code, Link | 2026-04-13 | PR copilot/assistancekit-markdown-continue |
| AK-053 | Section collapse/expand in MarkdownDocumentView — tap heading to toggle, animated | 2026-04-13 | PR copilot/assistancekit-markdown-continue |
| AK-017 | VoiceOver accessibility — heading traits, block labels, formatting announcements | 2026-04-14 | PR copilot/assistancekit-markdown-continue |
| AK-062 | Tag click-to-filter — tagLine block type, onTagTapped callback, tappable tag chips | 2026-04-14 | PR copilot/assistancekit-markdown-continue |
| AK-018 | iPad keyboard shortcuts — ⌘B/I/K, ⌘⇧S/C with discoverability titles | 2026-04-14 | PR copilot/assistancekit-markdown-continue |
| AK-060 | MarkdownTagProvider protocol + MarkdownTag model — async, Sendable, 8 tests | 2026-04-14 | PR copilot/assistancekit-markdown-continue |
| AK-065 | Smooth Live Preview transitions — 150ms crossfade on block change | 2026-04-14 | PR copilot/assistancekit-markdown-continue |
| AK-004 | Formatting action unit tests — 18 tests for wrap/prefix logic | 2026-04-14 | PR copilot/assistancekit-markdown-continue |
| AK-050 | Bear-style Live Preview MVP — active block detection, syntax hiding, transitions | 2026-04-14 | Via AK-063 + AK-064 + AK-065 |
| AK-032 | CODEOWNERS entry for shared-ui/ | 2026-04-14 | Already present in .github/CODEOWNERS |
| AK-041 | CI workflow path filter for shared-ui/ | 2026-04-14 | Already present in .github/workflows/ci.yml |
| AK-057 | Undo/Redo buttons in floating toolbar — with separator, disabled state, VoiceOver | 2026-04-14 | PR copilot/assistancekitmarkdown-update |
| AK-061 | Tag autocompletion UI — dropdown on `#`, queries MarkdownTagProvider, 13 tests | 2026-04-14 | PR copilot/assistancekitmarkdown-update |
| AK-054 | Photo library picker for image insertion — PHPicker, MarkdownImageInsertionDelegate | 2026-04-14 | PR copilot/assistancekitmarkdown-update |
| AK-055 | URL-based image import — alert dialog, `![alt](url)` syntax insertion | 2026-04-14 | PR copilot/assistancekitmarkdown-update |
| AK-082 | iPad Simulator build in CI — xcodebuild conditional step for shared-ui | 2026-04-14 | PR copilot/assistancekitmarkdown-update |
| AK-056 | Fullscreen/focus mode — MarkdownFixedToolbar, MarkdownFocusEditorView, ADR-0002 Phase 2 | 2026-04-14 | PR copilot/assistancekitmarkdown-update |
| AK-083 | Fix live preview default: render clean when unfocused, always show fixed toolbar | 2026-04-15 | PR copilot/fix-markdown-rendering-issues |
| AK-084 | Remove floating toolbar as default — fix context menu collision, Bear-style keyboard toolbar | 2026-04-15 | PR copilot/fix-markdown-rendering-issues |
| AK-020 | Markdown export — HTML + NSAttributedString with theme, inline Markdown, all block types | 2026-04-15 | PR copilot/fix-markdown-rendering-issues |
| AK-066 | Pro Mode toggle — `proModeEnabled` overrides live preview, raw syntax always shown | 2026-04-15 | PR copilot/fix-markdown-rendering-issues |
| AK-070 | ContentProvenance model — Codable, Sendable, sourceURL/sourceName/importDate/isAccepted | 2026-04-15 | PR copilot/fix-markdown-rendering-issues |
| AK-071 | MarkdownProvenanceProvider protocol — async, Sendable, provenance(forBlockAt:) + acceptContent | 2026-04-15 | PR copilot/fix-markdown-rendering-issues |
| AK-072 | Visual styling for suggested content — tinted bg, accent border, source label in MarkdownDocumentView | 2026-04-15 | PR copilot/fix-markdown-rendering-issues |
| AK-073 | Tap-to-accept interaction — "Accept" button, animated transition to accepted state | 2026-04-15 | PR copilot/fix-markdown-rendering-issues |
| AK-074 | Source link display — persistent 🔗 icon with onSourceLinkTapped callback after acceptance | 2026-04-15 | PR copilot/fix-markdown-rendering-issues |
