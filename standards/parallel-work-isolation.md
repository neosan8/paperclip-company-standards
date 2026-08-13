# Parallel Work Isolation

How a CEO runs several workers at once without them destroying each other's work.

**Adapted from [`aronprins/codex-loop`](https://github.com/aronprins/codex-loop)** (MIT, read 2026-08-13). We did not install it as a skill — it duplicates the orchestration a Paperclip CEO already does. What it solved that we had not is recorded here so it survives independently of that repo.

## Why this exists

Before this document, `worktree` appeared in **zero** files across this repo. Parallel worker execution was already happening — five Codex artists writing the same Figma frame during Stage 1 GUI kit production — with no isolation model at all. Collisions were handled by noticing them.

## The rule: one worktree per worker

Workers running concurrently each get their own `git worktree`, branched from the current integration branch. A worker edits source files **only inside its own worktree**, commits to **its own branch**, and returns a structured result. Nothing else.

```
integration branch
├── worktree/story-A   worker 1  → branch story-A
├── worktree/story-B   worker 2  → branch story-B
└── worktree/story-C   worker 3  → branch story-C
                                   ↓
                          merge barrier, then verify
```

Merge and verify the integrated branch **before** starting the next wave. A wave that is not verified before the next one starts turns one broken story into an unattributable failure across three.

## The rule that actually prevents corruption: shared state has one owner

**Parallel workers must never write shared runtime files.** The issue board, the progress log, any per-run state file — these belong to the **CEO**, who updates them once per wave, after the merge barrier.

This is the rule that does the work. Worktrees stop workers colliding in *source*; single ownership stops them colliding in *state*. Two workers appending to the same progress file produce a file that is corrupt in a way neither of them can detect, because each one's own write succeeded.

When verifying a wave, confirm the worker did not modify shared state. A worker that edited the board is a rule break, not a merge conflict.

## Dependency waves

Where work has real ordering, declare it. Each unit may carry a `dependsOn` list of unit ids that must be complete before it can start.

**Computing waves:**

1. **Ready set** — pending units whose `dependsOn` entries are all already complete.
2. **Wave** — the ready set, sorted by priority, capped at the concurrency limit (**default 4**).
3. Mark the wave planned; recompute until nothing is pending.

**Stop before spawning anything if:**

- a unit depends on an unknown id,
- a cycle or unsatisfiable dependency prevents progress,
- the wave plan is empty while units are still pending.

**Print the full wave plan before spawning any worker.** A plan that is only inspectable after the fact is not a plan.

### When nothing declares dependencies

Falling back to "group by equal priority" assumes same-priority units are independent, which is usually untested. Say so out loud and offer sequential execution as the safer option. If the user chooses to continue, run priority groups as waves.

**Sequential is the default.** Parallel is opt-in, and only when the user asks for it. Most work does not need it, and the failure modes are more expensive than the time saved.

## Cost

A worktree costs disk and setup time per worker. Use parallel mode when units are genuinely independent and the work is long enough to pay for the isolation — not to make a three-unit job look busy.

## Cross-references

- `standards/reviewer-pattern.md` — the verification gate each unit still passes through
- `roles/ceo/heartbeat.md` — where the CEO plans and spawns
- `roles/worker/durable-learning.md` — what a worker records so the next fresh context is not naive
- `docs/flows/agent-stall-recovery.md` — what to do when a worker in a wave stops responding
