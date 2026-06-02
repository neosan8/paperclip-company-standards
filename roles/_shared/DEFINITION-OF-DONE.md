# Definition of Done

Every agent applies this checklist before declaring an issue complete and before the Reviewer issues a verdict.
If any item fails, the issue is not Done. Period.

The checklist has two parts: the self-check (all roles) and the Reviewer check (Reviewer role only).

---

## Part 1 — Self-check (every role, before reporting done to CEO)

Run through all five items in order. Do not skip.

### Step 1 — Deliverable exists

- [ ] The primary deliverable (file, commit, doc, report, comment) exists in the agreed location.
- [ ] If the deliverable is a file, it is committed and pushed to `working`.
- [ ] If the deliverable is a Paperclip comment or update, it is posted on the issue thread.

### Step 2 — Deliverable is accessible

- [ ] Another agent can reach the deliverable via the path or URL referenced in the issue.
- [ ] No broken relative paths, no missing imports, no 404 URLs.

### Step 3 — Deliverable matches spec

- [ ] The deliverable addresses all acceptance criteria listed in the issue.
- [ ] No scope was silently dropped. If scope was negotiated down, a comment on the issue explains the change.
- [ ] The deliverable does not introduce new scope beyond what was asked.

### Step 4 — No placeholders

- [ ] No `TODO`, `FIXME`, `// placeholder`, or `...` in delivered code or docs.
- [ ] No mocked data or stub implementations where real data or logic was required.
- [ ] If a placeholder was intentional (e.g. a template field), it is explicitly labelled as `_fill in_` and documented.

### Step 5 — No duplicates

- [ ] The deliverable does not duplicate an existing file, function, section, or issue.
- [ ] If an existing artifact was updated rather than replaced, the old version is removed or clearly superseded.

---

## Part 2 — Reviewer check (Reviewer agent only)

After self-check passes and worker reports done to CEO, CEO triggers Reviewer. Reviewer runs:

### Step 6 — Branch diff review (autoreview)

- [ ] `autoreview` run on the branch diff. Output reviewed. All advisory findings resolved or explicitly accepted with rationale.

### Step 7 — Reviewer persona sweep

- [ ] At minimum one additional persona check from the review-gang list in `../reviewer/review-pattern.md`.

### Step 8 — Verdict issued

- [ ] Reviewer issues a verdict on the Paperclip issue: `ship it`, `needs review`, or `blocked`.
- [ ] Verdict includes: finding count, severity, and action required (if not `ship it`).

---

## Verdict vocabulary

| Verdict | Meaning | CEO action |
|---------|---------|------------|
| `ship it` | Deliverable meets all DoD criteria. No blocking findings. | Close issue. Report done to CC. |
| `needs review` | Minor or advisory findings. Deliverable is directionally correct but needs targeted fixes before ship. | Open a fix sub-issue. Do not close parent until fix verified. |
| `blocked` | Blocking finding. Deliverable cannot ship in current state. | Escalate to CC. Do not merge. |

---

## Anti-patterns

- **Reporting done without Reviewer verdict** — violates workflow. CEO must reject.
- **Reviewer self-review** — a Reviewer must never review changes they contributed to. If the Reviewer touched a file, recuse and flag to CEO.
- **Ignoring autoreview advisory output** — advisory findings must be triaged, not silently ignored.
- **Marking done with broken links** — Step 2 exists precisely to catch this.
