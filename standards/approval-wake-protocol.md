# Approval Wake Protocol — PAPERCLIP_APPROVAL_ID Handling

Every Paperclip agent must handle `PAPERCLIP_APPROVAL_ID` as its first action on wake.
No other work may proceed until the approval is handled.

---

## Why this exists

Paperclip injects `PAPERCLIP_APPROVAL_ID` when an issue or action is waiting for approval from the agent. If the agent skips this and starts other work, the approval-blocked item may time out, duplicate, or corrupt the issue state.

---

## Protocol (every agent, every wake)

### Step 1 — Check for PAPERCLIP_APPROVAL_ID

```bash
echo $PAPERCLIP_APPROVAL_ID
```

- If empty or unset: skip to normal heartbeat or task start.
- If set: do not proceed to any other work until Step 4 is complete.

### Step 2 — Read the approval context

Fetch the approval context from the Paperclip API:
```
GET /api/approvals/{PAPERCLIP_APPROVAL_ID}
```

Read the approval payload: what action is waiting, what issue it belongs to, what the approval options are.

### Step 3 — Apply the decision

Based on the approval context:

- If the approval is for an action the agent can decide autonomously (within its role scope): apply the decision and post a comment on the issue.
- If the approval is for an action outside the agent's authority: do not approve autonomously. Post a comment on the issue explaining that escalation is needed. Signal CEO (if Worker/Researcher/Keeper) or CC (if CEO).

**Role-scope guidance:**

| Role | Can approve autonomously | Must escalate |
|------|------------------------|---------------|
| CEO | Issue status changes, sub-issue creation, role-scope tool use | Merges to main, new agent creation, publishing, config changes |
| Worker | File writes on the issue's `spec/<topic>` (or `feature`/`fix`/`docs`) branch, codex skill installs | Anything outside the issue branch; merges target main only |
| Reviewer | Verdict issuance on assigned review issues | Changes to deliverables |
| Researcher | Acknowledging research assignments | Any execution action |
| Knowledge Keeper | KB writes, gbrain sync | Anything outside KB vault |

### Step 4 — Acknowledge the approval

After applying the decision, acknowledge via the Paperclip API:
```
POST /api/approvals/{PAPERCLIP_APPROVAL_ID}/acknowledge
```

Do not leave an approval unacknowledged. Unacknowledged approvals block downstream pipeline.

---

## Checkout-before-work protocol

Before starting any issue (not just approval-triggered ones), every agent must checkout the issue to claim exclusive ownership:

```
POST /api/issues/{id}/checkout
```

Response codes:
- **200** — checkout successful; proceed with work.
- **409** — issue belongs to another agent. Do not proceed on this issue. Log the conflict and pick the next issue. Never force a 409 situation by retrying.

If checkout consistently returns 409 on issues that should be unowned, escalate to CC — this indicates a zombie agent lock that needs manual resolution.

---

## Common failure modes

| Failure | Symptom | Fix |
|---------|---------|-----|
| Skipped PAPERCLIP_APPROVAL_ID check | Approval times out; downstream issue blocked | Re-read this protocol; implement check as Step 1 |
| Autonomously approved out-of-scope action | Config change or merge without authorization | Escalate to CC; document the incident; add to company anti-patterns in VISION.md |
| 409 on checkout, no retry | Agent silently drops the issue | Log the 409; report to CEO; CEO investigates lock |
| 409 retry loop | Two agents fighting over same issue | Stop both agents; CEO resolves; restart one |
