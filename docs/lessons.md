# Lessons Learned — AssistanceKit (shared-ui)

Append new lessons at the bottom. Keep entries actionable and concise.

---

## Architecture & Design

- **Three-layer Markdown architecture works.** Parsing (pure logic) → Rendering
  (NSTextStorage) → Presentation (SwiftUI) keeps concerns separated. Parsing layer
  is testable without simulator. Formalised in ADR-0001.

- **Hex colour strings for platform independence.** `MarkdownTheme` uses hex strings
  (`#007AFF`) instead of `UIColor`/`NSColor`. This enables `Codable` serialisation
  and future macOS/visionOS support without platform-specific colour types.

- **`nonisolated(unsafe)` needed for NSTextStorage.** `MarkdownTextStorage` inherits
  from `NSTextStorage` which has specific threading requirements. Use
  `nonisolated(unsafe)` for stored properties that must be accessed from both
  `@MainActor` and `nonisolated` contexts. See toogether lessons for details.

- **Tag detection prevents false heading matches.** Lines like `#tag1 #tag2` look like
  H1 headings to a naive parser. `MarkdownBlockParser.isTagLine()` explicitly detects
  and skips these. Pattern: check for space after `#` to distinguish headings from tags.

## Testing

- **Swift Testing framework (`@Suite`, `@Test`, `#expect`) preferred.** Both
  `MarkdownBlockParserTests` and `MarkdownSectionParserTests` use the modern Swift
  Testing framework, not XCTest. Follow this pattern for new tests.

- **Roundtrip tests catch subtle bugs.** `MarkdownSectionParser` has split→modify→join
  roundtrip tests that verify text preservation. Always include roundtrip tests for
  parse/serialize pairs.

## Integration

- **toogether-app is the primary Markdown consumer.** All new Markdown features should
  be validated in toogether-app first. Other apps can adopt incrementally.

- **studienmap-app has parallel Markdown implementation.** Before adding features,
  check if studienmap-app's `MarkdownParser` + `LiveMarkdownView` already solve the
  same problem differently. Migration to AssistanceKit planned (ADR-0006).

- **waldigel/magicforest confirmed as future consumer.** Interview confirmed this app
  will use AssistanceKit Markdown. Plan for it when designing new features.

- **mosQuit-app uses inline rendering only.** No full editor needed, just
  `MarkdownText` for inline Markdown rendering.

- **Zero external dependencies is a hard constraint.** ADR-0006 mandates no third-party
  packages. All Markdown parsing must use Foundation regex or manual string processing.

## Theme System

- **Custom Codable decoder enables seamless migration.** When upgrading `MarkdownTheme`
  from 4-colour to full schema (ADR-0005), a custom `init(from:)` that tries the new
  format first and falls back to legacy keys eliminates the need for a coordinated
  migration across all consuming apps. Legacy JSON files continue to decode correctly.

- **Legacy computed properties avoid breaking changes.** Adding `.accent`, `.syntax`,
  `.codeForeground`, `.codeBackground` as computed properties delegating to
  `light.accentColor` etc. means existing code compiles unchanged. The cost is minimal
  and the migration path is smoother.

- **ColorScheme must be explicitly passed to NSTextStorage.** SwiftUI's
  `@Environment(\.colorScheme)` can't be read from UIKit text storage. Instead,
  `MarkdownEditorView` reads the environment and pushes it to `MarkdownTextStorage`
  via a `colorScheme` property on `updateUIView`.

## Product Discovery

- **Interview-driven development works well.** The structured questionnaire
  (`markdown-editor-interview.md`) with ⭐ priority markers efficiently extracted
  11 ADR-worthy decisions, 3 new concepts, and 30+ backlog items in a single session.
  Always create a focused interview before major feature work.

- **Bear is the primary UX reference.** The product vision is a Bear-style live preview
  experience: fluid, calm, distraction-free. No split view, no mode switching.
  Every UX decision should be evaluated against "would Bear do it this way?"

- **Non-technical users are the primary audience.** Markdown control characters should
  disappear by default. WYSIWYG experience is the baseline. "Pro Mode" for raw syntax
  is a post-MVP opt-in.

- **Per-instance theming is required.** Not just per-app — toogether-app needs different
  themes for different locations within the same app. MarkdownTheme must be JSON-
  serializable and switchable at runtime.

- **VoiceOver is not an afterthought.** Interview explicitly stated full VoiceOver
  support must be designed in from the start (Rotor, block navigation, formatting
  accessibility). Add accessibility tests alongside feature tests.

## Testing Patterns

- **Regex patterns can be tested independently of UIKit.** `MarkdownTextStorage` is
  UIKit-only, but its regex patterns can be validated on Linux CI by compiling them
  via `NSRegularExpression` and checking match/capture results. This gives confidence
  in the highlighting logic without needing an iOS simulator.

