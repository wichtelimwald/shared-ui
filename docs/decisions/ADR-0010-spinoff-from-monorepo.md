# ADR-0010 — Spin-off `shared-ui` into a Dedicated Repository (post-split)

**Status:** Accepted
**Date:** 2026-05-20
**Supersedes:** the 2026-05-18 draft (umbrella product `AssistanceKit`)
**Related:** ADR-0012 in `wichtelimwald/assistance` (mono-repo split strategy)

## Context

`shared-ui` originated inside the Swift mono-repo `wichtelimwald/assistance`
as a single SwiftPM umbrella product `AssistanceKit` shipping seven modules:
CoverFlow, GlassOverlay, Markdown, Backgrounds, Buttons, Compatibility,
Styles. Every consumer (toogether, studienmap, earworm-hunt, …) added the
package via a local path reference and imported `AssistanceKit` to pull in
the whole umbrella.

Spinning out a single consumer (`org-spirits`) forced the question of how
to consume `shared-ui`. The first iteration of this ADR chose **S2** —
extract the umbrella package to its own repo and consume it as a remote
SPM dependency — and kept the `AssistanceKit` umbrella intact.

After landing S2, the user raised a follow-up concern: the umbrella
forces a full version bump and re-test of every consumer whenever any one
module changes, even when the changed module is unrelated to that
consumer's usage. Two of the modules (CoverFlow, Markdown) are also
substantially larger than the rest and have very different release cadences.

## Decision

Split the `AssistanceKit` umbrella into **four** standalone SwiftPM
packages, each in its own GitHub repository, each with its own semver
release line:

| Repo                                             | Product        | Depends on  |
|--------------------------------------------------|----------------|-------------|
| `wichtelimwald/coverflow`                        | `CoverFlow`    | —           |
| `wichtelimwald/glass-overlay`                    | `GlassOverlay` | `SharedUI`  |
| `wichtelimwald/markdown-ui`                      | `MarkdownUI`   | —           |
| `wichtelimwald/shared-ui` *(this repo)*          | `SharedUI`     | —           |

This repository ships the four foundational modules that do **not** have
their own repo: **Backgrounds, Buttons, Compatibility, Styles**. The
SwiftPM product is renamed `SharedUI` (was `AssistanceKit`) — consumers
must update their `import` lines as part of the migration.

This repo:

1. Contains exactly one SwiftPM package, product `SharedUI`, zero external
   dependencies.
2. Releases semver-tagged versions. The migration creates `v0.1.0` as the
   initial tag (equivalent to the post-split state at spin-off time).
3. Adopts the same simplified single-package Copilot infrastructure as
   every other split repo (single-project execution rules, package CI,
   release workflow, mandatory API-stability rule).
4. Is a **prerequisite** for `wichtelimwald/glass-overlay`, which depends
   on the Buttons styles shipped here.

## Alternatives Considered

| Option | Verdict |
|--------|---------|
| **Four standalone packages, this repo holds the foundation** | **chosen** — independent release cadence, narrower public API per repo, smaller blast radius |
| Keep the umbrella `AssistanceKit` as one repo | rejected — every change re-versions every consumer |
| Split into seven repos (one per module) | rejected — overhead of administering 7 repos outweighs benefit; Backgrounds/Buttons/Compatibility/Styles are small and tightly related |
| Split into two repos (CoverFlow+Markdown vs. rest) | rejected — CoverFlow and Markdown have nothing in common; same problem as the umbrella |

## Consequences

### Positive
- A `SharedUI` patch release ships without forcing CoverFlow/Markdown
  consumers to re-test.
- Public API contracts are surfaced at four narrow boundaries instead of
  one wide umbrella.
- Other spin-offs (GlassOverlay) can pin a specific SharedUI major and
  upgrade on their own timeline.

### Negative
- Loss of Git history (accepted — original history remains available in
  `wichtelimwald/assistance`).
- Four repos to administer (CI, branch protection, CODEOWNERS,
  Dependabot). Mitigated by the shared
  `scripts/lib/swift-package-templates/` infrastructure.
- Consumers that use multiple former-umbrella modules now need multiple
  SPM entries and multiple `import` lines. Mitigated by the consumer-
  rewrite scripts (see ADR-0012 in the mono-repo).

## Migration Mechanics

See the executable migration script and runbook in the source mono-repo:
<https://github.com/wichtelimwald/assistance/blob/main/scripts/migrate-shared-ui/HOW2MIGRATE-SHARED-UI.md>

## First-Consumer Cutover

`org-spirits` is the first consumer of the remote
`wichtelimwald/shared-ui` package. Its migration script
(`scripts/migrate-org-spirits/migrate.sh` in the mono-repo) rewrites the
local SPM reference to four remote ones (CoverFlow, GlassOverlay,
MarkdownUI, SharedUI), pinned `upToNextMajorVersion` from `0.1.0`.
