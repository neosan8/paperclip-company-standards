# Worker Tools

---

## Codex CLI

**Purpose:** Primary execution environment. All code writing and CLI operations run through Codex.

**Auth:** ChatGPT subscription OAuth only. Never use OpenAI API keys directly.

**Key commands:**
- `/plan` — pre-execution planning.
- `/goal` — execution with milestone checkpoints.
- `$codex-review` — advisory mid-execution self-check.
- `$review` — final ship-gate self-check.

Install the `uinaf/codex-review` skill and the `uinaf/autoreview` skill (advisory only, Worker does not self-review final output — that is the Reviewer's role).

---

## git / GitHub CLI (`gh`)

**Purpose:** Commit and push deliverables on a short-lived branch, then open a PR to `main`.

Worker-permitted operations:
- `git add`, `git commit`, `git push origin <branch>`
- `gh pr create --base main` (open PR targeting main)
- `gh pr view` (read-only, for checking PR status)

Worker-forbidden operations:
- `git push origin main` (direct push)
- `git push --force` (any branch)
- `gh pr merge`

Commit format: `worker: <description> (PREFIX-NN)`. See `../_shared/CONTRIBUTING.md`.

---

## gbrain

**Purpose:** Semantic KB lookup before writing new code or docs.

Before creating any new file, Worker searches gbrain to confirm the file does not already exist.
Before implementing a pattern, Worker searches gbrain to see if the pattern is already documented.

Lookup priority: gbrain → gstack reference → external search. Never skip gbrain.

---

## graphify

**Purpose:** Add knowledge graph entries for new patterns or significant decisions made during execution.

Worker adds a graphify entry when:
- A new reusable pattern is introduced (e.g. new Three.js utility).
- A significant implementation decision was made (and the rationale should be preserved).

Worker does not restructure the graph or delete existing nodes.

---

## gstack

**Purpose:** QA and browser verification. Run after any UI or template change.

See `skills.md` for gstack-qa usage rules.

Installation reference: `../../docs/stack-standard.md`.

---

## TokenJuice

**Purpose:** Token-efficient bash output. Wrap long-running commands with `tokenjuice wrap`.

Always use TokenJuice for commands with verbose output (test suites, build logs, git diff on large changesets).

```bash
tokenjuice wrap -- npm test
tokenjuice wrap -- git diff HEAD~1
```
