# Model Topology

Prose explanation of canonical model assignments. Machine-readable values are in `config/models.json` — this document explains the reasoning.

---

## Role assignments

### CEO — claude-opus-5

The CEO is the highest-stakes reasoning role in any company. It reads complex briefs, decomposes ambiguous problems into structured sub-issues, and makes judgment calls about priority and scope. Opus is the only model in the studio with sufficient reasoning depth for this role.

Auth: Claude.ai subscription OAuth. The Claude.ai subscription is the lowest-cost path to Opus without per-call API charges. Never use direct Anthropic API for production agents.

Reasoning effort: **high** — set `adapterConfig.effort: "high"` on the agent (passed to the CLI as `--effort high`).

### Worker — gpt-5.6-sol via Codex

Workers execute concrete tasks: code, file ops, research synthesis, CLI commands. GPT-5.6-sol via Codex CLI provides strong code execution, tool use, and fast iteration at subscription cost.

Codex must auth via ChatGPT subscription OAuth. OpenAI API keys are forbidden for workers — each call would consume API credits at real cost. The ChatGPT subscription provides unlimited (rate-limited) Codex use.

`dangerouslyBypassApprovalsAndSandbox: true` is required for workers to execute CLI commands and file operations without per-action approval prompts. This is intentional: the CEO is the approval layer, not the adapter.

Reasoning effort: **high** — set `adapterConfig.modelReasoningEffort: "high"` on the agent. Note that Paperclip runs codex agents in a managed per-agent `CODEX_HOME`, so `~/.codex/config.toml` is not read by company agents.

### Knowledge Keeper — claude-sonnet-4-6

The Knowledge Keeper does structured reading, writing, and synthesis. It does not need Opus-level reasoning — it needs high-quality prose and reliable instruction-following for note-taking, decision logging, and delta reports. Sonnet is the right cost/quality tradeoff for this role.

**latest takma adı kullanılmaz** (geçersiz model id, PD'yi 5 hafta durdurdu) — always pin an explicit dated/versioned model id, never the `-latest` alias.

Auth: Claude.ai subscription OAuth (same subscription as CEO, different agent).

Reasoning effort: **high** — `adapterConfig.effort: "high"` (same mechanism as CEO).

### Researcher — gpt-5.6-sol via Codex

Researchers run structured search and synthesis workflows. The Codex workflow (`/plan -> /goal -> $codex-review -> $review`) is well-suited to research tasks: define scope, execute, self-check, ship. GPT-5.6-sol handles this competently.

Auth: ChatGPT subscription OAuth (same rule as Worker).

Reasoning effort: **high** — `adapterConfig.modelReasoningEffort: "high"` (same mechanism as Worker).

### Reviewer — gpt-5.6-sol via Codex

Reviewers audit work products before a CEO accepts them. The role needs careful reading and defect detection rather than generative depth, and it must be cheap enough to run on every deliverable — GPT-5.6-sol via Codex fits both.

`self_review_prohibited` is not a platform field: the Paperclip API has no such flag. Embed "review-only; never self-review" as instruction text in the Reviewer's capabilities instead.

Auth: ChatGPT subscription OAuth (same rule as Worker).

Reasoning effort: **high** — `adapterConfig.modelReasoningEffort: "high"` (same mechanism as Worker).

---

## Policy — reasoning effort is high for every role

All **five** roles run at **high** reasoning effort. Effort is set **per agent, in `adapterConfig`** — this is the controlling surface for Paperclip-managed agents:

| Adapter | Field | Values | Roles |
|---|---|---|---|
| `claude_local` | `adapterConfig.effort` | `low` \| `medium` \| `high` | CEO, Knowledge Keeper |
| `codex_local` | `adapterConfig.modelReasoningEffort` | `low` \| `medium` \| `high` | Worker, Researcher, Reviewer |

`claude_local` passes the value to the CLI as `--effort`; `codex_local` applies `modelReasoningEffort` to the Codex session config.

**Host config files do not control Paperclip agents.** `~/.claude/settings.json` and `~/.codex/config.toml` govern *host-run* agents only — a directly invoked Claude Code or Codex CLI session. Paperclip runs each codex agent in a **managed per-agent `CODEX_HOME`** under `instances/<id>/companies/<companyId>/agents/<agentId>/codex-home/`, and an explicit `CODEX_HOME` override must never point at `~/.codex` or the shared company codex-home.

Setting the host files and assuming companies inherit them is the failure mode this section exists to prevent: agents keep running at default effort while the host looks correctly configured. **Verify `adapterConfig` on every agent.** See `docs/flows/new-company-checklist.md`.

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
