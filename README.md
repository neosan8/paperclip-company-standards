# paperclip-company-standards

The "constitution" for Giant Aicado Paperclip companies.

## What this repo is

This repo defines the canonical architecture, tool stack, model assignments, and operating policies that every Paperclip company in the Giant Aicado studio must conform to. It is the single source of truth for bootstrapping new companies and validating existing ones.

## Owner

Owned by the **Knowledge company** (prefix: KNO). Knowledge maintains and merges PRs into `main`. Atakan approves any change to `main` that alters model topology or mandatory stack.

## Versioning

Tagged with semver (e.g. `v0.1.0`). When a new tag is published:
- All running companies should validate their config against the new version on next heartbeat.
- The mechanism for automated validation is tracked in `docs/known-issues.md` (KI-PS-2).

## Branch model

- **`spec/<topic>` / `feature/<topic>` / `fix/<topic>` / `docs/<topic>`** — short-lived branches cut from `main`; PR targets `main`; deleted after merge.
- **`main`** — canonical source of truth; external agents and human team consume only this; tagged with semver; Atakan approves merge.

> `working` and `test` branches are deprecated. See `docs/flows/branch-workflow.md` for the authoritative workflow.

## Quick navigation

- Start with `CONTEXT.md` for domain glossary.
- Read `SOURCE_MAP.md` for recommended read order.
- See `docs/company-architecture.md` for the full company tier.
- See `config/models.json` for current model assignments.
- See `docs/flows/new-company-checklist.md` when creating a new company.

## Related repos

- [neosan8/template-stage-0-kit](https://github.com/neosan8/template-stage-0-kit) — HTML game template (Stage 0)
- [neosan8/template-stage-1-kit](https://github.com/neosan8/template-stage-1-kit) — Unity template (Stage 1+)
- [neosan8/game-market](https://github.com/neosan8/game-market) — `docs/giant-aicado/STUDIO_OS_V2.md`, the canonical studio operating model
