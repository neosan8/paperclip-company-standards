# Changelog

All notable changes to the Paperclip company standards are documented here.
Versions follow the `YYYY.patch` internal scheme; changes are grouped by version.

---

## Unreleased

### Parallel work isolation and worker durable learning
**Files:** `standards/parallel-work-isolation.md` (new), `roles/worker/durable-learning.md` (new), `roles/worker/README.md`, `SOURCE_MAP.md`

Two gaps found by comparing this repo against [`aronprins/codex-loop`](https://github.com/aronprins/codex-loop) (MIT, read 2026-08-13). Measured, not assumed: before this change `worktree` and `learning` each appeared in **zero** files here.

**Parallel work had no isolation model.** Concurrent workers were already running — five Codex artists writing the same Figma frame during Stage 1 GUI kit production — and collisions were handled by noticing them. The standard is now one `git worktree` per concurrent worker, merge-and-verify barrier between waves, dependency waves via `dependsOn` with a default concurrency cap of 4, and sequential execution as the default. The load-bearing rule is ownership of shared state: **only the CEO writes shared runtime files**, once per wave after the barrier. Worktrees stop workers colliding in source; single ownership stops them colliding in state, which is the failure neither worker can detect because each one's own write succeeds.

**Workers had nowhere to record what they learned.** Fresh context per issue is deliberate, but it meant a worker's finding on issue 40 was unavailable to the worker on issue 41 — the same wrong assumption made, corrected and forgotten repeatedly. Git history records what changed, never what had to be found out first. Workers now append to `progress.txt` with a stable `## Codebase Patterns` section, and read it before starting.

**Conflict avoidance added from [`aronprins/claude-loop`](https://github.com/aronprins/claude-loop)**, the sibling repo. Everything above isolates conflict; this avoids it, which is the cheaper half. Put dependency installation in the first scaffolding unit so wave-mates do not fight over lockfiles; prefer additive patterns (a new file per route, auto-discovered) over edits to one shared registry; declare `dependsOn` honestly, since an omitted dependency does not make work parallel, only makes the collision arrive later with less explanation; and have workers report a `mergeRisk` when they had no choice but to touch a shared file. Stage 1 GUI kit production had already validated this — five artists on one Figma frame were split into one artist per region — but the lesson stayed in that project instead of the standard.

codex-loop was **not installed as a skill**: it duplicates orchestration a Paperclip CEO already performs, and at 24 stars with no pushes since 22 June it is not a dependency worth taking. The pattern is recorded here so it survives independently of that repo — the same reasoning that would have prevented `config/skills-manifest.json` listing two skills that had been retired upstream.

---

## v0.3.0 — 2026-07-29

Model topology update per Atakan's directive, driven by two root causes: (1) the CEO and Codex agent model ids needed to move forward (CEO -> `claude-opus-5`, Worker/Researcher/Reviewer -> `gpt-5.6-sol`), and (2) the `claude-sonnet-latest` alias used for Knowledge Keeper is not a valid, pinned model id — this exact bug stalled Product Design for 5 weeks. Going forward, `-latest` aliases are banned; every role must reference an explicit, versioned model id. Reasoning effort is standardized to **high** for all five roles, set **per agent** in `adapterConfig` — `effort` for `claude_local` (CEO, Knowledge Keeper), `modelReasoningEffort` for `codex_local` (Worker, Researcher, Reviewer). Host config files (`~/.claude/settings.json`, `~/.codex/config.toml`) govern host-run CLI sessions only; Paperclip gives each codex agent a managed `CODEX_HOME`, so they do not control company agents.

### 1. CEO model bump
**Files:** `config/models.json`, `config/roles.json`, `CONTEXT.md`, `docs/ceo-bootstrap.md`, `docs/company-architecture.md`, `docs/flows/new-company-checklist.md`, `docs/governance/model-topology.md`, `docs/governance/paperclip-version-policy.md`, `roles/_shared/CONTEXT.md`, `roles/ceo/README.md`, `templates/CEO_BOOTSTRAP.md`

`claude-opus-4-8` → `claude-opus-5` everywhere the CEO model is referenced.

### 2. Codex agent model bump (Worker, Researcher, Reviewer)
**Files:** `config/models.json`, `config/roles.json`, `CONTEXT.md`, `docs/company-architecture.md`, `docs/flows/new-company-checklist.md`, `docs/governance/model-topology.md`, `docs/specialists/researcher.md`, `docs/worker-bootstrap.md`, `roles/_shared/CONTEXT.md`, `roles/researcher/README.md`, `roles/reviewer/README.md`, `roles/worker/README.md`, `templates/CEO_BOOTSTRAP.md`

`gpt-5.5` → `gpt-5.6-sol` everywhere the Worker, Researcher, or Reviewer model is referenced.

### 3. Ban `claude-sonnet-latest`; pin Knowledge Keeper to `claude-sonnet-4-6`
**Files:** `config/models.json`, `config/roles.json`, `CONTEXT.md`, `docs/company-architecture.md`, `docs/flows/new-company-checklist.md`, `docs/governance/model-topology.md`, `docs/specialists/knowledge-keeper.md`, `roles/_shared/CONTEXT.md`, `roles/knowledge-keeper/README.md`, `templates/CEO_BOOTSTRAP.md`

`claude-sonnet-latest` → `claude-sonnet-4-6`, with an explicit note attached at every occurrence: "latest takma adı kullanılmaz (geçersiz model id, PD'yi 5 hafta durdurdu)". The `-latest` alias is not a valid model id and must never be used for a production agent slot again.

### 4. Clarify MAJOR vs MINOR in the version policy
**File:** `docs/governance/paperclip-version-policy.md`

The MAJOR heading said "bump major when a change would require every running company to reconfigure its agents" — which describes this release too, contradicting its own examples (all of which are provider-family, adapter, role-removal or auth-policy changes) and contradicting `model-topology.md`, where a same-family model move is minor. As written, the repo mandated two different release classes for the same change.

Rewritten so the criterion is **breakage, not effort**: both major and minor touch every company (validation issues vs adoption issues), so "must be reconfigured" cannot be the discriminator. The test is whether the old config still functions. Same-family model moves and new required `adapterConfig` settings are explicitly minor.

### 5. Correct Knowledge company status in the registry
**File:** `config/central-companies.json`

`Knowledge (KNO)` carried `_archived: true` from the 2026-06-02 audit. Verified against a live
Paperclip DB backup on 2026-07-29: **KNO is active**; Creatives (CRE) is genuinely archived. The
stale flag contradicted this repo's own never-archived guard and would have broken the v0.3.0
adoption process, which requires Knowledge to track compliance across companies — cross-company
calls to an archived company return HTTP 403.

Active company count is **12** (13 central, less CRE). The registry description now also records
that live companies may carry specialist agents beyond the five canonical slots; adoption targets
the canonical five only.

**Note on versioning:** this release is a **minor** bump, not a patch. `paperclip-version-policy.md` reserves patch for clarifications that do not change behavior, and `model-topology.md` classifies a same-family model move as minor. This change alters model behavior for **all five** roles — CEO, Worker, Researcher, Knowledge Keeper and Reviewer — and standardizes reasoning effort, so it requires the minor process: adoption issues in every active company, tracked by Knowledge until all are compliant.

It was originally drafted as `v0.2.5` (the next free slot after the existing `v0.2.4` entry of 2026-06-15, Knowledge company never-archived guard), and the git branch was named `v0.2.4-model-topology` before either number was settled. Both were wrong for a behavior change; the release was reclassified to `v0.3.0` on 2026-07-29. The branch name is a working label only and is not canonical — `config/models.json`, this changelog, and the PR title all read `0.3.0`.

---

## v0.2.4 — 2026-06-15

Knowledge company never-archived guard + Wiki Feed Protocol 403 escalation rule. Root cause: cross-company Knowledge ingest bug surfaced 2026-06-15 from accidental Knowledge archive during the Animation + Analytics company bootstrap. All production companies POST their weekly delta to the Knowledge company issues endpoint; when Knowledge is archived, the Paperclip API returns HTTP 403 with message `Agent key cannot access another company`. Agents misread this as a permissions failure and retried indefinitely.

### 1. Knowledge company never-archived guard
**File:** `docs/flows/new-company-checklist.md`

Added a mandatory check under "Register with Knowledge company": verify the Knowledge company status is `active` before completing company registration. Documents that CEOs and Routines must never change Knowledge company status and that any required pause must be escalated to CC.

### 2. Wiki Feed Protocol 403 escalation rule
**File:** `roles/knowledge-keeper/weekly-aggregation-handoff.md`

Added "403 error on cross-company POST" section. Documents the correct interpretation of the 403 error (archived company, not bad agent key), the no-retry / no-coord-chain rule, and the escalation path via a coord sub-issue to CEO to CC.

---

## v0.2.3 — 2026-06-05

Four process lessons surfaced during the SFX & Haptic company autonomous flow execution.

### 1. Reviewer task-done vs. verdict ship-it clarification
**Files:** `roles/reviewer/README.md`

An issue status of `done` means the review *task* completed — not that the verdict was `ship it`. The verdict is carried in the comment body as an explicit `**Verdict:**` label. CEO closes the parent issue only on an explicit `ship it` verdict, never on task status alone. Added the distinction as a named section and extended anti-patterns accordingly.

### 2. CEO owns downstream agent heartbeat lifecycle
**Files:** `roles/ceo/README.md`

When the CEO assigns work, it must enable the assigned agent's heartbeat at assignment time and disable it once the verdict lands (examples: KK ON at Step C → OFF after Reviewer ship-it; Reviewer ON when review issue opens → OFF after verdict). CC controls only the CEO's own heartbeat. Added the protocol as a named section and two new anti-patterns.

### 3. Agent stall recovery flow
**Files:** `docs/flows/agent-stall-recovery.md` *(new)*

New doc covering: symptom detection (status `error` or stale `executionLockedAt` > 30 min), diagnosis steps, recovery sequence (`PATCH` agent to `idle` → reset issue to `todo` → scope residual work in a comment → re-fire heartbeat), and common anti-patterns (invoking while in error state, skipping the residual-work comment, clearing lock after re-firing heartbeat).

### 4. Branch workflow standard
**Files:** `docs/flows/branch-workflow.md` *(new)*

New doc deprecating `working` and `test` branches. Every change branches off `origin/main`, targets `main` in the PR, and is deleted after merge. One PR = one logical change. Includes type taxonomy (`spec/feature/fix/docs`) and a remediation procedure for existing PRs on deprecated branches.

---

## v0.2.2 — 2026-05-14

- `fix`: update stale `sync-bootstrap` references found in codex-review pass.
- `patch`: `sync-bootstrap.sh` made company-scoped; CC→CEO communication protocol doc added.

## v0.2.1

- `patch`: API enum mappings + UUID refresh + Researcher-first provisioning sequence.