- **Test both positive and negative cases for regex.** Each highlighting pattern needs
  tests for valid Markdown syntax (matches) and similar-looking input that should NOT
  match (e.g. `*italic*` pattern must not match `**bold**`).

## Dynamic Type & Fonts

- **UIFont.preferredFont(forTextStyle:) already scales.** It returns different sizes
  based on the current `UIContentSizeCategory`. The main work for Dynamic Type support
  is triggering a rehighlight when the category changes, not changing how fonts are created.

- **Centralise font creation in a provider.** Instead of calling `UIFont.preferredFont`
  inline in 16 highlighting rule closures, a `MarkdownFontProvider` struct computes all
  needed fonts once per highlighting pass. This keeps the rules clean and makes it easy
  to switch between Dynamic Type and fixed-size modes via `usesDynamicType`.

- **NSTextStorage needs explicit notification for Dynamic Type.** Unlike UITextView's
  `adjustsFontForContentSizeCategory`, custom attributed string attributes in an
  NSTextStorage don't auto-update. Observe `UIContentSizeCategory.didChangeNotification`
  and call `rehighlight()`.

## Floating Toolbar

- **Internal access for formatting methods.** `MarkdownTextView` formatting methods
  (formatBold, formatItalic, etc.) need to be `internal` (not `private`) so that
  the `MarkdownFloatingToolbar` can call them. This is acceptable since both types
  are in the same module.

- **Lazy toolbar creation avoids setup cost.** The `MarkdownFloatingToolbar` is only
  created on first text selection, not at editor init time. This keeps the common
  case (no selection) lightweight.

## Accessibility

- **`.isHeader` trait enables heading navigation.** SwiftUI's `.accessibilityAddTraits(.isHeader)`
  makes VoiceOver's heading rotor work automatically — no custom rotor needed for basic
  heading navigation in `MarkdownDocumentView`.

- **Block-type-aware labels improve navigation.** Instead of generic labels, prefix each
  block with its type: "Heading level 2, Location", "List item, Milk", "Quote: …",
  "Completed: Task". This helps VoiceOver users understand document structure.

- **Announce formatting actions via UIAccessibility.post.** When a formatting action
  (bold, italic, etc.) is applied, post `.announcement` with "Bold applied". This gives
  immediate feedback to VoiceOver users that their action succeeded.

- **Hide decorative elements from VoiceOver.** Bullet characters, quote bars, list numbers,
  chevron indicators, and blank spacers should use `.accessibilityHidden(true)` — they
  provide no useful information to screen reader users.

## Tag System

- **Tags as first-class block type.** Promoting tag lines from "skipped" to a proper
  `.tagLine([String])` block enables tag rendering, click-to-filter, and accessibility.
  The trade-off (slightly different parse output) is worth the feature gain.

- **`extractTags(from:)` complements `isTagLine`.** Keeping detection and extraction as
  separate methods gives callers flexibility: detection for block classification,
  extraction for rendering and callbacks.

## iPad Support

- **`keyCommands` override is the standard UIKit path.** For hardware keyboard shortcuts
  on iPad, override `keyCommands` on the `UITextView` subclass. Add `discoverabilityTitle`
  so shortcuts appear in the iPad ⌘-hold overlay.

## Undo/Redo

- **UITextView natively supports ⌘Z/⌘⇧Z.** Don't add these as explicit `keyCommands` —
  they already work via the responder chain and `NSUndoManager`. Adding them would
  override the built-in behaviour.

- **Undo/redo button state needs explicit refresh.** `UIButton.isEnabled` doesn't
  auto-track `UndoManager.canUndo`. Call `updateUndoRedoState()` each time the toolbar
  appears or the selection changes.

## Tag Autocompletion

- **Tag prefix extraction is pure Foundation logic.** `extractTagPrefix(at:in:)` uses
  only `NSString`/`NSRange` — no UIKit dependency. Keep it in `MarkdownBlockParser.swift`
  (alongside other parsing logic) so it's testable on all platforms.

- **Backward scan is robust for tag detection.** Scanning backwards from cursor to find
  `#` handles all edge cases: mid-word hashes (reject), line-start tags (accept),
  post-whitespace tags (accept). The key check is that `#` must be preceded by
  whitespace or be at position 0.

- **Cancel in-flight async tag queries.** When the user types fast, the prefix changes
  every keystroke. Cancel the previous `Task` before launching a new one to avoid
  stale suggestions appearing briefly.

## Image Insertion

- **Editor stores URLs, host app stores images.** Per ADR-0007, the editor never holds
  binary image data. `MarkdownImageInsertionDelegate.storeImage(_:suggestedName:)` is
  the async handoff point: the host app persists the image and returns a URL string.

