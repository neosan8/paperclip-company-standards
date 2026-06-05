# Changelog

All notable changes to the Paperclip company standards are documented here.
Versions follow the `YYYY.patch` internal scheme; changes are grouped by version.

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
