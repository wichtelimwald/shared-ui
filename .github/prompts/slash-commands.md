# Slash Commands

> **Reference document** — not auto-loaded. Read this when user types a `/` command.

The user may start a message with one of the commands below.
Treat the command as **the full instruction set** — execute the defined workflow
immediately without asking for clarification, unless a required parameter is missing.

> **Scope rule:** All project-scoped commands operate on the **current project**
> (determined by the branch name, active plan, or user context). If the target project
> is ambiguous, ask once before proceeding.

---

## Command Reference

| Command | Purpose | Scope |
|---------|---------|-------|
| `/continue` | Resume work from plans / backlog | Project |
| `/optimize` | Deep-analyse and improve the project | Project |
| `/status` | Show project overview at a glance | Project |
| `/review` | Full code review of current changes | PR / Branch |
| `/test` | Run tests, analyse failures, fix | Project |
| `/clean` | Lint, format, remove dead code | Project |
| `/debug <symptom>` | Systematic root-cause analysis | Project |
| `/plan` | Show or create an implementation plan | Project |
| `/backlog` | Show, triage, and manage todo items | Project |
| `/health` | Project health check (deps, coverage, build) | Project |
| `/wrap` | End session cleanly | Session |
| `/release` | Pre-release checklist and preparation | Project |
| `/new <project-name>` | Bootstrap a new sub-project | Mono-repo |
| `/docs` | Audit and improve documentation | Project |
| `/sparc` | 5-phase spec-driven development with quality gates | Project |
| `/testgen` | Find missing tests and generate stubs | Project |
| `/jujutsu` | Analyse git diff: risk score, change classification, reviewer suggestions | PR / Branch |
| `/appstore` | Generate a ChatGPT / Claude prompt for App Store submission | Project |

---

## Command Definitions

### `/continue`

> Resume where we left off. Pick up the next piece of work and start implementing.

**Workflow:**

1. **Check active plans** → `<project>/docs/plans/plan-*.md` with status 🟢 Active.
   - If found → read it, implement the **next open step** (⬜ or 🟡), update progress.
2. **If plan is complete** → archive to `plans/implemented/`, then continue to step 3.
3. **Check concepts** → `<project>/docs/concepts/` (excluding `implemented/`).
   - For each concept: verify if fully implemented.
   - If fully implemented → move to `concepts/implemented/` with a completion note
     at the top: `> ✅ **Implemented** — YYYY-MM-DD. See <PR or code link>.`
   - If partially implemented → add remaining items to `docs/todo.md` (if not already there).
4. **Check backlog** → `<project>/docs/todo.md`.
   - Verify completed items are marked `[x]`.
   - Identify the highest-priority unblocked items.
5. **Create a new plan** from the top-priority backlog items (3–8 steps).
6. **Start implementing** the first step of the new plan.

**Output:** Brief summary of what was found and what will be done, then begin work.

---

### `/optimize`

> Deep-analyse the current project for errors, weaknesses, and improvement opportunities.

**Workflow:**

1. **Load project context** → `copilot-instructions.md`, `docs/plans/`, `docs/todo.md`,
   `docs/lessons.md`, `docs/decisions/`.
2. **Architecture analysis:**
   - Review module boundaries and layer dependencies (Domain → Data → Presentation).
   - Check for SOLID violations, especially Single Responsibility and Dependency Inversion.
   - Identify circular dependencies or leaky abstractions.
3. **Redundancy scan:**
   - Find duplicate or near-duplicate implementations (views, models, utilities).
   - Identify dead code, unused imports, unreachable paths.
4. **Technical debt audit:**
   - Collect all `// TODO`, `// FIXME`, `// HACK`, `// TODO(debt):` markers.
   - Cross-reference with `docs/todo.md` to find untracked debt.
   - Check for deprecated API usage.
5. **Code quality check:**
   - Analyse largest files (> 300 lines) for refactoring opportunities.
   - Check test coverage gaps.
   - Verify error handling patterns (no force-unwraps, proper typed errors).
6. **Performance & security quick-scan:**
   - Identify obvious performance anti-patterns (main-thread blocking, N+1 queries).
   - Check for insecure storage, missing input validation.
7. **Compile findings** into a prioritised optimisation plan (P1/P2/P3).
8. **Present summary** with key findings and the proposed plan.
9. **Wait for user approval** before starting implementation.

