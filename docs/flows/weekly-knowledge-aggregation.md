# Weekly Knowledge Aggregation

Playbook for the weekly CC-run (or designated subagent) process that pulls per-company KB deltas and merges them into the central Studio Wiki.

---

## Frequency

Weekly. Default window: Monday morning before studio standby.

---

## Who runs it

CC (Claude Code, Neosan M1 Air) or a designated CC subagent. The Knowledge company CEO oversees and applies the Hermes review gate before any merge to the central vault.

---

## Inputs

- Each active company's Knowledge Keeper weekly delta: `_knowledge-base/<company-prefix>/weekly-delta/YYYY-WW.md`
- Previous week's aggregation record (for diff context)

---

## Outputs

- Updated central Studio Wiki entries at `~/Docs/paperclipcompanies/_knowledge-base/`
- Aggregation record: `_knowledge-base/aggregations/YYYY-WW-aggregation.md`

---

## Steps

### 1. Pull all weekly deltas

For each active company:
- [ ] Read `_knowledge-base/<company-prefix>/weekly-delta/YYYY-WW.md`
- [ ] Note: if a company has no delta this week, log it as `no-delta` in the aggregation record. Do not treat silence as an error — Knowledge Keeper may have had nothing new.

### 2. Review deltas for quality (Hermes gate)

Knowledge company CEO applies Hermes review gate:
- [ ] Check each delta for completeness (topic + date + finding + source + actionability).
- [ ] Flag any delta that is raw dump (not structured) — return to originating Knowledge Keeper for reformat before merging.
- [ ] Flag any delta with unverified external sources — Researcher must confirm before merge.

### 3. Merge into central vault

For each approved delta:
- [ ] Identify target section in the central vault (by company prefix and topic).
- [ ] Append new decisions to `_knowledge-base/decisions/` with date prefix.
- [ ] Update open questions: close any that were answered this week; add any newly surfaced.
- [ ] Update the company's context note if its role or active projects changed.

### 4. Write aggregation record

Create `_knowledge-base/aggregations/YYYY-WW-aggregation.md`:
- Companies that submitted deltas: list with brief summary of each
- Companies with no delta: list
- Deltas returned for rework: list with reason
- Notable decisions merged this week
- Open questions count (before / after)

### 5. Knowledge company CEO closes the week

- [ ] Knowledge CEO reviews aggregation record.
- [ ] Marks aggregation as complete.
- [ ] Notifies CC via Paperclip issue close.
- [ ] CC sends brief report to Neosan (Telegram or Paperclip comment).

---

## Escalation

If a company's Knowledge Keeper has missed 2 consecutive weekly deltas:
- CC creates an issue in that company addressed to the CEO: "Knowledge Keeper has not submitted weekly deltas for 2 weeks. Investigate and restore."
- Flip to `todo`, turn heartbeat ON.

---

## Notes

- The aggregation vault is the shared vault; all companies read from it. Keep entries factual and source-cited.
- Do not merge speculative or unvalidated findings. When in doubt, park in `open-questions.md` rather than assert as fact.
