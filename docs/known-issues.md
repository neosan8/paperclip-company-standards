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

**Status:** OPEN  
**Opened:** 2026-06-02  

**Details:** `config/central-companies.json` does not include real Paperclip UUIDs. The last verified UUID snapshot was 2026-04-26 and may be stale.

**Resolution:** Run `paperclip_list_companies` via the Paperclip MCP and update the `uuid` field for each entry in `config/central-companies.json`. Commit as a patch bump.

**Impact:** agents that need to reference a company by UUID (e.g. for cross-company issue creation) must run `paperclip_list_companies` at runtime rather than reading from config until this is resolved.

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

**Resolution:** After v0.2.0 tag on main branch, CC bulk-creates Reviewer agent slots across all 13 central companies and existing game companies. Each Reviewer must run through the bootstrap activation checklist (`templates/CEO_BOOTSTRAP.md` Step 7). Estimated: 13+ Reviewer agents to create.

**Impact:** Until resolved, all companies are operating with a 4-slot model. Worker Done reports cannot have a Reviewer verdict. CEOs must note this in their Done reports to CC.

---

## KI-PS-6 — sync-bootstrap.sh not yet validated in production

**Status:** OPEN
**Opened:** 2026-06-02

**Details:** `standards/sync-bootstrap.sh` is scaffolded and passes `bash -n` syntax check, but has not been run against a real Paperclip company environment. File paths, vault locations, and symlink behavior need a dry-run on a sandbox company.

**Resolution:** Before using in production bootstrap: CC runs `bash standards/sync-bootstrap.sh --role=ceo --company=sandbox-test` on a test company. Verify `~/.codex/AGENTS.md` is written correctly and `~/.claude/CLAUDE.md` symlink is verified. Document any path adjustments needed. Update script and close this KI.

**Impact:** Do not use `sync-bootstrap.sh` in production until this is validated. Manual AGENTS.md assembly is the fallback (follow the script's logic manually).
