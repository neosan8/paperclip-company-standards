# Changelog

All notable changes to the Paperclip company standards are documented here.
Versions follow the `YYYY.patch` internal scheme; changes are grouped by version.

---

## v0.2.5 — 2026-07-24

Model topology update per Atakan's directive, driven by two root causes: (1) the CEO and Codex agent model ids needed to move forward (CEO -> `claude-opus-4-7`, Worker/Researcher/Reviewer -> `gpt-5.6-sol`), and (2) the `claude-sonnet-latest` alias used for Knowledge Keeper is not a valid, pinned model id — this exact bug stalled Product Design for 5 weeks. Going forward, `-latest` aliases are banned; every role must reference an explicit, versioned model id.

### 1. CEO model bump
**Files:** `config/models.json`, `config/roles.json`, `CONTEXT.md`, `docs/ceo-bootstrap.md`, `docs/company-architecture.md`, `docs/flows/new-company-checklist.md`, `docs/governance/model-topology.md`, `docs/governance/paperclip-version-policy.md`, `roles/_shared/CONTEXT.md`, `roles/ceo/README.md`, `templates/CEO_BOOTSTRAP.md`

`claude-opus-4-8` → `claude-opus-4-7` everywhere the CEO model is referenced.

### 2. Codex agent model bump (Worker, Researcher, Reviewer)
**Files:** `config/models.json`, `config/roles.json`, `CONTEXT.md`, `docs/company-architecture.md`, `docs/flows/new-company-checklist.md`, `docs/governance/model-topology.md`, `docs/specialists/researcher.md`, `docs/worker-bootstrap.md`, `roles/_shared/CONTEXT.md`, `roles/researcher/README.md`, `roles/reviewer/README.md`, `roles/worker/README.md`, `templates/CEO_BOOTSTRAP.md`

`gpt-5.5` → `gpt-5.6-sol` everywhere the Worker, Researcher, or Reviewer model is referenced.

### 3. Ban `claude-sonnet-latest`; pin Knowledge Keeper to `claude-sonnet-4-6`
**Files:** `config/models.json`, `config/roles.json`, `CONTEXT.md`, `docs/company-architecture.md`, `docs/flows/new-company-checklist.md`, `docs/governance/model-topology.md`, `docs/specialists/knowledge-keeper.md`, `roles/_shared/CONTEXT.md`, `roles/knowledge-keeper/README.md`, `templates/CEO_BOOTSTRAP.md`

`claude-sonnet-latest` → `claude-sonnet-4-6`, with an explicit note attached at every occurrence: "latest takma adı kullanılmaz (geçersiz model id, PD'yi 5 hafta durdurdu)". The `-latest` alias is not a valid model id and must never be used for a production agent slot again.

**Note on versioning:** this changelog's top entry was already `v0.2.4` (2026-06-15, Knowledge company never-archived guard). This update is therefore filed as `v0.2.5`, not `v0.2.4` — the git branch/PR were requested as "v0.2.4-model-topology" but the changelog version number itself had to move to the next free slot to avoid colliding with the existing v0.2.4 entry below.

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
