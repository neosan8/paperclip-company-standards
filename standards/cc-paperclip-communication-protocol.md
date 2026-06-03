# CC ↔ Paperclip Communication Protocol

**Status:** Canonical  
**Introduced:** v0.2.2  
**Atakan-canonical:** 2026-06-03  

---

## The Rule

CC talks only to the CEO of each Paperclip company. Never directly to Workers, Researchers, Knowledge Keepers, or Reviewers.

---

## Why

The CEO is the SOUL-driven quality gate for the company. Bypassing the CEO:

- Fragments verification — no single agent owns the quality check
- Erodes accountability — Worker output has no CEO attestation before reaching CC
- Normalizes rule-circumvention — each shortcut makes the next easier to justify

The CEO exists precisely to absorb coordination complexity so CC does not have to.

---

## The Stack

```
Atakan (Founder / Board)
    ↕
CC (executive coordinator, Chief of Staff)
    ↕
CEO (company orchestrator + quality gate)
    ↕
Worker / Researcher / Knowledge Keeper / Reviewer
```

CC is accountable to Atakan. CEO is accountable to CC. Workers/Specialists are accountable to CEO.

---

## What CC May Do Directly

- Create CEO-level bootstrap or strategic issues (assigned to CEO)
- Toggle CEO heartbeat / runtimeConfig
- Read any agent's status or output for monitoring purposes
- Reassign CEO bootstrap issue ownership when founding a new company

---

## What CC May NOT Do Directly

- Create issues assigned to Workers, Researchers, Knowledge Keepers, or Reviewers
- Toggle non-CEO heartbeats
- Update worker or specialist capability text without CEO knowledge
- Bypass the Reviewer ship-it gate by marking issues Done without a Reviewer verdict

---

## Standard Sequence for a New Company Task

1. **Atakan → CC:** high-level direction or goal
2. **CC creates CEO issue** describing the goal, success criteria, and any constraints
3. **CEO reads issue**, plans sub-issues, assigns to Worker(s) or appropriate specialist
4. **Worker(s) execute**, run self-check (DoD), mark done
5. **Reviewer issues verdict** (`ship it` / `needs review` / `blocked`)
6. **CEO verifies independently**, closes parent issue, reports up to CC
7. **CC summarizes to Atakan**

---

## Lessons Learned: SFX-2 Incident (2026-06-03)

**What happened:** CC created issue SFX-2 assigned directly to the Researcher agent of the SFX & Haptic company, bypassing the CEO.

**How it was caught:** Atakan flagged it: *"paperclip sirketlerini yonetirken sadece ceo ile konusman lazim biliyorsun zaten"* ("you already know you must talk only to the CEO when managing Paperclip companies").

**Resolution:**
- CC wrote the CC-to-CEO-only rule into `~/CLAUDE.md` (loaded every CC session)
- This document was added to `standards/` in v0.2.2 so the Knowledge company can validate it
- SFX-2 is kept as historical record (task was already completed by Researcher); no retroactive cleanup needed

**Rule:** If in doubt about who to assign an issue to, assign it to the CEO. The CEO will delegate appropriately.

---

## References

- `roles/ceo/SOUL.md` — CEO identity: quality-gate obligation
- `feedback_ceo_never_executes.md` (CC memory) — absolute rule: CEO orchestrates only
- `docs/flows/new-company-checklist.md` — new company bootstrap sequence (CC creates only CEO-level issues)
