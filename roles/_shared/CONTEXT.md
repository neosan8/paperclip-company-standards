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
| **Central company** | One of 13 permanent Paperclip companies that own template-level functions (Market, Dev, Art, Knowledge, etc.). Never deleted. |
| **Game company** | One Paperclip company per active game title (e.g. Balloon Flow Studio). Consumes central company outputs. |
| **CC** | Claude Code — the terminal CLI agent (@Claude_Noesan8x_bot). Coordinates and delegates; never executes heavy work itself. |
| **Neosan** | @Neosan8_bot — OpenClaw CEO agent. Governance and publishing authority. |

---

## The five agent roles

Every Paperclip company — central and game — must contain exactly these five agent slots.

| Role | Purpose | Model |
|------|---------|-------|
| **CEO** | Orchestrates all work via sub-issues. Never executes directly. | claude-opus-4-7 |
| **Worker** | Executes tasks: code, files, research tasks delegated by CEO. | gpt-5.6-sol / Codex OAuth |
| **Researcher** | Sector scans, frontier patterns, gold-standard vetting. Hands to Knowledge Keeper. | gpt-5.6-sol / Codex OAuth |
| **Knowledge Keeper** | Company-internal KB curation, decision capture, weekly delta to Knowledge central. | claude-sonnet-4-6 (latest takma adı kullanılmaz — geçersiz model id, PD'yi 5 hafta durdurdu) |
| **Reviewer** | Independent quality gate. Reviews all deliverables before CEO reports done to CC. Never reviews own work. | gpt-5.6-sol / Codex OAuth |

See `../../config/models.json` for machine-readable assignments.

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
| **OAuth-only rule** | All Claude models auth via Claude.ai subscription. All GPT/Codex models auth via ChatGPT subscription. Direct API keys forbidden. |
| **Sync bootstrap** | `standards/sync-bootstrap.sh` — merges _shared + per-role docs into company-scoped `~/Docs/paperclipcompanies/<company>/AGENTS.md`. Never touches CC's host CLAUDE.md. |

---

## Flagged ambiguities (open)

The following terms have been used inconsistently in prior docs. Use the definitions above; do not revert to old usage.

1. **"Reviewer" vs "review"** — "Reviewer" (capital R) = the dedicated fifth agent slot. "review" (lowercase) = any act of checking work. The Reviewer agent runs autoreview; so does $codex-review (which is a worker self-check, not the Reviewer agent).
2. **"done" vs "Done"** — "done" used loosely = work is finished. "Done" (capital D) as in DoD = work has passed the Definition of Done checklist.
3. **"worker" vs "Worker"** — "Worker" (capital W) = the second agent slot. "worker" (lowercase) = any non-CEO agent doing execution work (generic).
