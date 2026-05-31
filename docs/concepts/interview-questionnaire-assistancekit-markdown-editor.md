# Interview Questionnaire — AssistanceKit Markdown Editor

**Purpose:** This questionnaire helps the development team understand the product
vision, target users, and priorities for the AssistanceKit Markdown Editor.
Answers will be used to refine the concept, define MVP scope, plan the backlog,
and inform Architecture Decision Records (ADRs).

**Instructions:** Answer each question as thoroughly as you like. Short bullet
points are fine — we can always dive deeper later. Questions marked ⭐ are
especially important for the MVP.

---

## 1 — Usage Context & Target Audience

### 1.1 ⭐ Which apps will use the editor?

**Answer:**
- **toogether-app** — already in production
- **studienmap-app** — currently has its own implementation (migration planned)
- **mosQuit-app** — inline rendering only
- **waldigel/magicforest** — confirmed
- More apps will follow — the editor must be a robust, reusable module from the start

### 1.2 ⭐ Who are the end users of the editor?

**Answer:**
- Primarily non-technical users who are unfamiliar with Markdown syntax
- WYSIWYG experience is the default: control characters disappear immediately after input, users always see the rendered result
- A "Markdown Pro Mode" is planned for later, where raw syntax remains visible
- Markdown syntax should still be accepted as input — characters just vanish on confirmation (like Typora / Bear)

### 1.3 In which contexts is the editor used?

**Answer:**
- Primarily short notes — a few lines, not full pages
- Use cases include: location descriptions (toogether), learning content and topic lists (studienplan)
- Structure is important — users should be able to organize even short content clearly
- Edge case: a few pages is possible, but doesn't need to be perfectly optimized

### 1.4 Should the editor work as a fullscreen editor or an embedded element?

**Answer:**
- Both
- Default: embedded (e.g. within a ScrollView, as in toogether-app)
- Optional: fullscreen/focus mode that activates when the user taps into the text field

---

## 2 — Feature Scope (Editing)

### 2.1 ⭐ Which Markdown features are must-have for the editor?

**Answer:**
- Keep the current feature set as-is for MVP:
  - Headings (H1, H2, H3)
  - Bold, Italic, Strikethrough, Code
  - Links
  - Ordered and unordered lists
  - Blockquotes
  - Images (via renderer)
  - Horizontal rules
  - Live syntax highlighting
- Emojis work out of the box (standard Unicode) — no extra work needed
- Tables: not for MVP, added to backlog

### 2.2 ⭐ Should there be a formatting toolbar?

**Answer:**
- Three-layer approach:
  1. **iOS Context Menu** — retained as-is
  2. **Floating Toolbar on text selection** — appears when text is selected (like Notion)
  3. **Fixed Toolbar** — only in fullscreen mode (like Bear)
- If Bear-style live preview is fully achieved, the context menu for basic formatting may become redundant and can be removed
- Bear is the UX reference for toolbar design

### 2.3 Should the editor support tables?

**Answer:**
- Not for MVP
- Added to backlog for a later version

### 2.4 Should there be task lists?

**Answer:**
- Yes — `- [ ] Task` / `- [x] Done`
- With tap-to-toggle directly in the renderer
- Considered very useful for notes and learning lists

### 2.5 How should image insertion work?

**Answer:**
- MVP:
  - Photo library picker
  - URL-based import (manual or via share/import from websites)
- Post-MVP:
  - Camera capture
  - Drag & Drop (iPad)
- Note: Images are a core feature in toogether-app (visual identity of locations depends on them)

### 2.6 Should hashtags/tags be supported?

**Answer:**
- Yes — full support:
  - Color highlighting in the editor
  - Autocompletion
  - Clickable (→ filter/search)
- Parser already has a foundation — build on existing implementation

---

## 3 — Feature Scope (Rendering / Document View)

### 3.1 ⭐ What rendering style is desired?

**Answer:**
- Bear-style Live Preview is the target
- "Live Preview" principle (originally from Typora): everything renders live, only the active block/line briefly shows its syntax characters
- Calm, distraction-free writing experience — no mode switching, no split view
- Bear is the primary UX reference; Obsidian is a secondary reference for ecosystem thinking

### 3.2 Should the renderer be interactive?

**Answer:**
- Yes, MVP:
  - Tap links → open
  - Tap images → enlarge
  - Tap task list items → toggle (already decided)
  - Collapse/expand sections → MVP (important for clarity in toogether)
- Post-MVP:
  - Map/location previews (toogether-specific)
  - Website link previews (link unfurling)
  - Info cards

### 3.3 Should there be a split view (editor + preview side by side)?

**Answer:**
- No — Bear-style Live Preview makes split view redundant

### 3.4 How should code blocks be rendered?

**Answer:**
- MVP: generic syntax highlighting (colored background, monospace font)
- Post-MVP: language-specific syntax highlighting (e.g. Swift, Python)

---

## 4 — Theming & Customization

### 4.1 ⭐ How important is theming flexibility?

**Answer:**
- Very important — even within a single app (toogether), different locations have different styles and colors
- Theme must be switchable per instance/context, not just per app
- Required controls: colors, font size, line spacing (at minimum)

### 4.2 Should apps be able to define their own themes?

**Answer:**
- Yes — and themes must be dynamically loadable at runtime
- In toogether, styles are loaded via JSON — `MarkdownTheme` must therefore be JSON-serializable
- Each theme must define both Light and Dark variants

### 4.3 Is automatic Dark Mode switching sufficient?

