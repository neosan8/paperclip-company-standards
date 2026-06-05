# Worker Heartbeat

> **API provisioning note:** When creating this agent via the Paperclip API, set `role: 'engineer'` — that is the API enum that maps to our Worker spec name. The display name in capabilities should still read "Worker."

Worker heartbeat is simpler than CEO heartbeat. The Worker picks up `todo` issues, executes, self-checks, reports.

---

## Step 1 — Check PAPERCLIP_APPROVAL_ID

Same as CEO: if `PAPERCLIP_APPROVAL_ID` is set, handle the approval before anything else.
See `../../standards/approval-wake-protocol.md`.

## Step 2 — Pull latest from `main`

```bash
git fetch origin
git checkout -b <type>/<topic> origin/main
```

Branch off the latest `main` before starting work. Use branch type `fix/`, `feature/`, `spec/`, or `docs/` as appropriate (see `docs/flows/branch-workflow.md`). Never push directly to `main`.

## Step 3 — Pick up next issue

Fetch the next issue in `todo` status assigned to the Worker role:
```
paperclip_list_issues --status=todo --role=worker
```

If no issues are in `todo`, report queue-empty to CEO and stop. Do not idle-loop.

## Step 4 — Checkout the issue

```
POST /api/issues/{id}/checkout
```

- 409 = owned by another agent. Move to next issue.
- Update issue status to `in-progress`.

## Step 5 — Plan before code

Run `/plan`. Write the plan as a comment on the Paperclip issue before touching any file.

The plan must include:
- Restatement of acceptance criteria in your own words (confirms understanding).
- List of files to be created or modified.
- Any assumptions made.
- Verifiable success criteria (what you will check to confirm each step is done).

Do not proceed to Step 6 until the plan is posted.

## Step 6 — Execute

Run `/goal` against the plan. At each milestone (each acceptance criterion completed):

- Run `$codex-review` — advisory self-check. Read the output. Address any findings that block correctness; triage the rest.
- Commit with the correct format: `worker: <description> (PREFIX-NN)`.

## Step 7 — Final review

On completion of all acceptance criteria: run `$review`.

Read the output. For each finding:
- **Blocking** — fix before proceeding.
- **Advisory** — note in the done comment (accepted or deferred, with rationale).

## Step 8 — DoD self-check (mandatory)

Run through all five steps of the DoD self-check in `../_shared/DEFINITION-OF-DONE.md`.

This is not optional. This is Step 5 of the Worker's own responsibility.

Checklist:
- [ ] Deliverable exists and is committed.
- [ ] Deliverable is accessible (no broken paths or imports).
- [ ] Deliverable matches all acceptance criteria in the issue.
- [ ] No placeholders (`TODO`, `FIXME`, `...`) in delivered work.
- [ ] No duplicates of existing files or functions.

If any item fails: fix it before reporting. Do not report done until all five pass.

## Step 9 — Report done to CEO

Post a comment on the Paperclip issue:

```
Done. DoD self-check passed.
Deliverable: <file path or URL>
Commit: <sha>
Branch: <branch-name>
$review findings: <"none" or list accepted/deferred findings with rationale>
```

Update issue status to `review`.

Do not close the issue. The CEO will trigger Reviewer and close after verdict.

## Step 10 — Await Reviewer verdict

Do not pick up a new issue until the Reviewer verdict arrives — unless the CEO explicitly assigns a new issue to use the waiting time. If the Reviewer returns `needs review`, pick up the fix sub-issue from the CEO.

---

## Common failure modes

| Failure | Root cause | Fix |
|---------|-----------|-----|
| Reported done without DoD check | Skipped Step 8 | Re-run DoD; fix failures; re-report |
| No plan posted before coding | Skipped Step 5 | Always post plan first; CEO rejects plan-less Done reports |
| Checkout 409 | Two worker instances, or CEO already checked out | Log and skip; pick next issue |
| `$codex-review` output ignored | Forgot to read output | Re-run; triage every finding |
