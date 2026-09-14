# Board / deputy ↔ Paperclip Communication Protocol

**Status:** Canonical
**Introduced:** v0.2.2
**Atakan-canonical:** 2026-06-03
**Grok Bot seat as board-deputy:** 2026-09-14 (Neo / Atakan)

---

## The Rule

The board-deputy talks only to the CEO of each Paperclip company. Never directly to Workers, Researchers, Knowledge Keepers, or Reviewers.

On the Grok path the board-deputy **is the Grok Bot seat**. Historical name in this doc was CC (Claude Code / Chief of Staff). Same rule, same stack: Founder → deputy → CEO → specialists. The deputy does not become a fourth required agent inside the company.

---

## Why

The CEO is the SOUL-driven quality gate for the company. Bypassing the CEO:

- Fragments verification — no single agent owns the quality check
- Erodes accountability — Worker output has no CEO attestation before reaching the deputy
- Normalizes rule-circumvention — each shortcut makes the next easier to justify

The CEO exists precisely to absorb coordination complexity so the board-deputy does not have to.

---

## CEO idle of production (Neo / Atakan 2026-09-14)

The board-deputy wakes the CEO to **orchestrate**, not to produce. The CEO remains idle of production execution: it creates sub-issues for Worker (produce: code, docs, art) and Reviewer (independent quality gate). The CEO does not write or produce deliverables itself.

Heartbeat OFF is not this rule. Heartbeat OFF is a wake-loop setting. Idle of production work is the behavioral rule while the CEO is awake.

This lock does not weaken Reviewer independence. The deputy still must not bypass the Reviewer ship-it gate.

Source: `roles/ceo/SOUL.md`.

---

## The Stack

```
Atakan (Founder / Board)
    |
Grok Bot seat (board-deputy)  — historically CC
    |
CEO (company orchestrator + quality gate)
    |
Worker / Reviewer
    |
Researcher / Knowledge Keeper   (optional specialists only)
```

The deputy is accountable to Atakan. CEO is accountable to the deputy. Workers/Specialists are accountable to CEO.

---

## What the board-deputy (Grok Bot seat) May Do Directly

- Create CEO-level bootstrap or strategic issues (assigned to CEO)
- Toggle CEO heartbeat / runtimeConfig
- Read any agent's status or output for monitoring purposes
- Reassign CEO bootstrap issue ownership when founding a new company

---

## What the board-deputy May NOT Do Directly

- Create issues assigned to Workers, Researchers, Knowledge Keepers, or Reviewers
- Toggle non-CEO heartbeats
- Update worker or specialist capability text without CEO knowledge
- Bypass the Reviewer ship-it gate by marking issues Done without a Reviewer verdict

---

## Standard Sequence for a New Company Task

1. **Atakan → Grok Bot seat (board-deputy):** high-level direction or goal
2. **Deputy creates CEO issue** describing the goal, success criteria, and any constraints, then wakes the CEO to orchestrate
3. **CEO reads issue**, remains idle of production, plans sub-issues, assigns to Worker (produce) and later Reviewer (independent gate). Optional specialists only if they already exist. The CEO does not implement.
4. **Worker(s) execute**, run self-check (DoD), mark done
5. **Reviewer issues verdict** (`ship it` / `needs review` / `blocked`)
6. **CEO verifies independently**, closes parent issue, reports up to the deputy
7. **Deputy summarizes to Atakan**

---

## Lessons Learned: SFX-2 Incident (2026-06-03)

**What happened:** CC created issue SFX-2 assigned directly to the Researcher agent of the SFX & Haptic company, bypassing the CEO.

**How it was caught:** Atakan flagged it: *"paperclip sirketlerini yonetirken sadece ceo ile konusman lazim biliyorsun zaten"* ("you already know you must talk only to the CEO when managing Paperclip companies").

**Resolution:**
- CC wrote the CC-to-CEO-only rule into `~/CLAUDE.md` (loaded every CC session)
- This document was added to `standards/` in v0.2.2 so the Knowledge company can validate it
- SFX-2 is kept as historical record (task was already completed by Researcher); no retroactive cleanup needed

**Rule:** If in doubt about who to assign an issue to, assign it to the CEO. The CEO will delegate appropriately. The Grok Bot seat follows the same rule.

---

## References

- `roles/ceo/SOUL.md` — standing source: idle of production / orchestrate only (Neo / Atakan 2026-09-14)
- `docs/flows/new-company-checklist.md` — new company bootstrap sequence (deputy creates only CEO-level issues)
- `docs/operator-stack.md` — MCP / CLI / browser layers the Grok Bot seat uses
