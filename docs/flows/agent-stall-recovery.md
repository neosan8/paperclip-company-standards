# Agent Stall Recovery Flow

Use this flow when an agent stops making progress and is suspected to be stuck in an error state or holding a stale execution lock.

---

## Symptom

- Agent status is `error` (visible in `paperclip_list_agents` output).
- **Or** an in-progress issue has a stale `executionLockedAt` timestamp — no commit, comment, or status change for more than 30 minutes.

Either symptom alone warrants investigation. Both together confirm a stall.

---

## Diagnose

1. Check the agent's current status:
   ```
   paperclip_list_agents  →  find the agent, note status field
   ```

2. Check the locked issue:
   - Look at the issue's `executionLockedAt` field.
   - Compare against last activity (last comment or commit timestamp).
   - If `executionLockedAt` is set and last activity is > 30 min ago, the lock is stale.

3. Confirm no parallel heartbeat is running for the same agent (duplicate heartbeats create 409 checkout loops — see `roles/ceo/heartbeat.md` failure modes).

---

## Recovery

**Step 1 — Clear the agent error state.**

Reset the agent to `idle` via the Paperclip API:

```http
PATCH /api/agents/{agentId}
Content-Type: application/json

{"status": "idle"}
```

This clears the `error` state. The agent will not auto-resume; you must re-trigger it.

**Step 2 — Release the stale issue lock.**

Reset the stranded issue state to drop the stale lock:

- If the issue was `in_progress`: flip to `todo`.
- If the issue was `blocked`: flip to `todo`.

Do **not** flip directly to `done` or `backlog` — this discards work context.

**Step 3 — Scope residual work in a comment.**

Before re-assigning, add a comment to the issue that describes exactly where the agent left off:

- What was completed before the stall.
- What remains (specific sub-tasks, files, or steps).
- Any partial output that can be reused.

This prevents the agent from starting from scratch and duplicating already-completed work.

**Step 4 — Re-fire the heartbeat.**

Once the agent status is `idle` and the issue is in `todo`:

1. Enable the agent's heartbeat (`PATCH /api/agents/{agentId}` with `{"heartbeatEnabled": true}`).
2. Confirm the issue appears in the agent's inbox (state is `todo`, not `backlog`).

The agent will pick it up on the next heartbeat cycle.

---

## Anti-patterns

- **Retrying `invoke` while the agent is in `error` state.** The invoke will fail or be silently ignored. Clear `error` → `idle` first.
- **Flipping the issue to `done` to "unstick" it.** This closes the issue without a Reviewer verdict, which violates the quality gate rule.
- **Skipping the residual-work comment.** The agent will re-read the issue from scratch and may repeat completed steps.
- **Re-enabling heartbeat before the issue lock is cleared.** The agent will hit a 409 checkout and stall again immediately.

---

## Scope

This flow applies to: Worker, Researcher, Knowledge Keeper, Reviewer. CEO stalls follow the same mechanics but are escalated to CC rather than self-recovered.
