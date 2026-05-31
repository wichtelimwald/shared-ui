# ADR-0006 – studienmap-app Migration to AssistanceKit Markdown

**Date:** 2026-04-12
**Status:** Accepted
**Author(s):** Copilot (based on product discovery interview)
**Source:** Interview §5.4, §9.1 #5

---

## Context

studienmap-app has its own Markdown implementation (`MarkdownParser` +
`LiveMarkdownView`) that was built independently of AssistanceKit. The product
discovery interview confirmed that migration to AssistanceKit Markdown is planned,
requiring a documented analysis of delta requirements.

---

## Problem Statement

Should studienmap-app migrate its Markdown implementation to AssistanceKit, and
if so, what differences and requirements must be addressed?

---

## Options Considered

### Option 1 – Keep Parallel Implementations

Each app maintains its own Markdown code.

**Pros:** No migration effort, no risk of regression
**Cons:** Duplicated effort, features diverge, bugs must be fixed in two places

### Option 2 – Migrate to AssistanceKit ⭐

Replace studienmap-app's Markdown implementation with `import AssistanceKit`.

**Pros:** Single source of truth, shared improvements, consistent UX
**Cons:** Migration effort, must verify feature parity, potential regressions

### Option 3 – Partial Migration (Parsing Only)

Use AssistanceKit's parsing layer, keep studienplan's own rendering.

**Pros:** Lower risk, parsing is well-tested
**Cons:** Still two rendering implementations, limited benefit

---

## Decision

**Chosen:** Option 2 – Full Migration to AssistanceKit

**Rationale:**
The product owner confirmed migration is planned. Maintaining two independent Markdown
implementations increases maintenance overhead. The interview explicitly stated that
differences and requirements should be documented in a dedicated ADR (this document).

---

## Delta Requirements (studienmap-app vs. AssistanceKit)

The following differences must be resolved before or during migration:

| Area | studienmap-app | AssistanceKit | Gap | Action |
|------|-----------------|---------------|-----|--------|
| Parser | `MarkdownParser` (custom) | `MarkdownBlockParser` + `MarkdownSectionParser` | Feature comparison needed | Audit both parsers |
| Rendering | `LiveMarkdownView` (SwiftUI) | `MarkdownDocumentView` (SwiftUI) | Different component structure | Map features |
| Editor | Form-based TextEditor | `MarkdownEditorView` (UITextView) | Different editing approach | Evaluate UITextView for studienplan |
| Theming | Hardcoded styles | `MarkdownTheme` (Codable) | studienplan needs green/academic theme | Create studienplan theme |
| Title handling | No title field — title from `# heading` | Standard Markdown | Compatible | No action needed |
| Section editing | Not used | `MarkdownSectionParser` | studienplan may benefit | Evaluate |
| Tags | Tag system in plans | Tag detection in parser | Need feature parity check | Audit |
| Private notes | `🔒` indicator, DisclosureGroup | Not applicable | App-specific feature | Keep in studienplan |

---

## Migration Strategy

### Phase 1 — Audit (Effort: S)
- Compare `MarkdownParser` and `MarkdownBlockParser` feature-by-feature
- Document any studienplan-specific features not in AssistanceKit
- Identify any AssistanceKit features studienplan doesn't need

### Phase 2 — Gap Closure (Effort: M)
- Add any missing features to AssistanceKit
- Create studienplan-specific `MarkdownTheme`
- Ensure `MarkdownDocumentView` can replace `LiveMarkdownView`

### Phase 3 — Migration (Effort: M)
- Replace `import` statements
- Remove studienplan's local Markdown files
- Update tests to use AssistanceKit
- Verify all 562+ tests still pass

---

## Invariants (Must Hold)

- AssistanceKit must not gain studienplan-specific features — keep it generic
- Any features only needed by studienplan stay in studienplan (e.g., private notes `🔒`)
- Migration must not break existing studienplan functionality
- All existing studienplan Markdown tests must pass after migration

---

## Consequences

### Positive
- Single Markdown implementation across the mono-repo
- studienplan benefits from all future AssistanceKit improvements
- Reduced overall maintenance burden

### Negative / Trade-offs
- Migration effort (estimated M across 2–3 sessions)
- Risk of subtle rendering differences during transition
- Must update studienplan in lockstep with AssistanceKit changes

### Risks
- Feature parity gaps discovered during audit
  **Mitigation:** Phase 1 audit before any code changes
- Regression in studienplan UX
  **Mitigation:** Visual comparison testing during Phase 3

---

## Follow-up Actions

- [ ] Conduct parser feature comparison audit (AK-030)
- [ ] Create studienplan-specific `MarkdownTheme`
- [ ] Create migration plan as `studienmap-app/docs/plans/plan-NNN-*.md`
- [ ] Execute migration in a dedicated branch

---

## Supersedes / Superseded by

- **Supersedes:** N/A
- **Superseded by:** N/A

---

## Related Code

- `shared-ui/Sources/AssistanceKit/Markdown/` (target)
- `studienmap-app/StudienMap/Core/MarkdownParser.swift` (source to replace)
- `studienmap-app/StudienMap/Views/LiveMarkdownView.swift` (source to replace)
- AK-030 in backlog

---

## References

- Interview §5.4 (studienplan Migration)
- Interview §9.1 #5 (studienplan Migration ADR)
