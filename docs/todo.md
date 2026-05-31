# SharedUI — Backlog

Task-ID-Prefix: **SUI-**

---

## 🟢 Ready (unblocked)

| ID | Task | Priority | Effort | Notes |
|----|------|----------|--------|-------|
| SUI-001 | Migrate remaining mono-repo consumers off local `../shared-ui` path reference | P1 | M | Work happens in `wichtelimwald/assistance`; tracked here for visibility |
| SUI-002 | Add more unit tests for Styles module (NeonTextStyle constants) | P3 | S | Currently only smoke test |
| SUI-003 | Add more unit tests for Compatibility module (onChangeCompat) | P3 | S | UI/SwiftUI testing |

---

## 📋 Backlog

### Infrastructure

| ID | Task | Priority | Effort | Blocker | Notes |
|----|------|----------|--------|---------|-------|
| SUI-010 | Evaluate updating swift-tools-version from 5.9 to 6.0 | P2 | S | — | Swift 6 strict concurrency is now stable |
| SUI-011 | Add macOS-only visionOS platform target | P3 | S | — | Only if a consumer requests it |

### API

| ID | Task | Priority | Effort | Blocker | Notes |
|----|------|----------|--------|---------|-------|
| SUI-020 | Review `AnimationConstants.swift` CoverFlow-specific presets | P2 | S | — | `coverFlowSnap`, `cardGap`, `cardTransfer` reference CoverFlow concepts; may move to `wichtelimwald/coverflow` |
| SUI-021 | Add `ViewModifier` convenience for `BackgroundPicture` | P3 | S | — | Ergonomics improvement |

### Documentation

| ID | Task | Priority | Effort | Blocker | Notes |
|----|------|----------|--------|---------|-------|
| SUI-030 | Write DocC article for module overview | P3 | S | — | Top-level `SharedUI.md` catalog page |

---

## ✅ Done

| ID | Task | Completed | PR/Session |
|----|------|-----------|------------|
| — | Spin off `shared-ui` from `wichtelimwald/assistance` mono-repo | 2026-05-31 | ADR-0010, migrate.sh |
| — | Rename product from `AssistanceKit` to `SharedUI` | 2026-05-31 | Initial import |
| — | Tag and release `v0.1.0` | 2026-05-31 | release.yml |
| — | Set up Copilot infrastructure (.github/agents, instructions, workflows) | 2026-05-31 | Initial import |
| SUI-100 | Post-migration verification: fix CI, docs, and backlog | 2026-05-31 | This PR |