**Principles:** KISS · DRY · SOLID · existing conventions.
**Output:** Summary of findings + proposed optimisation plan. No code changes until approved.

---

### `/status`

> Quick overview of the current project state.

**Workflow:**

1. Show: current branch, target project, git status (uncommitted changes).
2. Show: active plan (if any) with progress (e.g. "Plan 040: 3/7 steps done").
3. Show: open P1/P2 items from `docs/todo.md` (count + top 5).
4. Show: recent commits on current branch (last 5).
5. Show: unimplemented concepts (count).
6. Show: any `🟡 In progress` steps across plans.

**Output:** Compact dashboard, no code changes.

---

### `/review`

> Full code review of the current uncommitted or branch changes.

**Workflow:**

1. Run `git diff` (staged + unstaged) to see current changes.
2. Invoke the `code-review` agent on all changed files.
3. Invoke the `security-audit` agent if changes touch auth, storage, or networking.
4. Invoke the `architecture-review` agent if changes touch module boundaries.
5. Check against the PR Checklist in `.github/copilot-instructions.md`.
6. Present findings: issues, suggestions, and a pass/fail verdict per checklist item.

**Output:** Structured review with actionable items. Fix critical issues immediately if user agrees.

---

### `/test`

> Run tests, analyse any failures, and fix them.

**Workflow:**

1. Determine test command for current project (`swift test`, `xcodebuild test`, etc.).
2. Run the full test suite.
3. If **all pass** → report summary (count, duration) and stop.
4. If **failures** → for each failing test:
   - Show the failure message and location.
   - Analyse root cause (code bug vs. test bug vs. environment issue).
   - Propose and apply a fix.
5. Re-run tests to verify fixes.
6. If new failures appear → repeat (max 3 cycles).

**Output:** Test results summary. Fixes applied if needed.

---

### `/clean`

> Clean up the codebase: lint, format, remove dead code.

**Workflow:**

1. Run SwiftLint (if configured) → fix auto-fixable issues.
2. Scan for unused `import` statements → remove them.
3. Scan for dead code (unused private functions, unreachable branches) → remove.
4. Verify `// TODO` / `// FIXME` markers are tracked in `docs/todo.md`.
5. Check file organisation (files in correct directories, naming conventions).
6. Run build to verify nothing broke.

**Output:** Summary of changes made. Commit with descriptive message.

---

### `/debug <symptom>`

> Systematic root-cause analysis for a specific issue.

**Parameter:** `<symptom>` — description of the bug, crash, or unexpected behaviour.

**Workflow:** (follows `.github/skills/systematic-debugging.md`)

1. **Reproduce** — understand the exact symptom and conditions.
2. **Hypothesise** — list 3–5 most likely causes based on the symptom.
3. **Investigate** — for each hypothesis, check code, logs, and tests.
4. **Isolate** — narrow down to the root cause with evidence.
5. **Fix** — apply the minimal correct fix.
6. **Verify** — run tests, confirm the symptom is resolved.
7. **Prevent** — add a regression test if none exists.
8. **Document** — add a lesson to `docs/lessons.md` if the bug was non-obvious.

**Output:** Root cause explanation, fix applied, regression test added.

---

### `/plan`

> Show or create an implementation plan for the current project.

**Workflow:**

1. **If active plan exists** → display it with current progress.
2. **If no active plan** → scan backlog (`docs/todo.md`) and concepts, then:
   - Select 3–8 highest-priority unblocked items.
   - Create a new plan following the format in `implementation-planning.instructions.md`.
   - Present the plan for review.
3. **If user provides a topic** (e.g. `/plan avatar redesign`) → create a focused plan
   around that topic, pulling relevant backlog items.

**Output:** The plan (existing or newly created). No implementation until user says go.

---

### `/backlog`

> Show, triage, and manage the project backlog.

**Workflow:**

1. Read `<project>/docs/todo.md`.
2. Display summary: total items by priority (P1/P2/P3), open vs. done.
3. Check for:
   - Completed items not yet marked `[x]`.
   - Duplicate or overlapping items.
   - Items missing priority or task IDs.
   - Stale items (> 3 months without progress).
4. Suggest re-prioritisation if needed.
5. Apply approved changes to `docs/todo.md`.

**Output:** Backlog summary with suggested actions.

---

### `/health`

> Comprehensive project health check.

