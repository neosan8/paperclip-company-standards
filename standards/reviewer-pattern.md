# Reviewer Gate Flow — End-to-End Pattern

This document describes the complete flow from Worker done to CEO reporting Done to CC. Every company follows this pattern.

---

## The gate flow

```
Worker completes deliverable
        |
        v
Worker runs DoD self-check (5 steps)
        |
        v
Worker updates issue status to "review"
Worker posts done comment with deliverable location
        |
        v
CEO reads done comment
CEO verifies deliverable location is specified
        |
        v
CEO creates review sub-issue: [review] PREFIX-NN
CEO assigns to Reviewer
CEO flips review sub-issue to "todo"
        |
        v
Reviewer picks up review sub-issue
Reviewer runs autoreview on branch diff
Reviewer runs review-gang personas
Reviewer runs dod-check (verifies Worker's self-check claims)
        |
        v
Reviewer issues verdict (Round 1)
        |
        +------- ship it ---------> CEO closes PREFIX-NN
        |                           CEO reports Done to CC
        |                           CC asks Neosan to sync GitHub + Notion
        |
        +--- needs review -------> CEO opens fix sub-issue: PREFIX-NN-fix
        |                           CEO assigns to Worker
        |                           Worker fixes; re-does DoD self-check
        |                           Worker posts updated done comment
        |                           CEO re-triggers Reviewer (Round 2)
        |
        +------- blocked ---------> CEO escalates to CC immediately
                                    CEO posts verdict context on issue
                                    No merge. No close. Await CC direction.
```

---

## Round tracking

Each re-run of the Reviewer on the same issue is a new round. Maximum 3 rounds.

| Round | Verdict | Action |
|-------|---------|--------|
| 1 | ship it | Done — close + report |
| 1 | needs review | Fix sub-issue → Round 2 |
| 2 | ship it | Done — close + report |
| 2 | needs review | Fix sub-issue → Round 3 |
| 3 | ship it | Done — close + report |
| 3 | needs review | Auto-upgrade to `blocked`; escalate to CC |
| Any | blocked | Escalate to CC immediately |

---

## After ship it: sync GitHub + Notion

After CEO reports Done to CC, the CC-to-Neosan handoff is:

1. CC tells Neosan: "PREFIX-NN is Done. Reviewer `ship it`. Deliverable at [location]."
2. Neosan approves the merge from `working` to `test`.
3. CC runs the `test` → `main` promotion after Atakan approval.
4. Neosan syncs the relevant artifact to Notion (documentation, design decisions).

CC never merges to `test` or `main` without Neosan's explicit approval.
Neosan never merges to `main` without Atakan's explicit approval.

---

## What the Reviewer is NOT

- Not a replacement for the Worker's self-check. Both run independently.
- Not a gatekeeper that can be bypassed "just this once." Every deliverable goes through the Reviewer.
- Not an accelerator. The Reviewer's job is quality, not speed. If the Reviewer takes time, that time is correctly spent.
- Not a bottleneck to blame when a deliverable is slow. A slow Reviewer verdict means the Worker delivered something that needed fixing. Fix the Worker's discipline, not the Reviewer gate.
