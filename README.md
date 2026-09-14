# paperclip-company-standards

The constitution Grok Bot seats receive and follow when creating and running Paperclip companies.

## What this repo is

This repo defines the architecture, models, role packs, and operator path that a **Grok Bot seat** uses to bootstrap a game company. Its output is configuration, not documentation: a wrong model id here produces agents that fail to start.

**Primary profile (2026-09-14):** one Paperclip company per game title. Three required agents — CEO, Worker, Reviewer — all on Paperclip Cursor Local, model `auto` unless Neo pins a concrete Cursor id. Researcher and Knowledge Keeper are optional specialists. The 13-central layer is not a spawn path.

## Owner

Owned by the **Knowledge company** (prefix: KNO). Knowledge maintains and merges PRs into `main`. Atakan approves any change to `main` that alters model topology or the Grok primary profile.

## Grok Bot seat — start here

1. `CONTEXT.md` — glossary (3-slot primary; 13-central / five-slot marked legacy)
2. `SOURCE_MAP.md` — read order
3. `docs/operator-stack.md` — MCP primary, CLI fallback, browser never default
4. `docs/flows/new-company-checklist.md` — create/hire the 3-slot Cursor company
5. `config/models.json` / `config/roles.json` — machine-readable values

Board-deputy (the Grok Bot seat) talks only to the company CEO. The deputy wakes the CEO to orchestrate; the CEO remains idle of production execution (locked Neo / Atakan 2026-09-14). Source: `roles/ceo/SOUL.md`. See `standards/cc-paperclip-communication-protocol.md`.

## Versioning

Tagged with semver (e.g. `v0.1.0`). When a new tag is published:
- Running companies should validate their config against the new version on next heartbeat.
- The mechanism for automated validation is tracked in `docs/known-issues.md` (KI-PS-2).

## Branch model

- **`spec/<topic>` / `feature/<topic>` / `fix/<topic>` / `docs/<topic>`** — short-lived branches cut from `main`; PR targets `main`; deleted after merge.
- **`main`** — canonical source of truth; external agents and human team consume only this; tagged with semver; Atakan approves merge.

> `working` and `test` branches are deprecated. See `docs/flows/branch-workflow.md` for the authoritative workflow.

## Legacy / Knowledge-central portfolio

The 13 standing central companies and the five-slot Claude/Codex topology remain in this repo so Knowledge-central ownership is not erased. They are marked legacy. Grok Bot seats must not recreate 13 centrals or hire five standing slots by default. See `docs/company-architecture.md` and `config/central-companies.json`.

## Related repos

- [neosan8/paperclip-mcp](https://github.com/neosan8/paperclip-mcp) — MCP server seats use (do not vendor it here)
- [neosan8/template-stage-0-kit](https://github.com/neosan8/template-stage-0-kit) — HTML game template (Stage 0)
- [neosan8/template-stage-1-kit](https://github.com/neosan8/template-stage-1-kit) — Unity template (Stage 1+)
- [neosan8/game-market](https://github.com/neosan8/game-market) — `docs/giant-aicado/STUDIO_OS_V2.md`, the canonical studio operating model
