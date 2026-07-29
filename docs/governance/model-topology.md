# Model Topology

Prose explanation of canonical model assignments. Machine-readable values are in `config/models.json` — this document explains the reasoning.

---

## Role assignments

### CEO — claude-opus-5

The CEO is the highest-stakes reasoning role in any company. It reads complex briefs, decomposes ambiguous problems into structured sub-issues, and makes judgment calls about priority and scope. Opus is the only model in the studio with sufficient reasoning depth for this role.

Auth: Claude.ai subscription OAuth. The Claude.ai subscription is the lowest-cost path to Opus without per-call API charges. Never use direct Anthropic API for production agents.

Reasoning effort: **high**. Set `"effortLevel": "high"` in `~/.claude/settings.json`. `claude_local` agents inherit this from user settings — there is no per-agent effort field.

### Worker — gpt-5.6-sol via Codex

Workers execute concrete tasks: code, file ops, research synthesis, CLI commands. GPT-5.6-sol via Codex CLI provides strong code execution, tool use, and fast iteration at subscription cost.

Codex must auth via ChatGPT subscription OAuth. OpenAI API keys are forbidden for workers — each call would consume API credits at real cost. The ChatGPT subscription provides unlimited (rate-limited) Codex use.

`dangerouslyBypassApprovalsAndSandbox: true` is required for workers to execute CLI commands and file operations without per-action approval prompts. This is intentional: the CEO is the approval layer, not the adapter.

Reasoning effort: **high**. Set `model_reasoning_effort = "high"` in `~/.codex/config.toml`. This is the only lever — `adapterConfig` has no effort key, so the setting is host-wide and applies to every `codex_local` agent on that machine. Setting it per agent is not possible; do not attempt it.

### Knowledge Keeper — claude-sonnet-4-6

The Knowledge Keeper does structured reading, writing, and synthesis. It does not need Opus-level reasoning — it needs high-quality prose and reliable instruction-following for note-taking, decision logging, and delta reports. Sonnet is the right cost/quality tradeoff for this role.

**latest takma adı kullanılmaz** (geçersiz model id, PD'yi 5 hafta durdurdu) — always pin an explicit dated/versioned model id, never the `-latest` alias.

Auth: Claude.ai subscription OAuth (same subscription as CEO, different agent).

Reasoning effort: **high**, inherited from `~/.claude/settings.json` (same mechanism as CEO).

### Researcher — gpt-5.6-sol via Codex

Researchers run structured search and synthesis workflows. The Codex workflow (`/plan -> /goal -> $codex-review -> $review`) is well-suited to research tasks: define scope, execute, self-check, ship. GPT-5.6-sol handles this competently.

Auth: ChatGPT subscription OAuth (same rule as Worker).

Reasoning effort: **high**, from `~/.codex/config.toml` (same host-wide mechanism as Worker).

### Reviewer — gpt-5.6-sol via Codex

Reviewers audit work products before a CEO accepts them. The role needs careful reading and defect detection rather than generative depth, and it must be cheap enough to run on every deliverable — GPT-5.6-sol via Codex fits both.

`self_review_prohibited` is not a platform field: the Paperclip API has no such flag. Embed "review-only; never self-review" as instruction text in the Reviewer's capabilities instead.

Auth: ChatGPT subscription OAuth (same rule as Worker).

Reasoning effort: **high**, from `~/.codex/config.toml` (same host-wide mechanism as Worker).

---

## Policy — reasoning effort is high for every role

All **five** roles run at **high** reasoning effort. There are exactly two levers, both host-level:

| Surface | File | Setting | Roles covered |
|---|---|---|---|
| Claude | `~/.claude/settings.json` | `"effortLevel": "high"` | CEO, Knowledge Keeper — all `claude_local` agents inherit it |
| Codex | `~/.codex/config.toml` | `model_reasoning_effort = "high"` | Worker, Researcher, **Reviewer** — host-wide, all `codex_local` agents |

**There is no per-agent effort setting.** `adapterConfig` has no effort key on either adapter. A new or rebuilt company inherits whatever the host is set to — so verifying these two files is a required provisioning step, not an optional one. See `docs/flows/new-company-checklist.md`.

---

## Policy — API direct use forbidden

No production agent may use an Anthropic API key or an OpenAI API key for model calls.

**Reason:** API keys charge per token. At studio scale (12-13 companies, multiple agents each), per-call billing would become significant. Subscription OAuth provides flat-rate access.

**Exception:** gbrain embedding endpoint only. The gbrain semantic search backend requires an OpenAI embedding key (`~/.secrets/openai-embedding.env`). This is a one-time embedding operation per document, not a per-query inference cost, and is explicitly approved.

---

## Future model changes

When a model version change is needed, follow `paperclip-version-policy.md`:
- New model in same family (e.g. opus-4-7 -> opus-4-8): minor bump.
- New model family or provider swap: major bump.
- All changes go through a `spec/<topic>` branch → PR to `main` → merge → branch deletion, and require Atakan approval at `main` merge if they touch CEO or Worker models.
