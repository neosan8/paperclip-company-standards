# Weekly Aggregation Handoff — Knowledge Keeper → Knowledge Central

Every week, the Knowledge Keeper sends a delta to the central Knowledge company. This feeds the studio-wide KB and enables the Knowledge CEO to maintain the shared vault.

---

## Cadence

- **Day:** Sunday or Monday (start of the studio week).
- **Frequency:** every 7 days. A gap of more than 7 days is a workflow violation; escalate to CEO.
- **Trigger:** CEO creates a "weekly delta" issue for the Knowledge Keeper, or the Keeper creates it proactively if the CEO has not done so by Monday.

---

## What the delta contains

The delta covers the prior 7 days only. It does not repeat previously sent content.

```
# Weekly Delta — <Company Name>
Week: YYYY-WNN (YYYY-MM-DD to YYYY-MM-DD)
Knowledge Keeper: <agent handle>
Issue: PREFIX-NN

## New decisions (N)
- [YYYY-MM-DD] <decision title> — <one sentence summary> — ref: PREFIX-NN

## New research briefs ingested (N)
- [YYYY-MM-DD] <topic> — <one sentence finding> — ref: PREFIX-NN, KB: <path>

## New patterns added (N)
- <pattern name> — <one sentence> — KB: <path>

## Decay flags raised (N)
- <entry path> — age: N days — action: review / archive

## Recommended cross-company knowledge items
Items that may be relevant to other companies or to the central KB:
- <item title> — <why it is cross-company relevant> — KB: <path>
```

---

## How to send

**Option A — Paperclip cross-company issue (preferred)**

Create a cross-company issue targeted at the Knowledge company (prefix KNO):

```
Title: [weekly-delta] <Company Name> WNN
Assignee: KNO Knowledge Keeper
Attach: weekly delta file (path on `docs/<topic>` branch, PR target main)
```

**Option B — Paperclip issue comment on a standing KNO aggregation issue**

If Knowledge central has a standing "weekly aggregation" issue, post the delta as a comment there.

---

## 403 error on cross-company POST

If the cross-company issue creation (Option A above) returns the error `403 Agent key cannot access another company`, the most likely cause is the Knowledge company being archived -- not a permissions issue with the agent key. Do not retry the POST. Do not spawn indefinite coord chains waiting for the call to succeed.

**Escalation path:** Create a coord sub-issue on the local company CEO with title: `[escalate] Knowledge company unreachable -- 403 on cross-company POST`. The CEO forwards it to CC. CC verifies the Knowledge company status and unarchives if needed.

---

## What happens after sending

The Knowledge CEO (KNO) acknowledges receipt on the cross-company issue. The local Knowledge Keeper archives the delta file to `weekly-deltas/YYYY-WNN.md` in the local KB and closes the issue.

If no acknowledgment within 48 hours, the local Knowledge Keeper pings the Knowledge CEO again and escalates to CC if still no response after 72 hours.

---

## Recommended cross-company items

Before sending the delta, the Knowledge Keeper reviews the week's entries and flags any that are:
- A pattern applicable beyond this company.
- A decision that should inform a standards update (candidate for this repo).
- A research finding with studio-wide implications.

These are surfaced in the "Recommended cross-company knowledge items" section. It is the Knowledge CEO's job to decide what enters the central KB; the local Keeper only nominates.