**Answer:**
- Each theme defines its own Light and Dark variant
- The JSON schema must reflect both variants per theme

---

## 5 — Platform & Integration

### 5.1 ⭐ Which platforms should the editor support?

**Answer:**
- MVP: iPhone and iPad (shared codebase)
- iPad implies keyboard shortcut support (Bear-style)
- Post-MVP: macOS (after MVP is stable)
- visionOS / watchOS: not planned

### 5.2 How should the editor integrate into the host app?

**Answer:**
- MVP: `@Binding<String>` is sufficient
- Post-MVP (decided as concrete app needs arise):
  - Delegate/callbacks (onChange, onFocus, onSubmit)
  - Programmatic control (focus, scroll-to-position)
  - State queries (isEmpty, hasChanges, wordCount)

### 5.3 Should the editor integrate with SwiftData / Core Data?

**Answer:**
- No direct integration — would couple the editor to host app architecture
- Instead: debounced `onChange` callback; host app decides when and how to persist
- Keeps the editor slim and independent

### 5.4 Should studienmap-app be migrated to AssistanceKit Markdown?

**Answer:**
- Yes — migration is planned
- Differences and requirements between the two implementations should be documented in a dedicated ADR

---

## 6 — UX & Accessibility

### 6.1 ⭐ How important is VoiceOver support?

**Answer:**
- Full VoiceOver support is a clear goal — not an afterthought
- Must be designed in from the start: Rotor support, block navigation, formatting accessibility
- Everything that can be done should be done

### 6.2 Should Dynamic Type be supported?

**Answer:**
- Yes — the editor should respect the user's iOS system font size

### 6.3 Which languages should the editor support?

**Answer:**
- MVP: Latin character set (German umlauts already tested and working)
- Backlog: RTL (Arabic/Hebrew), CJK (Chinese/Japanese/Korean)

### 6.4 How should Undo/Redo work?

**Answer:**
- Both standard iOS gestures (shake, three-finger swipe) and explicit Undo/Redo buttons in the toolbar
- Reference: Bear's implementation

---

## 7 — Performance & Limits

### 7.1 How long will documents typically be?

**Answer:**
- Typically a few lines to a short note
- Edge case: a few pages — must work, but does not need to be perfectly optimized
- Performance issues should be addressed when they appear in practice

### 7.2 Are there performance-critical scenarios?

**Answer:**
- Large paste operations are a known, frequent use case — must not block the UI
- Syntax highlighting must handle paste gracefully (e.g. debounced or chunked)

---

## 8 — Future Vision

### 8.1 What would make the editor truly great in v2/v3?

**Answer:**
- Achieving the same experience as Bear: fluid, delightful, effortless
- Quality of feel is the goal — not a single feature

### 8.2 Are there other editors that serve as inspiration?

**Answer:**
- **Bear** — fluidity, iOS nativity, calm UX
- **Obsidian** — ecosystem thinking, extensibility
- **Duolingo** — playfulness, humor, moments that make you smile
- The editor should have personality, not just function

### 8.3 Should the editor ever be released as a standalone app?

**Answer:**
- Not currently planned — remains an embedded module
- Integrations or partnerships with existing tools are worth exploring long-term

---

## 9 — Architecture Decisions (ADRs)

### 9.1 Which decisions should be documented as ADRs before further development?

**Answer:**

| # | Decision | Options | Impact |
|---|----------|---------|--------|
| 1 | Formatting UI | Context Menu (current), Floating Toolbar, Fixed Toolbar (fullscreen) | Core editing UX |
| 2 | Platform strategy | iPhone+iPad (MVP), macOS (post-MVP) | View layer architecture |
| 3 | Table support | None (MVP), rendering only, full editing | Parser & editor complexity |
| 4 | Theme system | Extend current 4-color system vs. full system (font, spacing, JSON-serializable) | Flexibility vs. simplicity |
| 5 | studienmap-app migration | Migrate to AssistanceKit, document delta requirements | Maintenance overhead |
| 6 | Extension/Hook system for host apps | How host apps extend the editor without touching the core (plugin-style à la Obsidian) | Reusability & ecosystem |
| 7 | Live Preview rendering strategy | Bear-style (active block shows syntax) vs. classic mode switching | UX architecture |
| 8 | Tag system architecture | Autocompletion, highlighting, clickable tags — data model & UI | Cross-app consistency |
| 9 | JSON Theme schema | Structure of Light/Dark variants, per-instance theming | Theme portability |
| 10 | Image handling | Storage, `MarkdownImageDataProvider`, photo library & URL import | Media architecture |
| 11 | Suggested Content — states, UX & source tracking | Visual distinction of imported/unconfirmed content, tap-to-accept, persistent source link | Content provenance UX |

---

## 10 — Open Additions

### 10.1 Is there anything we didn't ask about that is important?

**Answer:**
- **Suggested Content with Provenance (→ ADR #11):** Content extracted from websites should be visually distinct (e.g. different background or subtle marker), easy to accept with one tap, and retain a small source icon/link even after acceptance. This is closely tied to the Extension/Hook system (ADR #6).

### 10.2 What is the one thing the editor absolutely must get right?

**Answer:**
> It must be fun — meaning: fluid, reliable, and simple enough for non-experts to use without thinking.

---

*Interview conducted as part of Product Discovery for the AssistanceKit Markdown Editor.
Answers feed into: concept documents, ADRs, backlog (`shared-ui/docs/todo.md`), and implementation plans (`shared-ui/docs/plans/`).*
