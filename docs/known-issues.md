# Known Issues

Open questions and gaps tracked here. Check this file before making decisions that touch any of these areas.

---

## KI-PS-1 — Game-company internal structure tier

**Status:** RESOLVED  
**Opened:** 2026-06-02  
**Closed:** 2026-06-02  
**Resolution:** Atakan decision 2026-06-02 — all companies (central and game) use the full five-slot model: CEO + Worker + Researcher + Knowledge Keeper + Reviewer. No lean or full-mirror variants. See `docs/company-architecture.md` and `config/roles.json`.

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

**Workaround:** CC runs `flows/new-company-checklist.md` manually on each version bump until an automated mechanism is decided and built.

---

## KI-PS-3 — Central company UUIDs in config/central-companies.json are placeholders

**Status:** RESOLVED  
**Opened:** 2026-06-02  
**Closed:** 2026-06-02  
**Resolution:** All 13 UUIDs populated in v0.2.1 via `paperclip_list_companies` audit 2026-06-02. Creatives and Knowledge UUIDs verified but marked `_archived: true` (Phase B unarchive pending). `_warning` field updated to reflect verified state. Also documented in the v0.2.1 release.

---

## KI-PS-4 — VISION.md migration: existing companies lack VISION.md

**Status:** OPEN
**Opened:** 2026-06-02
**Owner:** Knowledge company (KNO)

**Details:** v0.2.0 introduces a VISION.md per-company constitution (schema at `templates/VISION.md`). None of the 13 existing central companies or the current game companies have a VISION.md yet. Each VISION.md must be extracted from Memory + Notion per-company context and written by the company CEO.

**Resolution:** Knowledge company leads the migration. For each company: KNO creates a `[bootstrap] Create VISION.md for <company-name>` issue assigned to that company's CEO. CEOs use `templates/VISION.md` as the schema. KNO tracks progress on a standing aggregation issue.

**Impact:** Until migrated, companies run without a machine-readable constitution. CEOs cannot formally complete the heartbeat Step 2 check. Treat existing companies as running in "legacy mode" until their VISION.md is created.

---

## KI-PS-5 — Reviewer agent slot missing from all 13 existing companies

**Status:** OPEN
**Opened:** 2026-06-02
**Depends on:** KI-PS-4 (VISION.md migration), standards repo v0.2.0 landing

**Details:** v0.2.0 adds the Reviewer as a mandatory 5th agent slot per company. None of the 13 central companies or current game companies have a Reviewer agent configured. Until Reviewer agents are created and bootstrapped, the quality gate described in `standards/reviewer-pattern.md` cannot run.

**Progress (2026-06-02):** SFX & Haptic created 2026-06-02 as Phase A test case (company UUID `0f518a7a-18d6-472f-af47-5e4e514b6c53`). Reviewer agent (UUID `88482941-7317-4ac1-96f3-18b5467994bd`) created with all 5 slots. Phase B bulk-fix on 11 existing companies still pending.

**Resolution:** After v0.2.0 tag on main branch, CC bulk-creates Reviewer agent slots across all 13 central companies and existing game companies. Each Reviewer must run through the bootstrap activation checklist (`templates/CEO_BOOTSTRAP.md` Step 7). Estimated: 13+ Reviewer agents to create.

**Impact:** Until resolved, all companies are operating with a 4-slot model. Worker Done reports cannot have a Reviewer verdict. CEOs must note this in their Done reports to CC.

---

## KI-PS-7 — SFX & Haptic full bootstrap pending

**Status:** OPEN
**Opened:** 2026-06-02

**Details:** SFX & Haptic company (UUID `0f518a7a-18d6-472f-af47-5e4e514b6c53`) was created Phase A with all 5 agent slots.

**Progress (2026-06-03 — Steps A + B COMPLETE):**
- VISION.md created
- SOUL.md created
- Company folder at `~/Docs/paperclipcompanies/sfx-haptic/_knowledge-base/` created
- CEO bootstrap issue SFX-1 created
- Researcher brief delivered to `~/Docs/paperclipcompanies/sfx-haptic/_knowledge-base/research/`
- Issues SFX-3 (Researcher), SFX-4 (Keeper), SFX-5 (Reviewer) created

**Remaining (Steps C + D + E):**
- Step C: Knowledge Keeper wiki synthesis (blocked on SFX-3 close)
- Step D: CEO specialist roster recommendation → CC + Atakan decision
- Step E: Specialist provisioning based on roster decision

**Resolution:** Close once Step D specialist roster is documented in `docs/decisions/specialist-roster-v1.md` and Step E provisioning is complete.

**Impact:** SFX & Haptic is Phase A bootstrapped. Phase B (Steps C-E) pending.

---

## KI-PS-6 — sync-bootstrap.sh dry-run gate

**Status:** RESOLVED  
**Opened:** 2026-06-02  
**Closed:** 2026-06-03  
**Resolution:** RESOLVED in v0.2.2 — script rewritten with `--dry-run` flag + company-scoped paths only + CC host CLAUDE.md never touched. Output target is now `~/Docs/paperclipcompanies/<company-name>/AGENTS.md` (configurable via `--target`). Old writes to `~/CLAUDE.md` and `~/.claude/CLAUDE.md` removed entirely.

---

## KI-PS-8 — SFX-2 rogue issue: CC created Researcher-direct issue

**Status:** RESOLVED  
**Opened:** 2026-06-03  
**Closed:** 2026-06-03  

**Details:** CC created issue SFX-2 assigned directly to the Researcher agent of SFX & Haptic, bypassing the CEO. This violated the CC-to-CEO-only rule.

**How caught:** Atakan flagged it directly: *"paperclip sirketlerini yonetirken sadece ceo ile konusman lazim biliyorsun zaten"*.

**Resolution:** CC wrote the CC-to-CEO-only rule into `~/CLAUDE.md` (loaded every CC session). `standards/cc-paperclip-communication-protocol.md` added in v0.2.2 so the Knowledge company can validate conformance. SFX-2 is retained as a historical record (task was already completed by Researcher); no retroactive cleanup needed.

**Impact for future companies:** All CC-created issues must be assigned to the company CEO. CEO delegates to specialists via sub-issues.