**Workflow:**

1. **Build** — does the project compile cleanly? Any warnings?
2. **Tests** — run tests, report pass/fail count and coverage (if available).
3. **Lint** — run SwiftLint, report violation count.
4. **Dependencies** — check for outdated or vulnerable dependencies.
5. **Documentation** — check for undocumented public APIs.
6. **Tech debt** — count `TODO`/`FIXME` markers, list untracked ones.
7. **Plans** — is there an active plan? Is it stale?
8. **Backlog** — how many open P1/P2 items remain?

**Output:** Health report card with pass/warn/fail per category.

---

### `/wrap`

> End the current session cleanly.

**Workflow:**

1. Run build + tests to verify current state is green.
2. Update active plan progress (mark completed steps ✅, note in-progress 🟡).
3. Update `docs/todo.md` if items were completed or discovered.
4. Add lessons learned to `docs/lessons.md` (or confirm none).
5. Call `store_memory` for any new conventions, patterns, or architecture decisions discovered this session (see self-management.md §3 triggers).
6. Commit all changes with a descriptive message.
7. Write Session Summary (agents used, decisions made, lessons, next steps).
8. Push via `report_progress`.

**Output:** Session Summary.

---

### `/release`

> Pre-release preparation and checklist.

**Workflow:**

1. Run full build → must be clean (zero warnings if possible).
2. Run full test suite → must be green.
3. Run `security-audit` agent → no critical issues.
4. Run `code-review` agent on all changes since last release.
5. Check `docs/todo.md` for any P1 blockers.
6. Update `CHANGELOG.md` with new entries.
7. Verify version numbers are bumped appropriately.
8. Present release readiness summary.

**Output:** Release readiness report. No tagging/publishing without user approval.

---

### `/new <project-name>`

> Bootstrap a new sub-project in the mono-repo.

**Parameter:** `<project-name>` — name of the new project (kebab-case).

**Workflow:** (follows `.github/skills/new-project-setup.md`)

1. Copy `template-project/` to `<project-name>/`.
2. Rename and configure project files.
3. Create `<project-name>/copilot-instructions.md`.
4. Create `<project-name>/docs/todo.md` with initial backlog.
5. Create `<project-name>/docs/plans/` directory.
6. Update CI if needed.
7. Run initial build to verify setup.

**Output:** New project scaffolded and ready for development.

---

### `/docs`

> Audit and improve project documentation.

**Workflow:**

1. Check all public APIs for DocC documentation.
2. Verify `copilot-instructions.md` is up to date.
3. Check `docs/decisions/` for any ADRs that need updating.
4. Verify README accuracy.
5. Check `docs/concepts/` for stale or unimplemented concepts.
6. Present a documentation gap report.
7. Fix gaps if user approves.

**Output:** Documentation audit report with actionable items.

---

## Combining Commands

Commands can be combined in natural language:

- `/continue` then `/wrap` → "Pick up work, implement what you can, then wrap up."
- `/optimize` on a specific area → `/optimize the avatar module`
- `/test` after `/clean` → "Clean up, then make sure tests still pass."

If the user types just the command with no additional context, execute the full workflow
as defined above. If the user adds context after the command, use it to narrow the scope.

---

### `/sparc`

> Stateful 5-phase spec-driven development with mandatory quality gates.
> Phases: Specification → Pseudocode → Architecture → Refinement → Completion.
>
> Use subcommands to drive the workflow. State is stored via `store_memory`
> (namespace `sparc-state`, key `current-phase-<slug>`).

**Subcommands:**

#### `/sparc init <feature>`

Initialise a new SPARC workflow for `<feature>`:

1. Create a feature slug (lowercase, hyphenated).
2. Store workflow state via `store_memory`:
   - Key: `sparc-state:current-phase-<slug>`
   - Value: `{ phase: 1, phaseName: "Specification", feature: "<feature>", startedAt: "<ISO>", gateAttempts: 0, artifacts: [] }`
3. Store phase-1 artifact scaffold via `store_memory`:
   - Key: `sparc-phases:spec-<slug>`
   - Value: `{ status: "pending", requirements: [], acceptanceCriteria: [], constraints: [], edgeCases: [] }`
4. Display: "SPARC workflow initialised for **<feature>**. Current phase: **1 – Specification**.
   Use `/sparc status` to check progress or begin with `/sparc advance`."

