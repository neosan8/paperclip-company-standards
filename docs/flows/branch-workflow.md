# Branch Workflow Standard

Applies to: CC subagents, Codex App, all Paperclip Worker/Reviewer/Keeper agents contributing to any Giant Aicado repository.

---

## Rules

### 1. No `working` or `test` branches

`working` and `test` branches are deprecated. Do not create them. Do not push to them. If a PR exists against one of these branches, close it as superseded and follow the remediation procedure below.

### 2. Branch off the latest `main`

Every change starts from the current state of `main`:

```bash
git fetch origin
git checkout -b <type>/<topic> origin/main
```

Where `<type>` is one of:

| Type | When to use |
|------|-------------|
| `spec` | Standards, docs, config changes |
| `feature` | New capabilities |
| `fix` | Bug fixes or corrections |
| `docs` | Documentation-only changes |

Example: `spec/v0.2.3-process-lessons`, `fix/kk-model-access-error`.

### 3. PR target is always `main`

Set `--base main` when opening a PR. Never target `working`, `test`, or any other branch.

### 4. One PR = one logical change

One branch, one PR, one coherent set of related commits. Do not bundle unrelated changes. If you realize mid-branch that you need a second unrelated fix, create a separate branch for it.

### 5. Delete branch after merge

Once a PR is merged, delete the branch. Do not push further commits to a merged branch.

---

## Remediating a PR on a deprecated branch

If an open PR has `base: working` or `base: test`:

1. Close the PR with a note: "Superseded — rebased to main per branch workflow standard."
2. Identify the useful commits: `git log working...<branch>` or `git cherry-pick` specific SHAs.
3. Create a new branch off `origin/main`.
4. Cherry-pick only the useful commits onto the new branch.
5. Open a clean PR against `main`.

Do not reuse the old branch name.

---

## Why

Merging into `working` or `test` creates a secondary integration layer that is never the authoritative state of the codebase. It causes:

- Stale divergence: `working` lags behind `main` and conflicts accumulate.
- Unclear history: it is not obvious which commits are production-ready.
- Broken automation: any CI/deploy rule targeting `main` misses changes staged in shadow branches.

Branching directly off `main` and targeting `main` keeps the history linear and the source of truth unambiguous.
