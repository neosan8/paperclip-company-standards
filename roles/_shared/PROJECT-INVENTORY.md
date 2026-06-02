# Project Inventory Template

CEO reads this file at the start of every heartbeat cycle, before delegating any work.
Copy this template into each company's root as `PROJECT-INVENTORY.md` and fill in all fields.
If this file is stale (last updated more than 7 days ago), update it before issuing any new sub-issues.

---

## Company identity

| Field | Value |
|-------|-------|
| Company name | _fill in_ |
| Paperclip prefix | _fill in_ |
| VISION.md location | `VISION.md` (root) |
| Last inventory update | _YYYY-MM-DD_ |

---

## Current sprint goal

_One sentence. What does Done look like for this sprint?_

---

## Open issues

| Issue ID | Title | Assignee | Status | Blocked by |
|----------|-------|----------|--------|------------|
| PREFIX-NN | _title_ | worker/researcher/keeper/reviewer | todo / in-progress / review | — or PREFIX-NN |

Rules:
- Only list issues in `todo` or `in-progress` or `review`. Backlog items are not listed here.
- An issue must be flipped from `backlog` to `todo` before it appears in this table.
- If an issue has been `in-progress` for more than 3 days with no commit, flag it as stalled.

---

## Recent completions (last 14 days)

| Issue ID | Title | Reviewer verdict | Completed date |
|----------|-------|-----------------|----------------|
| PREFIX-NN | _title_ | ship it | YYYY-MM-DD |

---

## Blocked items

List anything blocked externally (awaiting Atakan approval, awaiting a central-company output, awaiting CC response).

| Issue ID | Blocked on | Since |
|----------|-----------|-------|
| — | — | — |

---

## Knowledge Keeper status

- Last KB update: _YYYY-MM-DD_
- Last weekly delta sent to Knowledge central: _YYYY-MM-DD_
- Pending decisions to capture: _list or "none"_

---

## Reviewer status

- Last review run: _YYYY-MM-DD_ (PREFIX-NN)
- Reviewer agent: running / not yet bootstrapped
- Pending reviews: _list issue IDs or "none"_

---

## Notes for CEO

_Free-form. Record any context that affects issue prioritization. Delete stale entries._
