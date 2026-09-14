# Shared Vocabulary — Canonical Term Definitions

All agents and developers must read this file before any role-specific doc in `roles/`.
When a term in another doc conflicts with a definition here, this file wins.
Flag ambiguities by opening an issue in the standards repo rather than resolving them unilaterally.

---

## Core entities

| Term | One-line definition |
|------|---------------------|
| **Giant Aicado** | AI-native mobile game studio. Pipeline: idea → GDD → HTML template → Unity build → ship. |
| **Giant Avocado** | Human Unity dev + art team inside the studio (Dogukan, Burc, Osman). |
| **Paperclip** | Agent orchestration platform. Provides company, issue, heartbeat, approval, and tool APIs. |
| **Central company** | Legacy Knowledge-central portfolio: one of 13 standing companies (Market, Dev, Art, Knowledge, etc.). Grok Bot seats do not bootstrap this layer. |
| **Game company** | One Paperclip company per active game title. Primary path for Grok Bot seats. |
| **Grok Bot seat** | Board-deputy that creates/runs game companies. Talks only to the CEO. |
| **CC** | Historical name for the board-deputy (Claude Code / Chief of Staff). On the Grok path the deputy is the Grok Bot seat. |
| **Neosan** | @Neosan8_bot — OpenClaw CEO agent. Governance and publishing authority. |

---

## Agent roles

Grok game companies require three slots. Researcher and Knowledge Keeper are optional specialists. The five-slot table is the Knowledge-central portfolio only.

| Role | Required on Grok path? | Purpose | API role | Model (Grok primary) |
|------|------------------------|---------|----------|----------------------|
| **CEO** | yes | Orchestrates all work via sub-issues. Never executes directly. | `ceo` | `auto` on Cursor |
| **Worker** | yes | Executes tasks: code, files, research tasks delegated by CEO. | `engineer` | `auto` on Cursor |
| **Reviewer** | yes | Independent quality gate. Reviews all deliverables before CEO reports done to the deputy. Never reviews own work. | `qa` | `auto` on Cursor |
| **Researcher** | no | Sector scans, frontier patterns, gold-standard vetting. | `researcher` | same Cursor lock if hired |
| **Knowledge Keeper** | no | Company-internal KB curation. Weekly delta only if Knowledge-central ingest is in use. | `pm` | same Cursor lock if hired |

See `../../config/models.json` for machine-readable assignments. `latest` is forbidden. Historical Claude/Codex ids are under `legacy_five_slot`.

---

## Key concepts

| Term | Definition |
|------|------------|
| **Heartbeat** | Agent polling loop. OFF by default. CC enables when work is queued; disables when queue drains. |
| **Approval ID** | `PAPERCLIP_APPROVAL_ID` env var injected at agent wake. Must be processed first, before any other work. |
| **Checkout** | `POST /api/issues/{id}/checkout` — claim exclusive ownership of an issue. 409 = another agent already owns it; do not proceed. |
| **Role pack** | Everything a role needs to function: skills + heartbeat doc + tools doc + identity doc. Lives in `roles/<role>/`. |
| **VISION.md** | Per-company machine-readable constitution. CEO reads it every heartbeat. Schema in `../../templates/VISION.md`. |
| **SOUL.md** | CEO identity document. Defines character, quality-gate obligation, and anti-patterns for the CEO role. |
| **DoD** | Definition of Done. The mandatory deliverable checklist all roles apply before marking work complete. See `DEFINITION-OF-DONE.md`. |
| **autoreview** | Branch-diff advisory review invoked by Reviewer. Advisory only; never self-reviewed. See `../reviewer/skills.md`. |
| **review-gang** | Parallel multi-persona review pattern. Multiple Reviewer instances each check a different dimension. |
| **Source of truth** | GitHub (approved branches only). Notion and Obsidian are secondary mirrors. Agents never push unverified work to `main`. |
| **Sync ladder** | The promotion path for knowledge: company KB → weekly delta → Knowledge central → shared vault. |
| **OAuth-only rule** | Legacy five-slot: Claude via Claude.ai OAuth, GPT/Codex via ChatGPT OAuth. Grok primary: Cursor Local. Direct API keys forbidden in both. |
| **Sync bootstrap** | `standards/sync-bootstrap.sh` — merges _shared + per-role docs into company-scoped `~/Docs/paperclipcompanies/<company>/AGENTS.md`. Never touches CC's host CLAUDE.md. |

---

## Flagged ambiguities (open)

The following terms have been used inconsistently in prior docs. Use the definitions above; do not revert to old usage.

1. **"Reviewer" vs "review"** — "Reviewer" (capital R) = the dedicated required quality-gate slot. "review" (lowercase) = any act of checking work. The Reviewer agent runs autoreview; `$codex-review` is a legacy Codex worker self-check, not the Reviewer agent.
2. **"done" vs "Done"** — "done" used loosely = work is finished. "Done" (capital D) as in DoD = work has passed the Definition of Done checklist.
3. **"worker" vs "Worker"** — "Worker" (capital W) = the second agent slot. "worker" (lowercase) = any non-CEO agent doing execution work (generic).