#### `/sparc status`

Show the current SPARC state for the active feature:

1. Read state from memory (`sparc-state:current-phase-<slug>`).
2. Display:
   - Feature name, current phase number and name.
   - Gate attempt count, time in phase (if startedAt is set).
   - Progress bar: `[=====>    ] Phase 3/5 — Architecture`
3. List gate history (any previous `store_memory` entries under `sparc-gates:<slug>`).

#### `/sparc advance`

Attempt to pass the current gate and advance to the next phase:

1. Read current state from memory.
2. Run the gate check for the **current phase**:

   | Phase | Gate criteria — ALL must be met | Agent spawned |
   |-------|----------------------------------|---------------|
   | 1 – Specification | ≥ 3 acceptance criteria defined · explicit constraints listed · edge cases identified · non-goals stated | `researcher` |
   | 2 – Pseudocode | All ACs covered in pseudocode · error paths explicit · edge cases handled · complexity annotated | `planner` |
   | 3 – Architecture | All constraints addressed · typed API contracts · no circular deps · test strategy defined | `system-architect` |
   | 4 – Refinement | All ACs have passing tests · code review passed · ≥ 80 % test coverage on new code · zero force-unwraps | `code-review` + `tester` |
   | 5 – Completion | Full test suite green · docs complete · deployment checklist verified · traceability matrix complete · `docs/todo.md` updated · `docs/lessons.md` updated | `documentation-review` |

3. Store gate result via `store_memory` (`sparc-gates:<slug>-phase<N>`).
4. **If gate passes:**
   - Increment phase in state, update `store_memory`.
   - Display: "Gate **passed** ✅. Advancing to Phase {N} — {PhaseName}."
   - If phase was 5: "SPARC workflow **complete** for {feature}. All gates passed."
5. **If gate fails:**
   - Increment `gateAttempts` in state, update `store_memory`.
   - Display: "Gate **failed** ❌. Blockers:" followed by the list of failing criteria.
   - Suggest specific actions to resolve each blocker before re-running `/sparc advance`.

#### `/sparc phase <n>`

Jump to a specific phase (re-entry or iteration):

1. Validate `<n>` is 1–5 (or aliases `spec`, `pseudo`, `arch`, `refine`, `complete`).
2. Update state in memory.
3. If jumping **forward** (skipping gates), display a warning:
   "⚠️ Jumping forward skips gate checks. Run `/sparc advance` from previous phases to ensure quality."
4. Display: "Phase set to **{N} – {PhaseName}** for {feature}."

#### `/sparc report`

Generate a full SPARC traceability report:

1. Read all state from memory for the active feature.
2. Output a structured report:

   ```markdown
   # SPARC Report: <Feature>

   ## Phase Summary
   | Phase | Status | Gate | Attempts | Duration |
   |-------|--------|------|----------|----------|
   | 1 – Specification | Complete | ✅ Passed | 1 | 2h |
   | 2 – Pseudocode    | Complete | ✅ Passed | 2 | 3h |
   | 3 – Architecture  | In Progress | — | 0 | 1h |
   | 4 – Refinement    | Pending | — | — | — |
   | 5 – Completion    | Pending | — | — | — |

   ## Specification
   - Requirements: [list]
   - Acceptance Criteria: [list]
   - Constraints: [list]

   ## Pseudocode
   - Algorithms: [summary]
   - Complexity annotations: [summary]

   ## Architecture
   - API contracts: [summary]
   - Bounded contexts / modules: [list]

   ## Acceptance Criteria Traceability
   | AC | Pseudocode Coverage | Test | Status |
   |----|---------------------|------|--------|
   | AC-1: … | ✅ | test_xxx | ✅ Pass |

   ## Gate History
   <chronological gate attempts with pass/fail details>
   ```

**Output:** Working feature with tests, updated backlog, documented decisions.

---

### `/testgen [<file-or-module>]`

> Proactively find missing test coverage and generate test stubs for untested code.
> Optional argument: a Swift file path (`Sources/Foo/Bar.swift`) or module/type name (`OrderService`)
> to scope generation to that target. Without an argument, scan the whole project.

**Workflow:**

1. **Scope** — if `<file-or-module>` is provided, restrict steps 2–5 to that file or to files
   declaring the named type/module; otherwise scan the entire target project.
