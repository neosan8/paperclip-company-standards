# paperclip-company-standards — Domain Language

Agents and developers should read this file before any other doc in this repo. It decodes all jargon used across the standards.

**Grok Bot seats start here, then `SOURCE_MAP.md`, then `docs/operator-stack.md` and `docs/flows/new-company-checklist.md`.** The primary company is a 3-slot Cursor game company. The 13-central / five-slot material is the Knowledge-central portfolio and is not a spawn path.

## Studio scope

- **Giant Aicado** — AI-native mobile game studio. Pipeline: idea discovery -> GDD -> HTML prototype -> Unity build -> ship.
- **Giant Avocado** — the human Unity development and art team within the studio.
- **Paperclip** — the agent orchestration platform running AI companies in the studio.
- **Grok Bot seat** — board-deputy that creates and runs Paperclip game companies. Talks only to the company CEO. Operator layers: `docs/operator-stack.md`.

## Company tiers

- **Game company (primary)** — one Paperclip company per active game title. Grok Bot seats create these. Required seats: CEO + Worker + Reviewer. All Cursor.
- **Central company (legacy / Knowledge-central portfolio)** — one of 13 standing companies that owned template-level work and cross-game functions (e.g. Market, Dev, Art, Knowledge). Permanent in that portfolio. **Grok Bot seats do not bootstrap, recreate, or route across this layer.** Registry: `config/central-companies.json`.
- **N game companies** — the count grows as titles enter production.

## Agent roles

- **CEO** — remains idle of production execution; orchestrates and distributes only (locked Neo / Atakan 2026-09-14). Never implements deliverables (code, docs, art). Worker produces; Reviewer independently gates quality. Heartbeat OFF is not this rule. Source: `roles/ceo/SOUL.md`. Primary: Cursor Local, model `auto` unless Neo pins a concrete id. API role: `ceo`. If a CEO is seen writing code or running implementation CLI itself, that is a bug.
- **Worker** — executes tasks (code, research, file operations). Primary: same Cursor lock. API role: `engineer`. Plans before executing; runs DoD self-check; does not self-close.
- **Reviewer** — independent quality gate. Reviews all Worker deliverables before CEO reports Done. Issues a verdict (`ship it` / `needs review` / `blocked`). Never reviews own work. Primary: same Cursor lock. API role: `qa`. Required seat (`reviewer_must_exist` is true).
- **Researcher** — optional specialist. Finds gold standards, frontier patterns, sector best-practices. Hands findings to Knowledge Keeper when that specialist exists. Not a standing slot on the Grok path. API role: `researcher`.
- **Knowledge Keeper** — optional specialist. Maintains the company-internal wiki/KB. Captures decisions. Sends weekly delta to central Knowledge only if that ingest path is in use. Not a standing slot on the Grok path. API role: `pm`. `latest` is not a model id (invalid identifier, stopped Product Design for five weeks).

Machine-readable assignments: `config/models.json`, `config/roles.json`. Historical Claude/Codex five-slot ids live only under `legacy_five_slot` in those files.

## Role pack

- **Role pack** — the set of documents a role needs to operate: skills, heartbeat, tools, identity docs. Lives in `roles/<role>/`. Distributed to agents via `standards/sync-bootstrap.sh`.

## Quality gate concepts

- **VISION.md** — per-company machine-readable constitution. CEO reads it every heartbeat before any other action. Schema at `templates/VISION.md`.
- **SOUL.md** — CEO identity document. Defines the quality-gate obligation ("I personally verify every deliverable before reporting to the Founder. A bad 'done' report is worse than a late one.") and Giant Aicado-specific anti-patterns.
- **DoD** — Definition of Done. Five-item self-check all Workers run before reporting done, plus Reviewer's independent verification. See `roles/_shared/DEFINITION-OF-DONE.md`.
- **autoreview** — branch-diff advisory review tool from `uinaf/agents`. Reviewer runs it on every deliverable. Never run on your own changes (self-review prohibition).
- **review-gang** — parallel multi-persona review pattern. Multiple Reviewer personas each check one dimension (correctness, karpathy, security, performance, a11y).
- **Sync bootstrap** — `standards/sync-bootstrap.sh`. Idempotent script that merges `roles/_shared/` + per-role docs into a company-scoped `~/Docs/paperclipcompanies/<company>/AGENTS.md`. Never touches the host CLAUDE.md.

