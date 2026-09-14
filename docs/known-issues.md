# Known Issues

Open questions and gaps tracked here. Check this file before making decisions that touch any of these areas.

---

## KI-PS-1 — Game-company internal structure tier

**Status:** SUPERSEDED for Grok Bot seats; five-slot remains the Knowledge-central portfolio standard  
**Opened:** 2026-06-02  
**Closed (five-slot):** 2026-06-02  
**Superseded (Grok seats):** 2026-09-14 — Neo (Atakan)

**2026-06-02 resolution:** all companies (central and game) in the Knowledge-central portfolio use the full five-slot model: CEO + Worker + Researcher + Knowledge Keeper + Reviewer. Lean (CEO + Worker only) was rejected for that portfolio.

**2026-09-14 supersession:** Grok Bot seats create **3-slot Cursor** game companies: CEO + Worker + Reviewer. Researcher and Knowledge Keeper are optional specialists, not mandatory standing slots. Grok seats do not bootstrap the 13-central layer. See `docs/company-architecture.md` and `config/roles.json`.

The five-slot resolution is not deleted. It is not the spawn path for Grok Bot seats.

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

**Impact (Knowledge-central portfolio):** Until resolved, those companies are operating with a 4-slot model. Worker Done reports cannot have a Reviewer verdict. CEOs must note this in their Done reports to CC.

**Grok Bot seats (2026-09-14):** not a Grok spawn task. Grok-created game companies hire Reviewer as one of the three required slots on day one (`reviewer_must_exist` stays true). Do not bulk-create Reviewer seats across the 13 centrals from a Grok game seat.

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

**Impact for future companies:** All board/deputy-created issues must be assigned to the company CEO. CEO delegates to specialists via sub-issues. The Grok Bot seat is the board-deputy; same rule.

---

## KI-PS-9 — Cursor `auto` may be rejected by some Cursor CLI versions

**Status:** OPEN  
**Opened:** 2026-09-14  
**Owner:** Neo (Atakan)

**Details:** Paperclip Cursor Local documents `auto` as the default model ([Cursor Local](https://docs.paperclip.ing/reference/adapters/cursor-local/), verified 2026-09-14). Some Cursor CLI versions have rejected `auto` (upstream `paperclipai/paperclip#1357`). The Grok seat standard remains `auto` until Neo pins a concrete Cursor model id.

**Do not:** invent a replacement id, silently switch to `composer-2` or any other unverified string, or fall back to Claude/Codex adapters.

**Workaround:** if hire or wake fails because `auto` is not accepted, stop and escalate to Neo. Concrete ids beat aliases only when Neo supplies the id.
