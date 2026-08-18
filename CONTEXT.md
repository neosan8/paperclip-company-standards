# paperclip-company-standards — Domain Language

Agents and developers should read this file before any other doc in this repo. It decodes all jargon used across the standards.

## Studio scope

- **Giant Aicado** — AI-native mobile game studio. Pipeline: idea discovery -> GDD -> HTML prototype -> Unity build -> ship.
- **Giant Avocado** — the human Unity development and art team within the studio.
- **Paperclip** — the agent orchestration platform running all AI companies in the studio.

## Company tiers

- **Central company** — one of 13 standing companies that own template-level work and cross-game functions (e.g. Market, Dev, Art, Knowledge). These are permanent and shared across all game projects.
- **Game company** — one Paperclip company created per active game title (e.g. Balloon Flow Studio). Game companies consume outputs from central companies.
- **N game companies** — the count of game companies grows as titles enter production; currently one (Balloon Flow Studio).

## Agent roles

- **CEO** — orchestrator only. Never executes tasks directly. Creates sub-issues and delegates to workers. Model: claude-opus-5. If a CEO is seen writing code or running CLI commands itself, that is a bug.
- **Worker** — executes tasks (code, research, file operations). Model: gpt-5.6-sol via Codex OAuth. Follows `/plan -> /goal -> $codex-review -> $review` workflow.
- **Researcher** — per-company specialist. Finds gold standards, frontier patterns, sector best-practices for the company domain. Hands findings to Knowledge Keeper. Model: gpt-5.6-sol via Codex OAuth.
- **Knowledge Keeper** — per-company specialist. Maintains the company-internal wiki/KB. Captures decisions. Sends weekly delta to central Knowledge. Model: claude-sonnet-4-6 (latest takma adı kullanılmaz — geçersiz model id, PD'yi 5 hafta durdurdu).
- **Reviewer** — per-company specialist. Independent quality gate. Reviews all Worker deliverables before CEO reports Done. Issues a verdict (`ship it` / `needs review` / `blocked`). Never reviews own work. Model: gpt-5.6-sol via Codex OAuth. Mandatory 5th slot as of v0.2.0.

## Role pack

- **Role pack** — the set of documents a role needs to operate: skills, heartbeat, tools, identity docs. Lives in `roles/<role>/`. Distributed to agents via `standards/sync-bootstrap.sh`.

## Quality gate concepts

- **VISION.md** — per-company machine-readable constitution. CEO reads it every heartbeat before any other action. Schema at `templates/VISION.md`. Mandatory per company as of v0.2.0.
- **SOUL.md** — CEO identity document. Defines the quality-gate obligation ("I personally verify every deliverable before reporting to the Founder. A bad 'done' report is worse than a late one.") and Giant Aicado-specific anti-patterns.
- **DoD** — Definition of Done. Five-item self-check all Workers run before reporting done, plus Reviewer's independent verification. See `roles/_shared/DEFINITION-OF-DONE.md`.
- **autoreview** — branch-diff advisory review tool from `uinaf/agents`. Reviewer runs it on every deliverable. Never run on your own changes (self-review prohibition).
- **review-gang** — parallel multi-persona review pattern. Multiple Reviewer personas each check one dimension (correctness, karpathy, security, performance, a11y).
- **Sync bootstrap** — `standards/sync-bootstrap.sh`. Idempotent script that merges `roles/_shared/` + per-role docs into a company-scoped `~/Docs/paperclipcompanies/<company>/AGENTS.md`. Never touches CC's host CLAUDE.md.

## Communication rules

- **CC-to-CEO-only rule** — CC never talks to Workers, Researchers, Knowledge Keepers, or Reviewers directly. All CC-created issues must be assigned to the company CEO. CEO delegates to specialists via sub-issues. See `standards/cc-paperclip-communication-protocol.md`. Atakan-canonical 2026-06-03.

## Approval handling

- **Approval ID** (`PAPERCLIP_APPROVAL_ID`) — env var injected by the Paperclip platform when an agent wakes to handle a pending approval. Every agent must check this first, before any other heartbeat action. See `standards/approval-wake-protocol.md`.

## Heartbeat policy

- **Heartbeat task-driven policy** — heartbeat is OFF by default. CC turns it ON when work is queued. CC turns it OFF when the queue drains. Night-shift time-boxed windows are allowed.
- A CEO starting an unprompted heartbeat loop with no work in queue is a misconfiguration.

## Auth policy (HARD)

- **OAuth-only rule** — all Claude models use Claude.ai subscription OAuth. All GPT/Codex models use ChatGPT subscription OAuth. Direct API key usage is forbidden for all production agents.
- **Exception** — gbrain embedding endpoint only (`~/.secrets/openai-embedding.env`).

## Mandatory tool stack

Every company and every human team CC install must have:

| Tool | Purpose |
|------|---------|
| LLM Wiki + Obsidian | Second brain; vault at `~/Docs/paperclipcompanies/_knowledge-base/` |
| gbrain | Semantic search; brain-first lookup before external search |
| gstack | QA real-browser verification, AI slop detection, autoplan patterns |
| graphify | Knowledge graph; GRAPH_REPORT.md reference in AGENTS.md |
| Karpathy discipline | Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven |
| TokenJuice | Token-efficient tool wrappers; bash compaction |

## Codex workflow

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
