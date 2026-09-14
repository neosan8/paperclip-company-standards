# New Company Checklist

Atomic checklist a **Grok Bot seat** (board-deputy) runs when creating a Paperclip game company. Complete every step in order. Do not mark any step done unless it is verified.

Operator layers (MCP primary, CLI fallback, browser never default): `docs/operator-stack.md`. Re-check [docs.paperclip.ing](https://docs.paperclip.ing) before a command family you have not used recently.

**This is not a 13-central bootstrap.** One company per game. Required seats are CEO + Worker + Reviewer only. Do not recreate Layer-1 centrals. Do not hire Researcher or Knowledge Keeper unless there is a specific reason after the 3-slot loop works.

---

## Pre-creation

- [ ] Confirm the game title and that this is a **game company**, not a new central.
- [ ] Confirm the company does not already exist: MCP `paperclip_health` first, then `paperclip_list_companies`.
- [ ] Confirm you will hire three required seats only (CEO, Worker, Reviewer).
- [ ] Confirm adapters will be Cursor (`cursor`; `cursor-local` on Linux Grok Bot workers) and model `auto` unless Neo has pinned a concrete Cursor id. Never `latest`. Never invent an unverified model string. Values: `config/models.json`.

---

## Create the company (MCP)

- [ ] `paperclip_health` — instance at `PAPERCLIP_URL=http://127.0.0.1:3100` is up.
- [ ] `paperclip_create_company` with the game title.
- [ ] Record the company UUID from the response. Do **not** add it to `config/central-companies.json` (that file is the 13-central registry; Grok seats do not bootstrap that layer).

CLI is not required for create. Browser is not the default.

---

## Hire the 3 required agents (MCP)

Reference `config/models.json` and `config/roles.json` for model, adapter, and API role values.

**API enum:** use `paperclip_api_role` on `paperclip_create_agent`, not the spec display name.

| Spec role | API role | Adapter | Model |
|-----------|----------|---------|-------|
| CEO | `ceo` | `cursor` (`cursor-local` on Linux Grok Bot workers) | `auto` unless Neo pins |
| Worker | `engineer` | same | same |
| Reviewer | `qa` | same | same |

`self_review_prohibited` is not a platform field. Embed `review-only; never self-review` in the Reviewer's capabilities text.

- [ ] Create **CEO**:
  - API role: `ceo`
  - Adapter / model: Cursor lock above
  - Heartbeat: OFF
  - AGENTS.md / instructions: this standards repo URL; **idle of production / orchestrate-only** (locked Neo / Atakan 2026-09-14 — capabilities and instructions MUST forbid self-execution; heartbeat OFF is not this rule); approval-wake; checkout/409; backlog-is-invisible-until-todo
  - Run `standards/sync-bootstrap.sh --role=ceo --company=<slug>` if the company-scoped AGENTS.md is not yet written
  - Confirm the hire text says the CEO remains idle of production execution and only orchestrates; Worker produces; Reviewer independently gates quality. Source: `roles/ceo/SOUL.md`.

- [ ] Create **Worker**:
  - API role: `engineer`
  - Adapter / model: Cursor lock above
  - Heartbeat: OFF
  - AGENTS.md: plan before execute; DoD self-check; do not self-close; wait for Reviewer

- [ ] Create **Reviewer** (required — `reviewer_must_exist` is true):
  - API role: `qa`
  - Adapter / model: Cursor lock above
  - Heartbeat: OFF
  - Capabilities text includes `review-only; never self-review`
  - AGENTS.md: verdict format, self-review prohibition

Do not set Claude/Codex adapters. Do not set `adapterConfig.effort` / `modelReasoningEffort` as if these were `claude_local` / `codex_local` agents. Cursor Local fields are `adapterConfig.model` (and `cwd` when you have a workspace path). Verified 2026-09-14: [Cursor Local](https://docs.paperclip.ing/reference/adapters/cursor-local/).

---

## Wake, approvals, checkout, budgets (CLI, not MCP)

MCP is CRUD only. For the following, use `npx paperclipai … --json`. Never `pnpm paperclipai`. Confirm the current subcommand on [docs.paperclip.ing](https://docs.paperclip.ing) (CLI reference) before running.

- [ ] `whoami` — you are acting as the board-deputy, not as a worker agent.
- [ ] Budgets set before any wake (company and/or per-agent). A seat with no budget guard is not ready.
- [ ] Heartbeat remains OFF. When work exists, flip the issue to `todo`, then wake the CEO via CLI to **orchestrate** (create Worker / Reviewer sub-issues). Idle of production work is the CEO behavioral rule even while awake; heartbeat OFF is only the wake-loop setting. Queue-empty idle (no wake loop) is success when there is no work.
- [ ] Approvals via CLI (`approval` family), not the browser.
- [ ] Checkout via CLI (`issue checkout`). HTTP 409 = another owner; do not proceed.
- [ ] Secrets via CLI if an adapter env needs a secret ref. Do not paste secrets into MCP create payloads.

Hosted GitHub Actions is not a gate for this checklist.

---

## First CEO issue — 3-slot loop

- [ ] Create an issue assigned to the **CEO** (never to Worker or Reviewer): "Self-test: create a sample sub-issue, assign to Worker, wait for Reviewer verdict, close the loop."
- [ ] Flip state from `backlog` to `todo`. Backlog is invisible.
- [ ] CLI-wake the CEO. Do not enable a standing heartbeat.
- [ ] Wait for Reviewer `ship it` and CEO close.
- [ ] Confirm heartbeat/wake is off afterwards.

---

## Optional specialists (do not run on spawn)

Researcher and Knowledge Keeper are **not** part of Grok spawn. Hire later only if the CEO has a documented reason. If hired: same Cursor lock; Researcher API role `researcher`; Knowledge Keeper API role `pm`.

The research-driven specialist loop (VISION → research brief → wiki → roster decision) remains valid **after** the 3-slot company works, and only when you are adding specialists. It is not a reason to hire five seats on day one.

Do not notify or register with the Knowledge-central company as a spawn step. Weekly delta applies only if a Knowledge Keeper exists and that ingest path is in use. See `weekly-knowledge-aggregation.md`.

---

## Knowledge-central never-archived guard (do not operate that layer)

Grok seats do not change Knowledge company status. If a Grok-created company later grows a Keeper that posts to Knowledge, archiving Knowledge still creates a fleet-wide 403. Escalate; do not archive, unarchive, or recreate KNO from a game seat.

---

## Final verification

- [ ] Exactly 3 required agents exist (CEO, Worker, Reviewer). No extra standing slots were created "because the old standard said five."
- [ ] All three use the Cursor lock and model `auto` (or Neo's pinned id).
- [ ] API roles are `ceo` / `engineer` / `qa`.
- [ ] Heartbeat OFF. First loop closed with a Reviewer `ship it`.
- [ ] CEO capabilities / instructions forbid self-execution and state idle of production / orchestrate only. Heartbeat OFF alone does not satisfy this check.
- [ ] Board-deputy talked only to the CEO. The CEO created sub-issues for Worker and Reviewer; the CEO did not produce the deliverable.
- [ ] 13-central registry was not edited. No Claude/Codex seats were hired.

Company is ready for production work.

---

## Legacy appendix — five-slot Knowledge-central bootstrap

Not the Grok path. Kept so the Knowledge-central portfolio is not silently erased.

That portfolio hired five slots on Claude/Codex (`claude_local` / `codex_local`) with per-agent `adapterConfig.effort` / `modelReasoningEffort` = `high`, registered the company with Knowledge, and ran a Researcher-first specialist sequence before extra workers. Values: `config/models.json` `legacy_five_slot`. Tool-stack validation against `scripts/validate-stack.sh` applies to those Claude-host machines, not to Grok seat spawn.