2. **Scan for testable types** — find all `struct`, `class`, `actor`, and `func` in the scoped set.
3. **Identify untested files** — compare source files with test files; flag files with no corresponding `*Tests.swift`.
4. **Coverage gap analysis** — for each tested file, check for:
   - Public/internal functions with no test.
   - Error paths with no test.
   - Edge cases (empty input, nil, boundary values) with no test.
5. **Prioritise gaps** — rank by: critical business logic > error paths > edge cases > happy paths.
6. **Generate test stubs (TDD London School / mock-first)** — for the top gaps, generate `XCTestCase` stubs:
   - Correct naming: `test_<unit>_<scenario>_<expectedResult>` with `throw XCTSkip("Not yet implemented")` bodies (skip — not fail — so accidental commits don't break CI).
   - Mock collaborators via protocol-based fakes (no real network, persistence, or filesystem).
   - Cover happy path, edge cases, **and** error paths for every public function.
7. **Report findings** — present:
   - Count of untested files.
   - Top 5 highest-risk gaps.
   - Generated stubs (ready to paste).
8. **Update backlog** — add remaining gaps as `todo.md` entries if not already tracked.

**Output:** Test gap report + generated stubs. No tests are committed without user approval.

---

### `/jujutsu`

> Analyse the current git diff: risk scoring, change classification, and reviewer recommendations.
> Run this **before** `/review` to calibrate review depth and route to the right people.

**Workflow:**

1. Run `git diff HEAD` (or `git diff <base>..HEAD` for the current branch) to capture all changes.
2. **Classify the change type** based on the files and content:

   | Change Type | Indicators |
   |-------------|------------|
   | `feat` | New files, new public API surface, new user-visible behaviour |
   | `fix` | Bug fixes, error-path corrections |
   | `refactor` | Internal restructuring without behaviour change |
   | `chore` | Build config, dependencies, CI, scripts |
   | `docs` | Documentation, comments, ADRs only |
   | `test` | Test files only |
   | `perf` | Performance optimisations |
   | `security` | Auth, encryption, secrets handling, input validation |

3. **Score the risk** using this rubric:

   | Dimension | 🔴 High | 🟡 Medium | 🟢 Low |
   |-----------|---------|-----------|--------|
   | Persistence / data model | Modified | Related | Unrelated |
   | Auth / security boundary | Modified | Related | Unrelated |
   | Public API surface | Breaking change | Additive | None |
   | Test coverage of changes | < 50 % | 50–80 % | > 80 % |
   | Number of files changed | > 20 | 5–20 | ≤ 5 |
   | Churn in critical modules | Yes | Partial | No |

   Overall risk = highest single-dimension score (one 🔴 → overall 🔴).

4. **Recommend reviewers** based on risk:
   - 🔴 High → architecture-review + security-audit agents required.
   - 🟡 Medium → code-review agent; security-audit if auth/storage touched.
   - 🟢 Low → code-review agent only.

5. **Output:**

   ```markdown
   ## Jujutsu Analysis

   **Change Type:** feat / fix / refactor / …
   **Risk Level:** 🔴 High / 🟡 Medium / 🟢 Low

   ### Risk Breakdown
   | Dimension | Score | Detail |
   |-----------|-------|--------|
   | Persistence | 🟢 Low | No model changes |
   | Public API  | 🟡 Medium | 2 additive protocol methods |
   | Test coverage | 🔴 High | New service has no tests yet |
   | …

   ### Affected Files (N total)
   - `path/to/file.swift` — <one-line summary of change>

   ### Reviewer Recommendations
   - `code-review` — mandatory
   - `security-audit` — ⚠️ touches Keychain access
   ```

**Output:** Risk report with recommended agents. No code changes.

---

### `/appstore`

> Generate a ready-to-use ChatGPT / Claude prompt that guides the user through a
> complete App Store submission for the current iOS project.
> The prompt is pre-filled with all known technical details, feature descriptions,
> privacy information, and localisation data gathered from the project's sources.

> ⚠️ **This command is READ-ONLY. Do NOT create, write, or modify any files.**
> The only permitted write operation is appending a backlog entry to `docs/todo.md`
> (step 4). No fastlane files, no config files, no setup scripts — nothing else.
> The entire purpose of this command is to **generate a text prompt** for the user
> to paste into ChatGPT or Claude. All work happens in-memory; the output is chat text.

**Workflow:**

1. **Identify the target project** from the branch name (use global scope rule).
2. **Gather project context** — **read** (do not create or modify) the following without asking the user:
   - `<project>/copilot-instructions.md` — tech stack, architecture, bundle ID,
     minimum OS, audio/permission entitlements, localisation list, privacy model.
   - `<project>/docs/concepts/*.md` — concept document(s) describing the app's
     purpose, positioning, and target audience.
   - `<project>/docs/decisions/ADR-*.md` — architectural decisions relevant to
     reviewer notes (permissions rationale, background audio justification, etc.).
   - `<project>/docs/todo.md` — check whether an App Store submission item already exists.
   - `<project>/fastlane/Snapfile` (if present and already exists) — canonical locale list for
     keyword localisation coverage. **Do NOT create this file or any other fastlane file.**
   - `<project>/docs/*-screenshots.csv` (if present) — pre-existing screenshot
     captions (LANGUAGE, SCREENSHOT, HEADLINE, SUBTITLE columns).
   - `<project>/<AppName>-Info.plist` and `<project>/*.xcodeproj/project.pbxproj`
     (if present) — canonical source for bundle ID, version, build number,
     and development team name.
3. **Extract the following facts** from the sources above (leave a `[UNKNOWN – please fill in]`
   placeholder for anything not found):
   - App display name (App Store) and internal in-app name if different (e.g. "Buzz Off" vs "MosQuit")
   - Bundle ID
   - Version and build number
   - Developer / company name
   - Minimum iOS version and supported devices (iPhone / iPad / Mac)
   - Price model (free / paid / freemium, in-app purchases, subscriptions, ads)
   - Core feature list (what the app does)
   - Explicit non-features (what the app does NOT do)
   - Privacy model (data collected, network access, tracking, UserDefaults keys)
   - Required entitlements / permissions (e.g. `UIBackgroundModes`, camera, location)
   - Localisation languages — prefer the confirmed locale list from `fastlane/Snapfile`
     if present, otherwise infer from `copilot-instructions.md`
   - Positioning / tone / target audience
   - Any notable UX easter eggs or hidden features the reviewer should know about
     (check concept docs and ADRs)
   - Whether Fastlane is already set up (`fastlane/` directory and/or `Snapfile` present)
   - Whether pre-made screenshot captions exist (`docs/*-screenshots.csv`)
4. **Check and update the project backlog** — search `docs/todo.md` for an existing
   App Store submission item (look for keywords: `appstore`, `App Store`, `Submit for Review`,
   `submission`). If none exists, append a new entry to the backlog's **Ready** section:
   ```
   | `BO-XXX` | 🟠 P1 | M | [infra] App Store submission — metadata, screenshots, review, submit |
   ```
   Increment `XXX` to the next available ID. Inform the user that this entry was added.
5. **Compose the App Store submission prompt** following the exact template below,
   substituting all `{{PLACEHOLDER}}` tokens with the extracted facts.
6. **Output** the complete prompt as a fenced markdown code block (` ```text `) so the
   user can copy it directly into ChatGPT or Claude.
7. **After the code block**, add a short "What you still need to fill in" section listing
   every `[UNKNOWN – please fill in]` placeholder that remains.

---

#### Prompt Template

```text
Du bist mein App-Store-Begleiter und hilfst mir dabei, meine iOS-App „{{APP_NAME}}"
vollständig und korrekt im App Store einzureichen. Führe mich als strukturierten
Dialog durch alle notwendigen Felder. Geh Schritt für Schritt vor – immer nur
ein Themenblock auf einmal. Fasse nach jedem Block das Ergebnis in einer
Tabelle zusammen, bevor du zum nächsten Thema weitergehst.

Wenn du Vorschläge machst, biete mir immer mehrere Varianten an (z. B. 3
Vorschläge für den Untertitel). Berücksichtige dabei den App-Store-Zeichenlimit
und SEO-Aspekte für den App Store Search. Erstelle alle Texte auf Englisch
und Deutsch (und ggf. weiteren relevanten Sprachen, die ich angebe).

---

## Was du über {{APP_NAME}} wissen musst

**App-Name (App Store):** {{APP_NAME}}
**Anzeigename in der App:** {{DISPLAY_NAME}}
**Bundle ID:** {{BUNDLE_ID}}
**Version:** {{VERSION}} (Build {{BUILD_NUMBER}})
**Entwickler:** {{DEVELOPER_NAME}}
**Plattform:** {{MIN_OS}}+
**Geräte:** {{SUPPORTED_DEVICES}}
**Preis:** {{PRICE_MODEL}}

**Was macht die App:**
{{APP_DESCRIPTION}}

**Kernfunktionen:**
{{FEATURE_LIST}}

**Was die App NICHT macht:**
{{NON_FEATURES}}

**Datenschutz / Privacy:**
{{PRIVACY_MODEL}}

**Berechtigungen / Entitlements:**
{{ENTITLEMENTS}}

**Technischer Stack:**
{{TECH_STACK}}

**Positionierung / Tonalität:**
{{POSITIONING}}

---

## Führe mich jetzt Schritt für Schritt durch folgende Blöcke:

### Block 1 – App Store Connect: App-Grunddaten
- App-Name (max. 30 Zeichen)
- Untertitel (max. 30 Zeichen)
- Kategorie (Primär und optional Sekundär)
- Altersfreigabe / Content Rating
- Copyright-Angabe

### Block 2 – Beschreibungen & Promotional Text
- Vollständige App-Beschreibung (max. 4.000 Zeichen, für DE und EN)
- Werbeanzeigentext / Promotional Text (max. 170 Zeichen, für DE und EN) –
  dieser kann ohne neues App-Review geändert werden
- What's New (Release Notes für Version {{VERSION}}, für DE und EN)

### Block 3 – Keywords
- Keywords (max. 100 Zeichen pro Sprache, kommagetrennt)
  Für: Englisch (US), Deutsch{{ADDITIONAL_KEYWORD_LOCALES}}
  Tipp: keine Wörter aus dem App-Namen wiederholen, auch Long-Tail-Keywords
  für die App Store Search berücksichtigen

### Block 4 – URLs & Support
- Support-URL
- Marketing-URL (optional)
- Datenschutz-URL (Privacy Policy)
  (Hinweis: Auch für Apps ohne Datenerhebung ist eine Privacy Policy
  inzwischen Pflicht. Helfe mir, eine einfache, korrekte Privacy Policy
  für diese App zu formulieren.)

### Block 5 – App-Datenschutz (App Privacy im App Store)
Führe mich durch alle App-Privacy-Fragen im App Store Connect:
- Welche Daten werden erhoben? ({{PRIVACY_SUMMARY}})
- Tracking?
- Wie ausfüllen für diesen Privacy-Status?
  Erkläre, welche Checkboxen ich wie setze.

### Block 6 – Zertifikat & Signing
- Welches Zertifikat brauche ich? (Distribution Certificate)
- Unterschied: Apple Development vs. Apple Distribution
- Provisioning Profile: App Store Provisioning Profile erstellen
- Wo und wie in Xcode eintragen (manuell vs. automatisch via Xcode)
- App Store Connect: neue App anlegen, Bundle ID registrieren

### Block 7 – Build hochladen
- Archiv erstellen in Xcode (Product → Archive)
- Über Organizer ins App Store Connect hochladen
- Was ist TestFlight, brauche ich es?
- Was tun, wenn der Upload fehlschlägt?
{{FASTLANE_DELIVER_NOTE}}

### Block 8 – App Review Informationen
- Demo-Account ({{DEMO_ACCOUNT_NOTE}})
- Hinweise für den Apple Reviewer (Notes for Apple)
  Helfe mir, sinnvolle Reviewer-Notizen zu formulieren, die erklären:
{{REVIEWER_NOTES_TOPICS}}

### Block 9 – Screenshots & App-Vorschau
- Welche Screenshot-Größen brauche ich (Pflicht vs. optional)?
- Was muss ein guter Screenshot enthalten?
- Kann ich einen App Store Simulator nutzen?
- Brauche ich eine App-Vorschau-Video?
- Helfe mir, Bildunterschriften / Captions für Screenshots zu formulieren
  (für DE und EN)
{{SCREENSHOT_CAPTIONS_NOTE}}

### Block 10 – Preisgestaltung & Verfügbarkeit
- Preis: {{PRICE_MODEL}} – was muss ich einstellen?
- Länder-Verfügbarkeit: Empfehlung weltweit, oder nur bestimmte Märkte?
- Soll ich die Verfügbarkeit auf bestimmte Datum/Uhrzeit legen?

### Block 11 – Abschließende Checkliste
- Erstelle mir eine vollständige Submission-Checkliste als Abhak-Liste,
  damit ich sicher bin, dass ich nichts vergessen habe, bevor ich auf
  „Submit for Review" klicke.

---

Starte jetzt mit Block 1. Frage mich nach allem, was du noch nicht weißt
(z. B. ob ich Einzelperson oder Unternehmen bin, meine Apple-ID,
ob ich bereits ein Developer-Account habe usw.).
Mach Vorschläge und erkläre kurz die Hintergründe, damit ich bewusst
entscheiden kann. Antworte auf Deutsch.
```

---

**Placeholder substitution rules:**

| Placeholder | Source |
|-------------|--------|
| `{{APP_NAME}}` | App Store display name from `copilot-instructions.md` or concept doc |
| `{{DISPLAY_NAME}}` | In-app name if different from App Store name (e.g. "Buzz Off" for MosQuit); omit line if identical |
| `{{BUNDLE_ID}}` | Bundle ID — prefer `Info.plist` / `project.pbxproj`; fallback to `copilot-instructions.md` |
| `{{VERSION}}` / `{{BUILD_NUMBER}}` | Prefer `project.pbxproj` (`MARKETING_VERSION` / `CURRENT_PROJECT_VERSION`); else `[UNKNOWN – please fill in]` |
| `{{DEVELOPER_NAME}}` | Team name from `project.pbxproj` (`DEVELOPMENT_TEAM` + Apple Developer account); else `[UNKNOWN – please fill in]` |
| `{{MIN_OS}}` | Minimum iOS version from tech stack table in `copilot-instructions.md` |
| `{{SUPPORTED_DEVICES}}` | Infer from UI idiom (SwiftUI → iPhone; check `UIDeviceFamily` in `Info.plist` if available) |
| `{{PRICE_MODEL}}` | From concept doc or default to `Kostenlos, keine In-App-Käufe` |
| `{{APP_DESCRIPTION}}` | 2–4 sentence summary from concept doc |
| `{{FEATURE_LIST}}` | Bullet list of core features from concept doc / `copilot-instructions.md` |
| `{{NON_FEATURES}}` | Infer from privacy model and feature list (no network, no accounts, …) |
| `{{PRIVACY_MODEL}}` | From `copilot-instructions.md` privacy section |
| `{{PRIVACY_SUMMARY}}` | One-liner: e.g. "keine Daten" or "keine personenbezogenen Daten" |
| `{{ENTITLEMENTS}}` | From `copilot-instructions.md` entitlements / `UIBackgroundModes` |
| `{{TECH_STACK}}` | From tech stack table in `copilot-instructions.md` |
| `{{POSITIONING}}` | From concept doc positioning / tone / target audience section |
| `{{ADDITIONAL_KEYWORD_LOCALES}}` | Prefer `fastlane/Snapfile` locale list; else infer from localisation count in `copilot-instructions.md`; omit if only EN/DE |
| `{{DEMO_ACCOUNT_NOTE}}` | "nicht nötig, da keine Accounts" if no accounts; else step-by-step guidance |
| `{{REVIEWER_NOTES_TOPICS}}` | Bullet list from entitlements + ADRs + easter egg descriptions |
| `{{FASTLANE_DELIVER_NOTE}}` | If `fastlane/` directory exists: "- Fastlane `deliver` — Metadaten, Screenshots und Changelog können per `fastlane deliver` automatisiert hochgeladen werden (Fastlane ist im Projekt bereits eingerichtet)"; else omit |
| `{{SCREENSHOT_CAPTIONS_NOTE}}` | If `docs/*-screenshots.csv` exists: "**Bereits vorbereitete Screenshot-Captions** (aus `docs/*-screenshots.csv` — bitte für die Vorschläge nutzen):" followed by a markdown table of LANGUAGE / SCREENSHOT / HEADLINE / SUBTITLE for each row; else omit |

**Output:** Complete, copy-pasteable prompt as a fenced `text` code block, followed by
a "What you still need to fill in" checklist for any remaining unknowns.

---

## Adding New Commands

To add a new command:

1. Add it to the **Command Reference** table.
2. Add a full **Command Definition** section with workflow steps.
3. Keep the workflow **concrete and sequential** — no ambiguity about what to do.
4. Follow the pattern: purpose → steps → output.
