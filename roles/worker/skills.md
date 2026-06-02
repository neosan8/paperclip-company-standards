# Worker Skills

---

## Canonical Codex workflow doctrine

Per Atakan 2026-06-02:

### Step 1 — Plan
Before starting work, run `/plan` to document the work. Codex produces a written plan.

### Step 2 — Goal
Start implementation per the plan doc with `/goal`. Tell codex to begin the work described in the plan documentation.

### Step 3 — Milestone review (mandatory at every milestone)
Whenever you reach a milestone, run `$codex-review`, address findings, then continue with the implementation.

### Step 4 — Final review (mandatory when done)
When you're done, run another set of reviews with subagents by using `$review` skill.

### Step 5 — Optional: babysit PR
You may optionally run `/goal babysit PR` to check copilot / review bot comments, iterate on them, and before pushing run `$codex-review` again. When all discussions are resolved, merge the PR.

### Rules
- Never skip the milestone `$codex-review` (rounds capped at 3).
- Never self-review own changes — `$review` runs as a separate subagent invocation.
- Never push without milestone + final reviews passing.
- Never use OpenAI API directly — OAuth ChatGPT subscription only (embedding endpoints excepted).

---

## /plan

**Purpose:** Prepare a written plan before touching any code or file.

**Required output (post as Paperclip issue comment):**
- Acceptance criteria restated in your own words.
- File list: which files will be created or modified.
- Assumptions stated explicitly.
- Step-by-step execution order.
- Verifiable success criterion per step.

**Rule:** No code before plan. If the CEO assigned the issue without clear acceptance criteria, stop and ask the CEO to clarify before planning.

---

## /goal

**Purpose:** Execute against the plan. At each milestone, run `$codex-review`.

**Pattern:**
1. Take the first step from the plan.
2. Implement it.
3. Run `$codex-review`. Read output. Fix blocking findings; triage advisories.
4. Commit: `worker: <step description> (PREFIX-NN)`.
5. Repeat for each plan step.
6. On final step: run `$review` (final gate).

---

## $codex-review

**Purpose:** Advisory mid-execution self-check. Not a ship gate — an error-catcher.

**When to run:** After each milestone commit (not after every single file edit).

**What to do with output:**
- `error` or `bug` class findings: fix before proceeding to next milestone.
- `style` or `naming` advisories: note; fix if trivial; defer if not.
- Do not ignore output silently.

---

## $review

**Purpose:** Final self-check before reporting done. More thorough than `$codex-review`.

**When to run:** Once, after all acceptance criteria are implemented and final commit is made.

**Output treatment:**
- Any blocking finding: fix immediately.
- Advisory findings: include in the done comment with rationale.
- If $review output is clean: say so in the done comment.

---

## codex-review (install/skill)

The Codex `uinaf/codex-review` skill provides the `$codex-review` and `$review` wrappers.
Install on every Worker agent: see `../../standards/worker-skills-catalog.md`.

---

## gstack-qa

**Purpose:** Real-browser verification. Run gstack QA checks when the deliverable includes a UI change, WebGL output, or HTML template modification.

When to use:
- After implementing any Three.js / WebGL change.
- After modifying any game screen template.
- On any change that a human would normally "eye-check" in a browser.

---

## Three.js / WebGL (next-gen HTML templates)

Worker is the primary builder for Stage 0 HTML template shells (Three.js, not Canvas 2D).

Key rules:
- Use Three.js/WebGL for all new game template shells.
- Canvas 2D is legacy; do not introduce new Canvas 2D code unless an issue explicitly requires it.
- Closer to Unity feel = closer to target. Three.js solves Chrome perf problems that Canvas 2D cannot.

Reference: `memory/feedback_threejs_html_template.md` in the shared vault.
