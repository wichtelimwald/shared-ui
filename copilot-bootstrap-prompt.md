# Bootstrap Prompt for the New `shared-ui` Repository

Use this prompt when you start your **first Copilot session** in the newly
created `wichtelimwald/shared-ui` repository (after running `migrate.sh`,
pushing the initial commit, and pushing the `v0.1.0` tag). Paste it into
Copilot Chat or open it as the body of your first task/issue.

---

> **Task:** Verify that this repository is correctly bootstrapped as the
> dedicated home of the `SharedUI` Swift package and complete any
> leftover migration items.
>
> **Context:**
> - This repo was created by `scripts/migrate-shared-ui/migrate.sh` in the
>   `wichtelimwald/assistance` mono-repo without preserving Git history.
>   See [`docs/decisions/ADR-0010-spinoff-from-monorepo.md`](docs/decisions/ADR-0010-spinoff-from-monorepo.md).
> - All Copilot infrastructure (`.github/agents/`, `.github/skills/`,
>   `.github/instructions/`, `.github/prompts/`, `.github/context-router.md`,
>   `.github/copilot-instructions.md`) is in place and simplified for a
>   single-package layout.
> - The package ships four foundational modules under the single
>   `SharedUI` product target: Backgrounds, Buttons, Compatibility,
>   Styles. Zero external dependencies. The three remaining
>   former-`AssistanceKit` modules (CoverFlow, GlassOverlay, Markdown)
>   live in their own sibling repos: `wichtelimwald/coverflow`,
>   `wichtelimwald/glass-overlay`, `wichtelimwald/markdown-ui`.
> - This repo is consumed by `wichtelimwald/org-spirits` (and will be by
>   the remaining mono-repo apps) as a remote SwiftPM dependency pinned
>   `upToNextMajorVersion` from `v0.1.0` (the migration tag). The
>   product name `SharedUI` replaces the previous umbrella name
>   `AssistanceKit` — consumers must update their `import` lines.
> - The API-stability rule (`.github/instructions/execution-rules.instructions.md`
>   §9) is **mandatory** — every `public` symbol is a contract.
>
> **Please, in order, each as its own PR:**
>
> 1. **Smoke build & test.** Run
>    ```
>    swift build
>    swift test
>    ```
>    on macOS. If either fails, open a plan
>    (`docs/plans/plan-001-post-migration-fix.md`) and resolve before
>    proceeding.
>
> 2. **Linux build sanity.** The CI workflow also builds on Linux. Confirm
>    the CI run from the initial push is green on both `macos-15` and
>    `ubuntu-latest`. If Linux fails (e.g. unconditional UIKit imports
>    leaked into a target that should be cross-platform), open a plan to
>    fix or to scope the package macOS-only via `Package.swift` platforms.
>
> 3. **SwiftLint clean (if `.swiftlint.yml` was copied).** Run
>    `swiftlint lint .` and fix newly surfaced warnings. If the package
>    has no `.swiftlint.yml`, that's fine — the CI job is conditional and
>    will be skipped.
>
> 4. **DocC pass.** Verify every `public` symbol has a doc comment with
>    a brief description and parameter docs where applicable. Open a
>    plan if the gap is large.
>
> 5. **Repository hygiene.**
>    - `CODEOWNERS` (if multi-collaborator).
>    - Branch protection on `main` (required checks: `Build & Test (macos-15)`,
>      `Build & Test (ubuntu-latest)`; require at least 1 review).
>    - Confirm the `v0.1.0` tag is pushed and a GitHub Release was created
>      by the `release.yml` workflow (or create one manually).
>    - Issue templates and PR template render correctly.
>
> 6. **Domain-context check.** Read `docs/PROJECT-CONTEXT.md` and confirm
>    it still accurately describes the package today. If it references
>    mono-repo paths or other sub-projects, fix.
>
> 7. **Backlog & plans review.** Triage `docs/todo.md` and any
>    `docs/plans/` entries. Archive anything no longer relevant; pick the
>    next priority. Add a backlog entry for "migrate remaining mono-repo
>    consumers off local `../shared-ui` reference" — that work happens in
>    the mono-repo, not here, but it's worth tracking the dependency.
>
> **Hard rules:**
> - No commits to `main`. Each step is a focused PR.
> - Follow `.github/instructions/execution-rules.instructions.md`.
> - **No breaking `public` API change without ADR + explicit user
>   approval + major-version bump.**
> - If anything is ambiguous (e.g. missing secrets, signing config), stop
>   and ask.
