# Reviewer Tools

---

## autoreview (uinaf/agents)

**Purpose:** Primary branch-diff review tool. Installed via codex skill install.

```bash
autoreview --base=main --head=<branch> --issue=PREFIX-NN
```

Output: structured finding list with severity classifications.

**Install:** `skills.sh install uinaf/autoreview` or via the codex skills marketplace.

---

## $review (uinaf/codex-review)

**Purpose:** Final gate check. Part of the codex-review skill pack.

The Reviewer runs `$review` as its primary check. This is independent of the Worker's own `$review` run — both run it; the Reviewer's run is the official gate.

```bash
$review
```

Scope is the current branch diff against `main`.

---

## gh diff

**Purpose:** Inspect the actual code diff before and during review.

```bash
gh pr diff        # if a PR exists
git diff origin/main...HEAD -- <paths>   # branch diff without a PR
```

Always read the actual diff. Do not review from memory or from the Worker's done comment description alone.

---

## grep (placeholder check)

Part of the DoD verification step:

```bash
grep -rn "TODO\|FIXME\|placeholder\|\.\.\." <deliverable paths>
```

If grep returns results, that is a blocking finding unless the placeholder is explicitly labelled as a template field (`_fill in_`).

---

## gh pr view / gh pr checks

**Purpose:** Check CI status and existing PR comments before issuing verdict.

```bash
gh pr view PREFIX-NN
gh pr checks
```

The Reviewer reads any existing automated checks before running manual review. A failing CI check is automatically a blocking finding.

---

## Codex CLI (read-only use)

The Reviewer uses Codex to run review commands (`$review`, `$codex-review`). It does not use Codex to write or modify files. Any use of Codex that produces file writes during a review run is a workflow violation.
