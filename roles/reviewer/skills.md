# Reviewer Skills

> **API provisioning note:** Provision with `role: 'qa'` via Paperclip API. Note: `self_review_prohibited` is enforced via the capability brief text, NOT a platform-enforced field.

---

## autoreview

**Purpose:** Branch diff review that produces an advisory report on a pull request or branch comparison.

**Source:** `uinaf/agents` autoreview skill. Install via `skills.sh` or codex skill install.

**What it does:**
- Reads the branch diff (against `main` or the specified base).
- Identifies: potential bugs, logic errors, missing error handling, security issues, style deviations.
- Produces an advisory output — never auto-merges or auto-closes.
- Output is a structured report with findings classified by severity.

**How to invoke:**
```bash
autoreview --base=main --head=<branch> --issue=PREFIX-NN
```

**Self-review prohibition:** autoreview must not be invoked by the agent that authored the changes under review. If the Reviewer is the same session that produced the deliverable, escalate to CEO for an alternate review path.

**Retry-until-clean protocol:**
- Run autoreview. Read all findings.
- For each blocking-class finding: create a `needs review` verdict; the CEO opens a fix sub-issue; Worker fixes it; Reviewer re-runs autoreview.
- Maximum retry rounds: 3. After round 3 with no `ship it`, escalate to CC.

---

## review-gang

**Purpose:** Parallel multi-persona review. Different reviewer personas each check one specific dimension.

**Available personas:**

| Persona | Checks |
|---------|--------|
| `correctness` | Does the code/doc do what the issue spec says? |
| `security` | Any secrets, injection risks, auth bypasses? |
| `karpathy` | Does it comply with simplicity-first, surgical-changes, no-over-engineering? |
| `accessibility` | For UI changes: keyboard nav, color contrast, screen reader compatibility |
| `performance` | For Three.js/WebGL: frame budget, texture memory, draw call count |

**When to use:**
- Always run `correctness` persona (mandatory, every review).
- Run `karpathy` persona on all code deliverables.
- Run `security` persona on any change that touches auth, secrets, network, or file system.
- Run `performance` persona on any Three.js or WebGL change.
- Run `accessibility` persona on any UI change visible to players.

**Pattern:**
```
review-gang --issue=PREFIX-NN --branch=<branch> --personas=correctness,karpathy
```

Each persona returns its own finding list. The Reviewer synthesizes all personas into a single verdict.

---

## dod-check

**Purpose:** Verify the Worker's DoD self-check was actually applied, not just declared.

The Reviewer checks:
1. Does the deliverable actually exist at the path claimed in the done comment?
2. Does it actually match the acceptance criteria (read them, check the output)?
3. Are there actually no placeholders? (grep for `TODO`, `FIXME`, `...` in delivered files)
4. Is there actually no duplicate of an existing file/function?

A Worker can post "DoD passed" without having actually run it. The Reviewer verifies, not trusts.

---

## codex-review (install)

Install `uinaf/codex-review` on the Reviewer agent. This provides:
- `$codex-review` — the same advisory tool Workers use; Reviewer runs it on the final diff.
- `$review` — final gate check; Reviewer runs this as its primary autoreview invocation.

The Reviewer's use of `$review` is independent of the Worker's own `$review` run. Both run it; the Reviewer's is the official gate.
