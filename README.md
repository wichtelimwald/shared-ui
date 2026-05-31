# shared-ui (SharedUI)

Reusable SwiftUI building blocks for the `wichtelimwald/*` Apple apps —
**the foundation layer** consumed by every other UI spin-off.

> Spun off from [`wichtelimwald/assistance`](https://github.com/wichtelimwald/assistance)
> in 2026. See [`docs/decisions/ADR-0010-spinoff-from-monorepo.md`](docs/decisions/ADR-0010-spinoff-from-monorepo.md).

---

## Modules

This package ships the four foundational modules that don't have their
own repo:

- **Backgrounds** — animated/static reusable background views
- **Buttons** — branded button styles (`ActionButton`, `ScaledButtonStyle`)
- **Compatibility** — iOS 17/18/26 shims
- **Styles** — typography, color, spacing tokens

All modules ship under a single product `SharedUI`. Zero external
dependencies — Apple frameworks only.

### Sibling packages (separate repos)

The original `AssistanceKit` umbrella was split into four packages in
2026 (ADR-0012 in the mono-repo, ADR-0010 here):

| Package        | Repo                                           | Depends on |
|----------------|------------------------------------------------|------------|
| `CoverFlow`    | https://github.com/wichtelimwald/coverflow     | —          |
| `GlassOverlay` | https://github.com/wichtelimwald/glass-overlay | `SharedUI` |
| `MarkdownUI`   | https://github.com/wichtelimwald/markdown-ui   | —          |
| `SharedUI`     | https://github.com/wichtelimwald/shared-ui     | —          |

---

## Requirements

- Swift 5.9+
- macOS 14+ · iOS 17+
- Xcode 15+

---

## Usage

Add as a remote SwiftPM dependency:

```swift
.package(
    url: "https://github.com/wichtelimwald/shared-ui.git",
    .upToNextMajor(from: "0.1.0")
)
```

Depend on the `SharedUI` product from your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "SharedUI", package: "shared-ui"),
    ]
)
```

Then:

```swift
import SharedUI
```

> **Migrating from `AssistanceKit`?** Replace `import AssistanceKit` with
> `import SharedUI` in every file that uses Backgrounds/Buttons/Compatibility/Styles
> symbols. Files using CoverFlow/GlassOverlay/Markdown symbols need
> `import CoverFlow`/`import GlassOverlay`/`import MarkdownUI` instead.

---

## Build & Test

```bash
swift build
swift test
```

CI runs `swift build` + `swift test` on macOS and Linux on every push and
pull request to `main`/`develop`.

---

## Versioning

Semantic versioning. Consumers pin `upToNextMajorVersion`.

- **Patch** — bug fix, no API change
- **Minor** — additive API only, fully backward-compatible
- **Major** — any breaking change, requires an ADR

To cut a release after merging to `main`:

```bash
git checkout main && git pull
git tag -a vX.Y.Z -m "shared-ui vX.Y.Z"
git push origin vX.Y.Z
```

The `release.yml` workflow auto-generates GitHub Release notes from
commits since the previous tag.

---

## Repository Layout

```
Package.swift               SwiftPM manifest (product: SharedUI)
Sources/
  SharedUI/                 Backgrounds · Buttons · Compatibility · Styles
Tests/
  SharedUITests/            XCTest suite (smoke test on initial import)
docs/
  PROJECT-CONTEXT.md        package scope, consumers, design philosophy
  concepts/                 design concepts
  decisions/                ADRs (ADR-0010 = spin-off)
  plans/                    implementation plans
  lessons.md                accumulated learnings
  todo.md                   backlog
.github/
  copilot-instructions.md   global Copilot rules
  context-router.md         task → agent/skill mapping
  agents/                   Copilot agents
  skills/                   Copilot skills
  instructions/             mandatory instruction files (incl. API-stability rule)
  prompts/                  slash-command definitions
  workflows/                CI + Release
```

---

## Working with Copilot

This repository is set up for the **Copilot coding agent** with a curated
set of agents, skills, and execution rules. When you start a new task:

1. The agent consults [`.github/context-router.md`](.github/context-router.md)
   to pick the right agents and skills for the task type.
2. It follows [`.github/instructions/execution-rules.instructions.md`](.github/instructions/execution-rules.instructions.md)
   (no commits to `main`, plan before code, ADRs for decisions, **API
   stability is sacred**).
3. Active plans live under [`docs/plans/`](docs/plans/); the backlog is [`docs/todo.md`](docs/todo.md).

---

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

See [`LICENSE`](LICENSE).
