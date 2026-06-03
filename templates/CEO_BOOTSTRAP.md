# CEO Bootstrap Checklist — One-Time Per-Company First-Boot

Run this checklist exactly once when a new Paperclip company is created, before the first heartbeat.
Check each item off in order. Do not skip. Do not defer to a later heartbeat.
When all items are checked, the company is bootstrapped and the first heartbeat may begin.

---

## Pre-flight (before the CEO agent is activated)

These are performed by CC when creating the company:

- [ ] Company created in Paperclip with the correct prefix (see `../../config/central-companies.json` or game company naming convention).
- [ ] CEO agent slot configured with model `claude-opus-4-8`, adapter `claude_local`, auth `claude_ai_subscription_oauth`.
- [ ] Worker agent slot configured with model `gpt-5.5`, adapter `codex_local`, auth `chatgpt_subscription_oauth`, `dangerouslyBypassApprovalsAndSandbox: true`.
- [ ] Researcher agent slot configured with model `gpt-5.5`, adapter `codex_local`, auth `chatgpt_subscription_oauth`.
- [ ] Knowledge Keeper agent slot configured with model `claude-sonnet-latest`, adapter `claude_local`, auth `claude_ai_subscription_oauth`.
- [ ] Reviewer agent slot configured with model `gpt-5.5`, adapter `codex_local`, auth `chatgpt_subscription_oauth`, purpose note: `review-only; never self-review`.
- [ ] All five agent slots verified in Paperclip company config.

---

## First-boot (CEO performs, in order)

> Bootstrap exception: Steps 2 and 3 below require the CEO to create and commit files directly. This is the only situation where direct file writes are permitted for the CEO. After bootstrap is complete, all file operations must be delegated to Workers. See `../../roles/ceo/skills.md` delegation-guard section.

### Step 1 — Handle PAPERCLIP_APPROVAL_ID

Check if `PAPERCLIP_APPROVAL_ID` is set. If yes, process it first. Then continue.

### Step 2 — Create VISION.md

Copy `VISION.md` from the standards repo `templates/` directory to the company root.
Path reference: `$STANDARDS_REPO/templates/VISION.md` where `$STANDARDS_REPO` is the local checkout path (typically `~/code/paperclip-company-standards`). Relative paths like `../../templates/VISION.md` depend on the working directory and may not resolve; use the absolute path.
Fill in all `[REQUIRED]` fields:
- Company name, prefix, type, date established.
- Mission (one sentence).
- Target customer.
- Sprint goal (for bootstrap: "Complete company setup and first issue delegation").
- Org structure table with all five agent handles.
- CEO mandate.
- Guiding principles (minimum 3).
- Anti-patterns (minimum 3).

Commit: `ceo: create VISION.md for <company-name> bootstrap (PREFIX-1)`

### Step 3 — Create PROJECT-INVENTORY.md

Copy `PROJECT-INVENTORY.md` from `$STANDARDS_REPO/roles/_shared/PROJECT-INVENTORY.md` to the company root.
Fill in company name, prefix, VISION.md location.
Sprint goal: same as VISION.md.
Issue table: empty (no issues yet).

Commit: `ceo: create PROJECT-INVENTORY.md for <company-name> bootstrap (PREFIX-1)`

### Step 4 — Verify mandatory tool stack

Confirm each tool is installed and accessible for the company:

- [ ] LLM Wiki / Obsidian: vault at `~/Docs/paperclipcompanies/_knowledge-base/` accessible.
- [ ] gbrain: `gbrain query "test"` returns (no error).
- [ ] gstack: `gstack --version` returns (no error).
- [ ] graphify: `graphify status` returns (no error).
- [ ] Karpathy discipline: in company AGENTS.md (copy the Karpathy section from `$STANDARDS_REPO/roles/_shared/CONTRIBUTING.md`).

If any tool is missing: create a setup issue; do not proceed to Step 5 until all tools verified.

### Step 5 — Create company KB folder

Create the company KB folder in the shared vault:
```
~/Docs/paperclipcompanies/_knowledge-base/<company-slug>/
  README.md          (from wiki-pattern.md README template)
  decisions/
  research/
  patterns/
  weekly-deltas/
  _archived/
```

Commit the README.md with company name, prefix, empty tag set, today's date as first gbrain sync.

### Step 6 — Run sync-bootstrap.sh

```bash
bash $STANDARDS_REPO/standards/sync-bootstrap.sh --role=ceo --company=<company-slug>
```

Confirm output: `~/Docs/paperclipcompanies/<company-slug>/AGENTS.md` written. Set `instructionsFilePath` in Paperclip agent config to this path.

### Step 7 — Create bootstrap issues for remaining agents

Create one Paperclip issue per remaining agent slot that needs activation:

- `[bootstrap] Activate Worker agent for <company-name>` — assign to Worker
- `[bootstrap] Activate Researcher agent for <company-name>` — assign to Researcher
- `[bootstrap] Activate Knowledge Keeper agent for <company-name>` — assign to Knowledge Keeper
- `[bootstrap] Activate Reviewer agent for <company-name>` — assign to Reviewer

Each bootstrap issue has acceptance criteria: agent is running, has read its role pack, has confirmed tool access.

Flip all four issues to `todo`.

### Step 8 — Signal CC

Post a message to CC:
```
<Company name> CEO bootstrap complete. VISION.md created. PROJECT-INVENTORY.md created.
Tool stack verified: [list any gaps].
Bootstrap issues created for Worker, Researcher, Knowledge Keeper, Reviewer.
Ready to enable heartbeat.
```

### Step 9 — First heartbeat

Enable heartbeat (CC enables; CEO does not self-start).
Run the first heartbeat following `../../roles/ceo/heartbeat.md`.

---

## Validation (CC runs after bootstrap)

- [ ] VISION.md exists in company root and all REQUIRED fields are filled.
- [ ] PROJECT-INVENTORY.md exists in company root.
- [ ] KB folder exists at correct vault path.
- [ ] All five agent slots are active in Paperclip.
- [ ] Four bootstrap issues are in `todo` status.
- [ ] `sync-bootstrap.sh` ran without errors.
