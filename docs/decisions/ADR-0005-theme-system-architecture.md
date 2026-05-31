# ADR-0005 – Theme System Architecture: JSON-Serializable Per-Instance Themes

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot (based on product discovery interview)
**Source:** Interview §4.1, §4.2, §4.3, §9.1 #4, #9

---

## Context

The current `MarkdownTheme` provides 4 hex colours (accent, syntax, codeForeground,
codeBackground) with `defaultLight` and `defaultDark` presets. The product discovery
interview revealed that the theme system must be significantly more flexible:

- Different locations within a single app (toogether) need different styles
- Themes must be dynamically loadable at runtime via JSON
- Each theme must define both Light and Dark variants
- Required controls go beyond colours: font size and line spacing at minimum

---

## Problem Statement

How should the theme system be architectured to support per-instance theming,
JSON serialization, and Light/Dark variants while remaining simple to use?

---

## Options Considered

### Option 1 – Extend Current 4-Colour System

Add more colour properties to the existing `MarkdownTheme` struct.

**Pros:** Minimal change, backward compatible
**Cons:** Doesn't address font size, spacing, or JSON loading requirements

### Option 2 – Full Theme System with JSON Schema ⭐

Redesign `MarkdownTheme` as a comprehensive, JSON-serializable theme structure:
- Colour palette (heading, body, accent, syntax, code, background, etc.)
- Typography (font size, line spacing, paragraph spacing)
- Light and Dark variants bundled together
- Codable for JSON import/export
- Per-instance (not just per-app)

**Pros:**
- Meets all interview requirements
- JSON-serializable enables runtime theme loading (toogether already uses JSON for styles)
- Per-instance theming enables different contexts within one app
- Light/Dark bundled per theme simplifies switching

**Cons:**
- Breaking change to `MarkdownTheme` API
- More properties to configure (mitigated by sensible defaults)
- Theme validation needed for JSON imports

### Option 3 – Protocol-Based Theme System

Define a `MarkdownTheming` protocol with default implementations.

**Pros:** Maximum flexibility, host apps can provide any implementation
**Cons:** Harder to serialize, more complex API surface

---

## Decision

**Chosen:** Option 2 – Full Theme System with JSON Schema

**Rationale:**
The product owner requires JSON-loadable, per-instance themes with Light/Dark variants.
This rules out a simple colour extension (Option 1) and protocol-based approach
(Option 3). A concrete Codable struct with sensible defaults provides the best balance
of power and simplicity.

---

## Proposed Schema

```swift
public struct MarkdownTheme: Codable, Sendable, Equatable {
    /// Display name of the theme
    public var name: String

    /// Light mode appearance
    public var light: Appearance

    /// Dark mode appearance
    public var dark: Appearance

    /// Typography settings (shared between Light and Dark)
    public var typography: Typography

    public struct Appearance: Codable, Sendable, Equatable {
        public var headingColor: String      // Hex, e.g. "#1A1A1A"
        public var bodyColor: String         // Hex
        public var accentColor: String       // Hex (links, tags)
        public var syntaxColor: String       // Hex (Markdown control chars)
        public var codeForeground: String    // Hex
        public var codeBackground: String    // Hex
        public var blockquoteColor: String   // Hex
        public var backgroundColor: String   // Hex (editor background)
    }

    public struct Typography: Codable, Sendable, Equatable {
        public var bodyFontSize: CGFloat     // Default: 17 (iOS body)
        public var headingScale: CGFloat     // H1 = bodyFontSize * headingScale
        public var lineSpacing: CGFloat      // Default: 4
        public var paragraphSpacing: CGFloat // Default: 8
    }
}
```

### JSON Example

```json
{
  "name": "Ocean Blue",
  "light": {
    "headingColor": "#1A1A1A",
    "bodyColor": "#333333",
    "accentColor": "#007AFF",
    "syntaxColor": "#8E8E93",
    "codeForeground": "#D63384",
    "codeBackground": "#F8F9FA",
    "blockquoteColor": "#6C757D",
    "backgroundColor": "#FFFFFF"
  },
  "dark": {
    "headingColor": "#F5F5F7",
    "bodyColor": "#D1D1D6",
    "accentColor": "#0A84FF",
    "syntaxColor": "#636366",
    "codeForeground": "#FF6B9D",
    "codeBackground": "#1C1C1E",
    "blockquoteColor": "#8E8E93",
    "backgroundColor": "#000000"
  },
  "typography": {
    "bodyFontSize": 17,
    "headingScale": 1.5,
    "lineSpacing": 4,
    "paragraphSpacing": 8
  }
}
```

---

## Migration Path

1. Keep current `MarkdownTheme` API working during transition
2. Add new `MarkdownTheme` with `light`/`dark`/`typography` structure
3. Provide `defaultLight` and `defaultDark` as computed properties for backward compat
4. Update consuming apps (toogether-app) in same PR (per ADR-0006/shared-ui rules)

---

## Invariants (Must Hold)

- `MarkdownTheme` must remain `Codable` and `Sendable`
- All colours must use hex strings (no UIColor/NSColor) for platform independence
- A valid JSON file must be decodable into a `MarkdownTheme`
- Default theme must produce readable output without any configuration

---

## Consequences

### Positive
- Per-instance theming enables different styles within one app
- JSON serialization enables runtime theme loading
- Typography controls enable better readability tuning
- Light/Dark bundled per theme simplifies automatic switching

### Negative / Trade-offs
- Breaking change to `MarkdownTheme` API
- Consuming apps must update their theme usage
- More properties to maintain and test

### Risks
- Invalid JSON themes could produce unreadable output
  **Mitigation:** Validate JSON imports, fall back to defaults for missing values

---

## Follow-up Actions

- [x] Redesign `MarkdownTheme` struct with new schema
- [x] Add JSON encoding/decoding tests
- [x] Update toogether-app theme usage
- [ ] Add theme validation (contrast ratios, font size bounds)
- [ ] Document theme JSON schema in README

---

## Supersedes / Superseded by

- **Supersedes:** Current 4-colour `MarkdownTheme` design
- **Superseded by:** N/A

---

## Related Code

- `shared-ui/Sources/AssistanceKit/Markdown/MarkdownTheme.swift`
- AK-013 in backlog

---

## References

- Interview §4.1 (Theming Flexibility), §4.2 (Custom Themes), §4.3 (Dark Mode)
- Interview §9.1 #4 (Theme System ADR), #9 (JSON Theme Schema ADR)
