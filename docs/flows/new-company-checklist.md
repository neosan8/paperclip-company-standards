# New Company Checklist

Atomic checklist CC runs every time a new Paperclip company is created. Complete every step in order. Do not mark any step done unless it is verified.

---

## Pre-creation

- [ ] Confirm the company name, prefix, and role against `config/central-companies.json` (if central) or the game title (if game company).
- [ ] Confirm the company does not already exist: run `paperclip_list_companies` and scan the output.
- [ ] Confirm the company tier: central or game company.

---

## Create the company

- [ ] Create the Paperclip company via `paperclip_create_company`.
- [ ] Record the company UUID from the response. (Update `config/central-companies.json` if this is a central company, resolving KI-PS-3 for that entry.)

---

## Create all 4 standard agents

Reference `config/models.json` for all model and adapter values.

- [ ] Create **CEO** agent:
  - Model: `claude-opus-4-8`
  - Adapter: `claude_local`
  - Auth: Claude.ai subscription OAuth
  - AGENTS.md: include gbrain/graphify syntax, vault path, this standards repo URL, orchestrator-only rule.

- [ ] Create **Worker** agent:
  - Model: `gpt-5.5`
  - Adapter: `codex_local`
  - Auth: ChatGPT subscription OAuth
  - `dangerouslyBypassApprovalsAndSandbox: true`
  - AGENTS.md: include Codex workflow (`/plan -> /goal -> $codex-review -> $review`), brain-first rule.

- [ ] Create **Knowledge Keeper** agent:
  - Model: `claude-sonnet-latest`
  - Adapter: `claude_local`
  - Auth: Claude.ai subscription OAuth
  - Heartbeat: daily scheduled.
  - AGENTS.md: include vault conventions, weekly delta format.

- [ ] Create **Researcher** agent:
  - Model: `gpt-5.5`
  - Adapter: `codex_local`
  - Auth: ChatGPT subscription OAuth
  - Heartbeat: OFF.
  - AGENTS.md: include research workflow, output format, brain-first rule.

---

## Configure tool stack

Reference `config/required-tools.json` for tool list.

- [ ] Confirm Obsidian vault is accessible at `~/Docs/paperclipcompanies/_knowledge-base/`.
- [ ] Create company subfolder in vault: `_knowledge-base/<company-prefix>/`.
- [ ] Confirm gbrain is available. If macOS 26.3+, confirm bun wrapper is configured.
- [ ] Confirm gstack is available.
- [ ] Confirm graphify is available.
- [ ] Confirm TokenJuice is available.

---

## Validate tool stack (first CEO issue)

- [ ] Create an issue in the new company: "Validate tool stack: test gbrain query, graphify query, gstack autoplan, and confirm Obsidian vault access. Report pass/fail for each."
- [ ] Flip issue state from `backlog` to `todo`.
- [ ] Turn heartbeat ON.
- [ ] Wait for issue to close with `ship it` verdict.
- [ ] Turn heartbeat OFF.

---

## Validate CEO-Worker delegation chain (second CEO issue)

- [ ] Create an issue: "Self-test: create a sample sub-issue, assign to Worker, verify Worker picks it up, close the loop. Confirm CEO-Worker delegation chain is functioning."
- [ ] Flip to `todo`, turn heartbeat ON.
- [ ] Wait for close with `ship it`.
- [ ] Turn heartbeat OFF.

---

## Register with Knowledge company

- [ ] Notify the Knowledge company CEO: new company `<name>` (prefix `<PREFIX>`) is active. Provide company UUID.
- [ ] Confirm Knowledge Keeper's first weekly delta target is set (next Monday or next scheduled window).

---

## Final verification

- [ ] All 4 agents created and configured.
- [ ] Tool stack validated (pass on all 4 tools).
- [ ] Delegation chain validated.
- [ ] Knowledge company notified.
- [ ] Company UUID recorded in `config/central-companies.json` (if central).

Company is ready for production work.