## Communication rules

- **Board-deputy-to-CEO-only rule** — the Grok Bot seat (board-deputy; historically CC) never talks to Workers, Researchers, Knowledge Keepers, or Reviewers directly. All deputy-created issues must be assigned to the company CEO. CEO delegates via sub-issues. See `standards/cc-paperclip-communication-protocol.md`. Atakan-canonical 2026-06-03; Grok seat named 2026-09-14.

## Approval handling

- **Approval ID** (`PAPERCLIP_APPROVAL_ID`) — env var injected by the Paperclip platform when an agent wakes to handle a pending approval. Every agent must check this first, before any other heartbeat action. See `standards/approval-wake-protocol.md`.

## Heartbeat policy

- **Heartbeat task-driven policy** — heartbeat is OFF by default. The deputy turns it ON when work is queued. The deputy turns it OFF when the queue drains. Night-shift time-boxed windows are allowed.
- A CEO starting an unprompted heartbeat loop with no work in queue is a misconfiguration.
- Idle is success when the queue is empty.
- Heartbeat OFF / queue-empty idle is not the CEO production-idle lock. The CEO remains idle of production execution even when awake. Source: `roles/ceo/SOUL.md`.
- New issues sit in `backlog` until flipped to `todo`. Backlog is invisible.

## Auth policy (HARD)

- **Grok primary** — required seats use Paperclip Cursor Local. No raw Anthropic or OpenAI API keys for model calls.
- **Legacy five-slot** — Claude models used Claude.ai subscription OAuth; GPT/Codex models used ChatGPT subscription OAuth. Direct API keys forbidden.
- **Exception** — gbrain embedding endpoint only (`~/.secrets/openai-embedding.env`), when that stack is in use.
- **`latest` is forbidden** — it is not a version identifier.

## Operator stack (Grok seats)

| Layer | Role |
|-------|------|
| MCP primary | `neosan8/paperclip-mcp`, `PAPERCLIP_URL=http://127.0.0.1:3100`, health first; CRUD only |
| CLI fallback | `npx paperclipai … --json` for approvals, wake, checkout, routines, budgets, secrets, whoami; never `pnpm paperclipai` |
| Browser | Never default |
| Docs | Always re-check https://docs.paperclip.ing (repo `paperclipai/paperclip-docs`) |

Full text: `docs/operator-stack.md`. Do not install `run-paperclip` or `paperclip-vision` as Grok runtime.

## Codex workflow (legacy workers)

Applies to Knowledge-central Codex workers, not to Grok Cursor workers. Cursor workers still plan before executing and still require a Reviewer verdict.

- **`/plan`** — prepare a plan for the task before touching code.
- **`/goal`** — execute against the plan; at each milestone run `$codex-review`; at the end run `$review`.
- **`$codex-review`** — advisory self-check. Codex CLI's review wrapper.
- **`$review`** — independent ship gate. Verdict: `ship it` / `needs review` / `blocked`.

## Branch model (every canonical repo)

- **`spec/<topic>` / `feature/<topic>` / `fix/<topic>` / `docs/<topic>`** — short-lived branches cut from `main`; PR targets `main`; deleted after merge.
- **`main`** — canonical source of truth; tagged with semver; Atakan approves merge.

> `working` and `test` branches are deprecated. See `docs/flows/branch-workflow.md` for the authoritative workflow.

## Related repos

- [neosan8/template-stage-0-kit](https://github.com/neosan8/template-stage-0-kit) — HTML game template (Stage 0, L1-L100)
- [neosan8/template-stage-1-kit](https://github.com/neosan8/template-stage-1-kit) — Unity Android template (Stage 1+)
- [neosan8/template-gui-kit](https://github.com/neosan8/template-gui-kit) — Figma GUI Kit (Codex Template GUI Kit v0.2)
- [neosan8/game-market](https://github.com/neosan8/game-market) — `docs/giant-aicado/STUDIO_OS_V2.md`, the canonical studio operating model
- [neosan8/paperclip-mcp](https://github.com/neosan8/paperclip-mcp) — MCP server Grok seats use; do not vendor it here
