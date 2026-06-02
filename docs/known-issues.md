# Known Issues

Open questions and gaps tracked here. Check this file before making decisions that touch any of these areas.

---

## KI-PS-1 — Game-company internal structure tier

**Status:** OPEN  
**Opened:** 2026-06-02  
**Pending:** Atakan answer (Q3 2026)

**Question:** What is the correct internal agent structure for a per-game company?

Three candidate models:

- **Lean** — game company has CEO + Worker only; all specialist work (art, animation, SFX, test) stays in central companies via cross-company issues.
- **Full-mirror** — game company replicates all 13 central roles internally; fully self-contained.
- **Tiered** — game company has CEO + Worker + Knowledge Keeper + Researcher internally; everything else (art, SFX, test) is still handled by central handoff.

**Impact:** determines how many agents are created per new game company and how cross-company issue routing is configured.

**Workaround until resolved:** use the tiered model (CEO + Worker + Knowledge Keeper + Researcher) as the safe default. Do not spin up art/animation/SFX/test agents inside game companies without Atakan confirmation.

---

## KI-PS-2 — Knowledge company validation mechanism

**Status:** OPEN  
**Opened:** 2026-06-02  

**Question:** How does the Knowledge company validate that all running companies conform to this standards repo when a new version tag is published?

Candidate mechanisms:
- GitHub Action triggered on tag; queries Paperclip API to iterate companies and check config fields.
- Heartbeat-driven check: Knowledge CEO runs a validation issue against each company on next heartbeat after detecting a new tag.
- Manual: CC runs the checklist on tag publish.

**Impact:** determines whether version compliance can be automated or stays manual.

**Workaround:** CC runs `docs/flows/new-company-checklist.md` manually on each version bump until an automated mechanism is decided and built.

---

## KI-PS-3 — Central company UUIDs in config/central-companies.json are placeholders

**Status:** OPEN  
**Opened:** 2026-06-02  

**Details:** `config/central-companies.json` does not include real Paperclip UUIDs. The last verified UUID snapshot was 2026-04-26 and may be stale.

**Resolution:** Run `paperclip_list_companies` via the Paperclip MCP and update the `uuid` field for each entry in `config/central-companies.json`. Commit as a patch bump.

**Impact:** agents that need to reference a company by UUID (e.g. for cross-company issue creation) must run `paperclip_list_companies` at runtime rather than reading from config until this is resolved.
