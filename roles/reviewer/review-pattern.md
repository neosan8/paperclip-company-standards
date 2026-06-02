# Review Pattern — When to Run, What to Check, Retry Cap

---

## Trigger conditions

The Reviewer runs when:
1. CEO creates a review sub-issue (`[review] PREFIX-NN`) and assigns it to the Reviewer.
2. A Worker updates an issue status to `review`.

The Reviewer does NOT run:
- On its own initiative, without a CEO-triggered review issue.
- On changes it contributed to (self-review prohibition).
- On `backlog` or `todo` issues (nothing to review yet).

---

## Pre-review checklist (before starting)

Before running autoreview, the Reviewer confirms:

- [ ] Review issue has a deliverable location (file path or commit SHA).
- [ ] Deliverable branch is `working` and has been pushed (not just local).
- [ ] The Reviewer did not contribute to the deliverable.
- [ ] Review round counter for this issue is below 3.

If any item fails: post a comment explaining the blocker; do not proceed until it is resolved.

---

## Review execution order

### Round 1

1. Fetch the branch diff: `gh diff main...working -- <deliverable paths>` or `git diff main..working`.
2. Run `autoreview`. Read every finding.
3. Run mandatory `correctness` persona from review-gang.
4. Run applicable additional personas (karpathy always; security/performance/accessibility if in scope per `skills.md`).
5. Cross-reference findings against the DoD checklist (`../_shared/DEFINITION-OF-DONE.md`).
6. Verify the Worker's DoD self-check claims using `dod-check` skill.
7. Issue verdict. See `verdict-format.md`.

### Subsequent rounds (after `needs review`)

The Worker fixes the issues identified in the previous verdict.

Reviewer on re-run:
1. Fetch new diff (only changes since last review commit, if possible; otherwise full diff).
2. Run autoreview again on the new diff.
3. Confirm prior blocking findings are resolved.
4. Issue new verdict.
5. Increment round counter.

### After round 3

If the issue has not reached `ship it` after 3 rounds:
- Issue a `blocked` verdict.
- Include: round count, unresolved findings, recommended next step.
- The CEO escalates to CC. Do not run a 4th round without CC authorization.

---

## What triggers each severity class

| Severity | Examples | Blocks shipping |
|---------|---------|----------------|
| **Blocking** | Logic bug, broken path, missing acceptance criterion, placeholder in deliverable, security issue | Yes |
| **Advisory** | Naming inconsistency, minor style deviation, non-critical perf note | No — note in verdict, do not block |
| **Informational** | Observation for future improvement, out-of-scope concern | No — mention once, do not repeat in re-runs |

A `needs review` verdict is only issued for blocking-class findings.
Advisory and informational findings are noted in the verdict body but do not change `ship it` to `needs review`.

---

## Round counter management

The Reviewer tracks rounds via the review sub-issue comment thread.
Round N = the Nth autoreview run on that issue.
If rounds are unclear (due to comment thread noise), count by the number of `needs review` verdicts posted and add 1.
