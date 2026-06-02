# Knowledge Keeper Skills

---

## brief-ingestion

**Purpose:** Take a research brief from the Researcher and add it to the company KB as a structured entry.

**Pattern:**
1. Fetch the brief file from the path provided in the handoff issue.
2. Extract: topic, findings, sources, recommended actions.
3. Create a KB entry in the correct section per `wiki-pattern.md`.
4. Apply tags from the company tag set (use gbrain to verify tag consistency).
5. Add graphify nodes for any new concepts introduced.
6. Cross-link to related existing entries.
7. Post confirmation comment on the handoff issue with: KB entry path, tags applied, cross-links added.

---

## decision-capture

**Purpose:** Extract and preserve decisions made during issue resolution.

Run after every CEO heartbeat cycle closes issues. For each closed issue:
- Was a decision made? (architectural, tooling, process, or product)
- If yes: create a KB decision record with: decision, rationale, date, issue reference, decision-maker.

Decision record format:
```
## Decision: <title>

**Date:** YYYY-MM-DD
**Issue:** PREFIX-NN
**Decision-maker:** CEO / CC / Neosan / Atakan
**Decision:** <one sentence>
**Rationale:** <1-3 sentences>
**Alternatives considered:** <brief list or "none">
**Review date:** YYYY-MM-DD (set to 6 months out for significant decisions)
```

---

## decay-management

**Purpose:** Prevent KB from becoming a graveyard of stale entries.

Run monthly (or when CEO assigns a decay-check issue).

**Rules:**
- Flag any entry in a fast-moving section (AI tools, Unity versions, competitor analysis) that is older than 90 days as `[REVIEW NEEDED]`.
- Flag any entry in a stable section (company decisions, architecture, process docs) older than 180 days as `[VERIFY STILL CURRENT]`.
- Do not delete entries — archive them to a `_archived/` subfolder and add a forwarding note in the original location.
- Create a decay report: list all flagged entries with age and recommended action. Post as a CEO issue comment.

---

## taxonomy-management

**Purpose:** Keep tags and sections consistent across the KB.

**Tag rules:**
- Tags must come from the established tag set (query gbrain for current tags).
- Introducing a new tag requires a CEO-approved taxonomy issue. Do not add ad-hoc tags.
- Every entry must have at least one tag.
- Rename tags via a taxonomy migration issue; never rename in-place across 10+ files without a migration plan.

---

## gbrain-sync

**Purpose:** Keep gbrain index current with new KB entries.

After every batch of new KB entries (brief ingestion, decision capture, weekly delta prep):
- Run gbrain sync to ensure new entries are indexed and searchable.
- Verify with a sample query that the new entries are retrievable.
