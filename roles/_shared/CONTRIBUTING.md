# Contributing — Commit Format, Secrets Rule, Review Gate

This doc applies to all agents and developers committing to any Paperclip company repo or the standards repo.

---

## Commit format

```
[agent-role]: short description (PREFIX-NN)
```

- `agent-role` must be one of: `ceo`, `worker`, `researcher`, `knowledge-keeper`, `reviewer`, `cc`, `human`.
- `PREFIX-NN` is the Paperclip issue ID that this commit resolves (e.g. `KNO-14`).
- One commit per issue. Do not bundle multiple issue IDs in a single commit.
- Body line (optional): add context, not repetition. If the commit title is self-explanatory, omit the body.

Examples:

```
worker: implement level-complete screen animation (BFS-42)

Adds Tween-based scale pulse on the star icons. No other files changed.
```

```
knowledge-keeper: capture decision on reviewer slot model assignment (KNO-12)
```

```
reviewer: confirm BFS-44 passes DoD — ship it (BFS-44)
```

---

## Branch policy

- **`working`** — agents and humans push freely here. It may be broken at any point.
- **`test`** — only push to `test` after CC + company CEO have reviewed the working branch. No direct commits to `test` without passing `working` review.
- **`main`** — Atakan approves all merges. Never push directly to `main`. CC never pushes to `main` without explicit Atakan approval.

---

## Secrets rule

Never commit secrets of any kind:

- No API keys, subscription tokens, or OAuth credentials.
- No `.env` files.
- No `~/.secrets/*` paths embedded in code or docs.
- No model endpoint URLs that embed API keys as query parameters.

If a file must reference a secret, use an environment variable name (e.g. `$OPENAI_EMBEDDING_KEY`) and document where the secret is stored, not its value.

If you discover a committed secret, open a standards issue immediately. Do not attempt to rewrite history yourself; surface it to CC.

---

## No push without Reviewer verdict

Before any agent marks an issue Done and reports to CEO:

1. Reviewer must have issued a verdict of `ship it`.
2. The verdict must be attached to the Paperclip issue as a comment or linked sub-issue.
3. CEO reads the verdict before closing the issue and reporting to CC.

Bypassing the Reviewer step is a workflow violation. The CEO must reject any Done report that lacks a Reviewer verdict.

---

## Karpathy discipline (mandatory)

All code changes must comply with the studio-wide Karpathy coding discipline:

- Think Before Coding — state assumptions; surface tradeoffs; ask if unclear.
- Simplicity First — minimum code that solves the problem; no speculative abstractions.
- Surgical Changes — touch only what you must; do not improve adjacent code.
- Goal-Driven Execution — define verifiable success criteria before touching code.

See `~/CLAUDE.md` for the full Karpathy section.
