# Autoreview Invocation — How and When the CEO Triggers the Reviewer

The CEO never runs autoreview itself. The CEO triggers the Reviewer agent, which runs autoreview.

---

## When to trigger the Reviewer

Trigger the Reviewer after every Worker completion, before closing any issue.

Specific triggers:
1. Worker posts a "done" comment on an issue.
2. Worker updates issue status to `review`.
3. CEO observes a new commit on `working` branch linked to an issue that was in `in-progress`.

Do not wait for the Worker to explicitly ask for review. The CEO proactively triggers the Reviewer on every completion.

---

## How to trigger the Reviewer

**Option A — Paperclip sub-issue (preferred)**

Create a review sub-issue linked to the parent:

```
Title: [review] PREFIX-NN — <parent issue title>
Assignee: Reviewer agent
Description:
  Parent issue: PREFIX-NN
  Branch: working
  Deliverable location: <path or URL from Worker's done comment>
  Review type: autoreview + DoD check
  Retry cap: 3 rounds
  Verdict required: ship it / needs review / blocked
```

Flip the sub-issue to `todo` immediately after creating it. The Reviewer's heartbeat will pick it up.

**Option B — Direct Reviewer agent message (when heartbeat is same-session)**

If the Reviewer is active in the same Paperclip session, the CEO can message the Reviewer directly with the same context as Option A. The Reviewer must still post a verdict comment on the original parent issue.

---

## What the CEO checks before triggering

Before triggering the Reviewer, the CEO confirms:

1. The Worker has actually pushed a commit (not just posted a comment saying "done").
2. The deliverable location is specified (file path, URL, or Paperclip comment link).
3. The issue has not already been sent to the Reviewer this cycle (no duplicate triggers).

If the Worker's done comment lacks a deliverable location, the CEO asks the Worker to provide it before triggering Reviewer.

---

## What the CEO does after receiving the Reviewer verdict

See `heartbeat.md` Step 9.

- `ship it` → close issue, report Done to CC.
- `needs review` → open fix sub-issue for Worker; hold parent open.
- `blocked` → escalate to CC; do not merge.

---

## Retry cap

The Reviewer has a maximum of 3 review rounds per issue. If after 3 rounds the issue has not reached `ship it`, it escalates to CC automatically. The CEO does not unilaterally decide to skip the cap.

---

## Self-review prohibition

The Reviewer must never review changes it contributed to. If the Reviewer agent was used to write any part of the deliverable (e.g. as a code-writer in an emergency), the CEO must recuse the Reviewer from that issue and escalate to CC for an independent review path.
