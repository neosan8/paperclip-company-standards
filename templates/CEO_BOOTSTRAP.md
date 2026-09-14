# CEO Bootstrap Checklist — One-Time Per-Company First-Boot

Run this checklist exactly once when a new Paperclip company is created, before the first heartbeat.
Check each item off in order. Do not skip. Do not defer to a later heartbeat.
When all items are checked, the company is bootstrapped and the first heartbeat may begin.

---

## Pre-flight (before the CEO agent is activated)

These are performed by CC when creating the company:

- [ ] Company created in Paperclip as a **game company** (one per title). Do not create a new central. Operator path: `docs/operator-stack.md`.
- [ ] CEO, Worker, Reviewer hired with the Cursor lock from `config/models.json` (model `auto` unless Neo pinned a concrete Cursor id; adapter `cursor` / `cursor-local` on Linux Grok Bot workers). API roles: `ceo` / `engineer` / `qa`.
- [ ] CEO capabilities / instructions forbid self-execution and state **idle of production / orchestrate only** (locked Neo / Atakan 2026-09-14). Heartbeat OFF is not that rule.
- [ ] Reviewer capabilities text includes `review-only; never self-review`.
- [ ] Heartbeat OFF on all three. Researcher and Knowledge Keeper **not** hired unless already decided.
- [ ] Three required slots verified. Do not require five.

---

## First-boot (CEO performs, in order)

> Bootstrap exception: Steps 2 and 3 below require the CEO to create and commit constitution files (`VISION.md`, `PROJECT-INVENTORY.md`) directly. This is the only situation where direct file writes are permitted for the CEO. It is not a license to produce game code, docs, or art. After Step 3, the locked Neo / Atakan 2026-09-14 rule applies: remain idle of production execution and only orchestrate. See `../../roles/ceo/SOUL.md` and `../../roles/ceo/skills.md` delegation-guard.

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
- Org structure table with the three required agent handles (CEO, Worker, Reviewer). Optional specialists only if they exist.
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
- [ ] Karpathy discipline: in company AGENTS.md (copy the Karpathy section from `$STANDARDS_REPO/roles/_shared/CONTRIBUTING.md`).
- [ ] Grok seats: do not block bootstrap on `gbrain` / `gstack` / `graphify`. Those are Claude-host tools (`docs/stack-standard.md`). If the vault path exists, record it; if not, continue.

If the vault path is required for this company and missing: create a setup issue. Do not hire five slots to fix a missing tool.

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
- `[bootstrap] Activate Reviewer agent for <company-name>` — assign to Reviewer

Do not create Researcher or Knowledge Keeper bootstrap issues on Grok spawn.

Each bootstrap issue has acceptance criteria: agent is running, has read its role pack.

Flip both issues to `todo`.

### Step 8 — Signal CC

Post a message to CC:
```
<Company name> CEO bootstrap complete. VISION.md created. PROJECT-INVENTORY.md created.
Tool stack verified: [list any gaps].
Bootstrap issues created for Worker and Reviewer.
Heartbeat stays OFF until those issues are in todo and a wake is needed.
```

### Step 9 — First heartbeat

Enable heartbeat (CC enables; CEO does not self-start).
Run the first heartbeat following `../../roles/ceo/heartbeat.md`.

---

## Validation (CC runs after bootstrap)

- [ ] VISION.md exists in company root and all REQUIRED fields are filled.
- [ ] PROJECT-INVENTORY.md exists in company root.
- [ ] KB folder exists at correct vault path.
- [ ] Three required agent slots are active in Paperclip (CEO, Worker, Reviewer).
- [ ] Two bootstrap issues are in `todo` status.
- [ ] `sync-bootstrap.sh` ran without errors.