- **PHPickerViewController is privacy-safe.** Unlike the old `UIImagePickerController`,
  `PHPicker` doesn't require Photo Library permission. The user selects within the
  picker and only the chosen photo's data is shared with the app.

- **`closestViewController` via responder chain.** To present `UIAlertController` or
  `PHPickerViewController` from a `UIView`, walk the responder chain to find the
  nearest `UIViewController`. This avoids needing to pass a VC reference through
  the coordinator.

- **Image helpers are platform-independent.** `markdownImageSyntax(url:altText:)` and
  `suggestedPhotoFilename()` live in `MarkdownBlockParser.swift` (Foundation only),
  keeping them testable on Linux CI alongside the other parsing helpers.

## Backlog Hygiene

- **Clean up duplicates between Backlog and Done sections.** Items marked as done
  in the Done section should be removed from the Backlog section. Previous sessions
  left AK-018, AK-060, AK-062, AK-065 in both places.

## Fullscreen Focus Mode

- **`inputAccessoryView` is the natural home for a fixed toolbar.** Rather than
  managing a separate view hierarchy, set the text view's `inputAccessoryView` to
  the fixed toolbar. UIKit handles keyboard tracking and safe area automatically.

- **Focus mode disables floating toolbar.** When `focusModeEnabled` is `true`, set
  `showsFloatingToolbar` to `false` in `updateUIView` so both toolbars don't fight
  for attention. The fixed toolbar provides superset functionality.

- **ScrollView for toolbar overflow.** The fixed toolbar uses a `UIScrollView` with
  horizontal scrolling so all buttons fit on narrow screens. This is especially
  important in portrait on iPhone SE / compact width devices.

- **Quote formatting reuses `insertLinePrefix`.** `formatQuote()` uses the same
  `insertLinePrefix("> ")` pattern as List and Heading. Toggle logic (remove if
  already present) works identically since it matches the prefix string.

### Toolbar & Context Menu Collision (2026-04-15)

1. **Floating toolbar and iOS context menu collide.** The Notion-style floating toolbar
   (`MarkdownFloatingToolbar`) appears above text selection at the same time as the iOS
   edit menu (`buildMenu(with:)`), creating two overlapping formatting UIs. Solution:
   disable floating toolbar by default (`showsFloatingToolbar: false`) and always show
   the fixed toolbar above the keyboard instead (Bear editor approach).

2. **Fixed toolbar should always be present, not just in focus mode.** Per the Bear
   approach, the keyboard-anchored formatting toolbar provides persistent, non-conflicting
   access to formatting actions. The `showsDoneButton` parameter controls whether the
   Done button appears (focus mode only).

3. **Live preview must render clean view when no cursor is active.** When the editor
   first loads without focus, `activeBlockIndex` is `nil`. Previously this was treated
   as "all blocks are active" (showing raw Markdown). The correct behavior: when live
   preview is enabled and no block is active, all blocks render as inactive/clean.

### Pro Mode & Export (2026-04-15)

1. **Pro Mode is a simple override of live preview.** `proModeEnabled` forces
   `effectiveLivePreview = livePreviewEnabled && !proModeEnabled`. No new rendering
   path needed — just skip block range computation so all blocks show raw syntax.

2. **ContentProvenance should be a separate model, not embedded in Markdown.** Per
   ADR-0009: the `@Binding<String>` stays pure Markdown. Provenance is stored and
   queried externally via `MarkdownProvenanceProvider`. This keeps the editor decoupled
   from host-app storage strategies.

3. **Export code was already in place.** Steps 1-3 of plan-007 were implemented in an
   earlier session but the plan status wasn't updated. Always update plan step status
   immediately after committing the implementation.

### Suggested Content Visual Pipeline (2026-04-15)

1. **Provenance rendering is pure SwiftUI — no UIKit needed.** The suggested content
   visual styling (tinted background, accent border, source label, accept button,
   source link) is implemented entirely in SwiftUI on `MarkdownDocumentView`.
   No `MarkdownTextStorage` changes required. Provenance is a presentation concern.

2. **Cache provenance in `@State` dictionary.** Since `MarkdownProvenanceProvider` is
   async, load all block provenance in a `.task` modifier and cache in
   `@State private var provenanceCache: [Int: ContentProvenance]`. Avoid calling
   the provider on every `body` re-render.

3. **Keep source link callback pure.** Instead of calling `UIApplication.shared.open(url)`
   directly (which couples the view to UIKit), use an `onSourceLinkTapped: ((URL) -> Void)?`
   callback. The host app decides how to open URLs. This matches the pattern used
   for `onTaskToggle` and `onTagTapped`.
