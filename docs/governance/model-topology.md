# Model Topology

Prose explanation of canonical model assignments. Machine-readable values are in `config/models.json` — this document explains the reasoning.

---

## Role assignments

### CEO — claude-opus-4-8

The CEO is the highest-stakes reasoning role in any company. It reads complex briefs, decomposes ambiguous problems into structured sub-issues, and makes judgment calls about priority and scope. Opus is the only model in the studio with sufficient reasoning depth for this role.

Auth: Claude.ai subscription OAuth. The Claude.ai subscription is the lowest-cost path to Opus without per-call API charges. Never use direct Anthropic API for production agents.

### Worker — gpt-5.5 via Codex

Workers execute concrete tasks: code, file ops, research synthesis, CLI commands. GPT-5.5 via Codex CLI provides strong code execution, tool use, and fast iteration at subscription cost.

Codex must auth via ChatGPT subscription OAuth. OpenAI API keys are forbidden for workers — each call would consume API credits at real cost. The ChatGPT subscription provides unlimited (rate-limited) Codex use.

`dangerouslyBypassApprovalsAndSandbox: true` is required for workers to execute CLI commands and file operations without per-action approval prompts. This is intentional: the CEO is the approval layer, not the adapter.

### Knowledge Keeper — claude-sonnet-latest

The Knowledge Keeper does structured reading, writing, and synthesis. It does not need Opus-level reasoning — it needs high-quality prose and reliable instruction-following for note-taking, decision logging, and delta reports. Sonnet is the right cost/quality tradeoff for this role.

Auth: Claude.ai subscription OAuth (same subscription as CEO, different agent).

### Researcher — gpt-5.5 via Codex

Researchers run structured search and synthesis workflows. The Codex workflow (`/plan -> /goal -> $codex-review -> $review`) is well-suited to research tasks: define scope, execute, self-check, ship. GPT-5.5 handles this competently.

Auth: ChatGPT subscription OAuth (same rule as Worker).

---

## Policy — API direct use forbidden

No production agent may use an Anthropic API key or an OpenAI API key for model calls.

**Reason:** API keys charge per token. At studio scale (12-13 companies, multiple agents each), per-call billing would become significant. Subscription OAuth provides flat-rate access.

**Exception:** gbrain embedding endpoint only. The gbrain semantic search backend requires an OpenAI embedding key (`~/.secrets/openai-embedding.env`). This is a one-time embedding operation per document, not a per-query inference cost, and is explicitly approved.

---

## Future model changes

When a model version change is needed, follow `paperclip-version-policy.md`:
- New model in same family (e.g. opus-4-8 -> opus-4-9): minor bump.
- New model family or provider swap: major bump.
- All changes go through a `spec/<topic>` branch → PR to `main` → merge → branch deletion, and require Atakan approval at `main` merge if they touch CEO or Worker models.
