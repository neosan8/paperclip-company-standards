# Worker — Durable Learning

What a worker writes down so the next worker, starting fresh, is not naive.

**Adapted from [`aronprins/codex-loop`](https://github.com/aronprins/codex-loop)** (MIT, read 2026-08-13).

## The problem this solves

Every worker starts with a clean context. That is deliberate — it is why fresh-context delegation works at all, and why a long single session degrades as earlier decisions blur together.

But it has a cost nobody was paying for: **a worker learns something on issue 40 and the worker on issue 41 does not know it.** The same wrong assumption gets made, corrected, and forgotten, repeatedly. Before this document, `learning` appeared in **zero** files across this repo. CC keeps a file-based memory; workers kept nothing.

Git history is not a substitute. A commit records *what changed*, never *what you had to find out first*.

## Where it goes

```
<company-workspace>/progress.txt
```

Append-only. Never rewritten, never tidied, never summarised into oblivion. In parallel waves it is **owned by the CEO** — see `standards/parallel-work-isolation.md`. Workers return their entry as part of their result and the CEO writes it after the merge barrier. A worker appending directly during a wave corrupts a file whose own write appeared to succeed.

## Shape

The top section is stable and re-read first:

```
## Codebase Patterns
- Config lives in config/*.json; the brief in docs/gdd/ explains it but is not authoritative
- Figma lanes must be edited v0.1 -> Test -> Prod, never out of order
- GA4 rejects nothing: a wrong parameter type arrives NULL with no error anywhere

## 2026-08-13 — KNO-165 daily frontier scan
- graphify-out/ was stale; regenerate before querying or results silently predate the change
- The Knowledge vault's git tree had an uncommitted restructure; check `git status` before editing
```

**`## Codebase Patterns` holds only what generalises.** Everything else is dated and scoped to its issue.

## What to record

Write the thing you would have wanted to know an hour ago:

- **A wrong assumption you had to correct.** The most valuable entry there is, and the least likely to be written, because by then it feels obvious.
- **Where the real authority lives** when two files disagree.
- **A tool that lied.** A command that reported success without doing the work, an empty result from something that could not read. State the symptom, not just the workaround.
- **A precondition that is not written down anywhere** but blocks the work.

## What not to record

- What the commit already says. If `git log` answers it, do not duplicate it here.
- Anything unverified, stated as fact. Mark a guess as a guess or leave it out — a wrong entry here is read by every later worker as established.
- Secrets, tokens, personal data. This file is committed.

## Read it before starting

At the start of an issue, read `progress.txt` — the `## Codebase Patterns` section at minimum. **A worker that does not read it is repeating someone else's afternoon.**

## Cross-references

- `standards/parallel-work-isolation.md` — ownership of shared state during parallel waves
- `roles/worker/heartbeat.md` — where reading and writing this fits in the run
- `roles/_shared/DEFINITION-OF-DONE.md` — an issue is not done until its entry is recorded
