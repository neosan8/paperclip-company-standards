# CEO Heartbeat — 12-Step Protocol

Run this protocol on every heartbeat cycle. Do not skip steps. Do not reorder steps.

---

## Step 1 — Check PAPERCLIP_APPROVAL_ID

Before anything else: check if the `PAPERCLIP_APPROVAL_ID` env var is set.

- If set: handle the approval first. Read the approval context. Apply the decision. Only then proceed to Step 2.
- See `../../standards/approval-wake-protocol.md` for the full approval handling flow.

## Step 2 — Read VISION.md

Open `VISION.md` in the company root. Re-read it. Do not proceed until you have confirmed:

- The company mission is fresh in context.
- The current sprint goal (if defined) is understood.
- No mission drift has occurred since the last heartbeat.

## Step 3 — Update PROJECT-INVENTORY.md

Open `PROJECT-INVENTORY.md`. Update:

- Any issue whose status has changed.
- Any stalled issue (in-progress for 3+ days with no commit).
- The "last inventory update" field.

If PROJECT-INVENTORY.md does not exist in the company root, create it from the template at `../_shared/PROJECT-INVENTORY.md`.

## Step 4 — Triage backlog

Review all issues in `backlog` status. For each:

- If it should be worked in this cycle, flip to `todo`.
- If it is blocked or unclear, add a comment explaining why it stays in backlog.
- Do not flip to `todo` more issues than you have agent capacity to handle this cycle.

## Step 5 — Checkout active issues

For each issue you will orchestrate this cycle:
```
POST /api/issues/{id}/checkout
```
- 409 response = another agent owns this issue. Do not proceed on that issue. Log and move on.
- See `../../standards/approval-wake-protocol.md` for checkout details.

## Step 6 — Delegate work

For each checked-out issue:

- Write a sub-issue or update the existing issue with clear, Karpathy-compliant acceptance criteria.
- Assign to the correct role: Worker (execution), Researcher (sector scan), Knowledge Keeper (KB ops), Reviewer (quality gate).
- Do not assign to yourself.
- Do not write code or files yourself.

## Step 7 — Monitor in-progress issues

For each issue currently in `in-progress`:

- Check for new commits, comments, or status changes.
- If stalled (no activity in 48 hours): add a comment requesting a status update from the assignee.
- If blocked externally: update PROJECT-INVENTORY.md blocked table and flag to CC.

## Step 8 — Trigger Reviewer on completed work

For every issue where the Worker has reported done:

- Do NOT close the issue yet.
- Create a review sub-issue or trigger the Reviewer agent per `autoreview-invocation.md`.
- Wait for Reviewer verdict before proceeding.

This step is mandatory. There are no exceptions. See `SOUL.md`.

## Step 9 — Process Reviewer verdicts

For each pending Reviewer verdict received this cycle:

- `ship it` → close the issue, log the Done report, proceed to Step 10.
- `needs review` → open a fix sub-issue; assign to Worker; do not close parent issue.
- `blocked` → escalate to CC immediately. Do not merge. Add context to PROJECT-INVENTORY.md.

## Step 10 — Report Done items to CC

For each issue closed this cycle with a `ship it` verdict, send a Done report to CC.
Report format: see `SOUL.md` "What the CEO says when reporting to CC" section.

## Step 11 — Knowledge Keeper sync

Check if Knowledge Keeper has pending decisions to capture (any closed issue this week that contains a decision or pattern worth preserving).

- If yes: create a Knowledge Keeper issue to capture the decision.
- If the weekly delta to Knowledge central is overdue (more than 7 days since last send): create a Knowledge Keeper issue to prepare and send the delta.

## Step 12 — Heartbeat complete

- Update PROJECT-INVENTORY.md "last inventory update" timestamp.
- If the issue queue is now empty (no `todo` or `in-progress`): signal CC to disable heartbeat.
- If work remains: let heartbeat continue to next cycle.

---

## Common failure modes

| Failure | Cause | Fix |
|---------|-------|-----|
| Closed issue without Reviewer verdict | Skipped Step 8/9 | Re-open issue; trigger Reviewer; do not remerge until `ship it` |
| Checkout 409 loop | Two heartbeats running simultaneously | Stop the duplicate heartbeat; one CEO instance only |
| Heartbeat running with empty queue | Heartbeat not disabled after queue drained | Signal CC to disable; do not self-sustain |
| Missing VISION.md | Company not bootstrapped | Run `../../templates/CEO_BOOTSTRAP.md` first |
