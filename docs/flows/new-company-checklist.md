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

## Verify host reasoning effort (do this first)

Reasoning effort is **high** for every role, and it is set host-wide — not per agent. A company provisioned on a host with default effort will silently run below standard, so verify both files before creating agents:

- [ ] `~/.claude/settings.json` contains `"effortLevel": "high"` — covers CEO and Knowledge Keeper (`claude_local` agents inherit it)
- [ ] `~/.codex/config.toml` contains `model_reasoning_effort = "high"` — covers Worker and Researcher (`codex_local`)

`adapterConfig` has no effort key on either adapter; there is no per-agent override. See `docs/governance/model-topology.md`.

---

## Create all 5 standard agents

Reference `config/models.json` and `config/roles.json` for all model, adapter, and role values. As of v0.2.0, five agent slots are mandatory per company (including the Reviewer).

**API enum note:** The Paperclip API enforces a fixed role enum. Use the `paperclip_api_role` values from `config/roles.json` when calling `paperclip_create_agent` — not the spec display names. Key mappings: Worker → `engineer`, Knowledge Keeper → `pm`, Reviewer → `qa`. `self_review_prohibited` is not a platform field; embed it as instruction text in the Reviewer's capabilities.

- [ ] Create **CEO** agent:
  - Model: `claude-opus-5`
  - Adapter: `claude_local`
  - Auth: Claude.ai subscription OAuth
  - API role: `ceo`
  - AGENTS.md: include gbrain/graphify syntax, vault path, this standards repo URL, orchestrator-only rule.

- [ ] Create **Worker** agent:
  - Model: `gpt-5.6-sol`
  - Adapter: `codex_local`
  - Auth: ChatGPT subscription OAuth
  - API role: `engineer` (spec name is Worker; API enum is engineer)
  - `dangerouslyBypassApprovalsAndSandbox: true`
  - AGENTS.md: include Codex workflow (`/plan -> /goal -> $codex-review -> $review`), brain-first rule.
  - Skills: install `uinaf/codex-review`.

- [ ] Create **Knowledge Keeper** agent:
  - Model: `claude-sonnet-4-6` (latest takma adı kullanılmaz — geçersiz model id, PD'yi 5 hafta durdurdu)
  - Adapter: `claude_local`
  - Auth: Claude.ai subscription OAuth
  - API role: `pm` (spec name is Knowledge Keeper; API enum is pm)
  - Heartbeat: daily scheduled.
  - AGENTS.md: include vault conventions, weekly delta format.

- [ ] Create **Researcher** agent:
  - Model: `gpt-5.6-sol`
  - Adapter: `codex_local`
  - Auth: ChatGPT subscription OAuth
  - API role: `researcher`
  - Heartbeat: OFF.
  - AGENTS.md: include research workflow, output format, brain-first rule.

- [ ] Create **Reviewer** agent (mandatory as of v0.2.0):
  - Model: `gpt-5.6-sol`
  - Adapter: `codex_local`
  - Auth: ChatGPT subscription OAuth
  - API role: `qa`
  - Purpose note: `review-only; never self-review` (include in capabilities text — platform does not enforce)
  - AGENTS.md: include review workflow, verdict format, self-review prohibition.
  - Skills: install `uinaf/autoreview`, `uinaf/codex-review`, `uinaf/review-gang`.

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
- [ ] **Verify Knowledge company status is `active`.** The Knowledge company must remain `active` at all times. It is the ingest target for all production companies. Archiving the Knowledge company creates a silent fleet-wide blocker: the Paperclip API rejects cross-company API calls to archived companies with HTTP 403. CEOs and Routines must not change the Knowledge company status. If the Knowledge company needs to be paused for any reason, escalate to CC.

---

## Researcher-first specialist provisioning sequence

Before adding any specialist worker agents beyond the core 5, the company
MUST complete this research-driven loop. This prevents premature specialization
based on assumed needs rather than evidence.

### Step A — VISION + SOUL
CEO bootstrap first-issue produces:
- `VISION.md` (per `templates/VISION.md` schema): mission, target outcome, target customer/consumer, growth strategy, org structure, CEO mandate, guiding principles, anti-patterns
- `SOUL.md` (CEO identity, per `roles/ceo/SOUL.md` template)

### Step B — Researcher mission
CEO opens a Researcher issue with subject: "Survey best-in-class organizations in <company-domain> for hybrid casual mobile games. Identify: org structure, roles, tooling, gold-standard outputs, common failure modes."
Researcher produces a research brief at `~/Docs/paperclipcompanies/<company-name>/_knowledge-base/research/<domain>-best-in-class-orgs.md`.

### Step C — Knowledge Keeper synthesis
Knowledge Keeper reads the Researcher brief, builds the company wiki at
`~/Docs/paperclipcompanies/<company-name>/_knowledge-base/` covering:
- domain vocabulary (canonical terms; cross-reference standards CONTEXT.md)
- gold-standard org structure recommendation for this company specifically
- specialist role recommendations with rationale (link back to research evidence)
- tool stack additions specific to this domain (beyond the universal stack)

### Step D — Specialist roster decision
CEO + Atakan + CC review the wiki recommendation. Decision goes into
`docs/decisions/specialist-roster-v1.md` inside the company's repo (or
equivalent location). No specialist agents are created before this decision.

### Step E — Specialist provisioning
CEO creates specialist agents per the agreed roster. Each new specialist gets
a capability brief referencing the wiki section that justifies their role.

### Anti-patterns to avoid
- Creating specialists before VISION.md exists ("guessing the team")
- Creating specialists before Researcher brief ("guessing the gold standard")
- Skipping Knowledge Keeper synthesis ("research → action without curation")
- Using CC suggestions as the roster without Researcher evidence

---

## Final verification

- [ ] All 5 agents created and configured (CEO, Worker, Knowledge Keeper, Researcher, Reviewer).
- [ ] Tool stack validated (pass on all 4 tools).
- [ ] Delegation chain validated.
- [ ] Knowledge company notified.
- [ ] Company UUID recorded in `config/central-companies.json` (if central).

Company is ready for production work.
