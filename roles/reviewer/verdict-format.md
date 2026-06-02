# Verdict Format

The Reviewer posts exactly one verdict comment per review round on the Paperclip issue.
Use this format. Do not deviate.

---

## Verdict vocabulary

Three valid verdicts only:

| Verdict | Meaning |
|---------|---------|
| `ship it` | Deliverable meets all DoD criteria. No blocking findings. Ready to merge and report Done. |
| `needs review` | One or more blocking findings. Deliverable cannot ship until addressed. Worker fix required. |
| `blocked` | Round cap reached (3), or an escalation-class problem found. CEO must escalate to CC. |

No other verdicts. Do not use: "looks good", "mostly fine", "minor issues", "approved with comments". Use the three above.

---

## Verdict comment template

```
## Reviewer Verdict — PREFIX-NN (Round N)

**Verdict:** ship it / needs review / blocked
**Date:** YYYY-MM-DD
**Reviewer:** <agent handle>
**autoreview run:** yes / no (reason if no)
**Personas run:** correctness, karpathy, [security / performance / accessibility]

---

### Blocking findings (N)

<!-- Only present if verdict is "needs review" or "blocked" -->

#### Finding 1 — <title>

**Severity:** blocking
**Location:** <file:line or section>
**Description:** <what is wrong>
**Required fix:** <exactly what needs to change>

---

### Advisory findings (N)

#### Finding N+1 — <title>

**Severity:** advisory
**Location:** <file:line or section>
**Note:** <observation — no action required to ship>

---

### DoD verification

- [x/o] Deliverable exists at claimed location
- [x/o] Deliverable matches acceptance criteria
- [x/o] No placeholders found
- [x/o] No duplicates

---

### Accepted items (if applicable)

<!-- List any advisory findings the CEO has pre-accepted with rationale -->

---

### Next action

<!-- For "ship it": "CEO: close PREFIX-NN and report Done to CC." -->
<!-- For "needs review": "Worker: address findings above. CEO: open fix sub-issue PREFIX-NN-fix." -->
<!-- For "blocked": "CEO: escalate PREFIX-NN to CC with this verdict." -->
```

---

## What the CEO does with each verdict

- `ship it` → close the issue; report Done to CC including this verdict comment reference.
- `needs review` → open a fix sub-issue; assign to Worker; hold parent issue open.
- `blocked` → post this verdict to CC immediately; do not close or merge.

---

## Round annotation

Always note the round number in the verdict header: `Round 1`, `Round 2`, `Round 3`.
If this is Round 3 and the verdict is not `ship it`, automatically upgrade to `blocked` unless CC has explicitly authorized a Round 4.
