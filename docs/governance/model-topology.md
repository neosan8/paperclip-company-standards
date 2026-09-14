# Model Topology

Prose explanation of canonical model assignments. Machine-readable values are in `config/models.json` — this document explains the reasoning. Do not copy model ids into new files; point here or at that JSON.

**Cursor lock (2026-09-14, Neo / Atakan):** for Grok-created companies, Cursor Local supersedes the Claude/Codex defaults. Required seats are CEO, Worker, Reviewer. Model is `auto` unless Neo pins a concrete Cursor id. Concrete ids beat aliases. `latest` is forbidden. Unverified model strings are forbidden.

Verified 2026-09-14 against [Cursor Local](https://docs.paperclip.ing/reference/adapters/cursor-local/) (`paperclipai/paperclip-docs`). Paperclip `adapterType` is `cursor`. On Linux Grok Bot workers use `cursor-local`.

---

## Primary — Grok Bot game company (Cursor)

### CEO, Worker, Reviewer — `auto` on Cursor Local

All three required seats use the same adapter family. The seat does not pick a Claude or Codex id. `auto` lets Cursor choose; Neo may replace it with a concrete id from the live Cursor Local list. Do not invent a replacement if `auto` misbehaves — escalate (see KI-PS-9).

| Role | API role | Adapter | Model |
|------|----------|---------|-------|
| CEO | `ceo` | `cursor` (`cursor-local` on Linux Grok Bot workers) | `auto` unless Neo pins |
| Worker | `engineer` | same | same |
| Reviewer | `qa` | same | same |

Reviewer remains independent. `self_review_prohibited` is not a platform field: embed `review-only; never self-review` in capabilities text.

Cursor Local config that matters at hire time is `adapterConfig.model` (and `cwd` when a workspace path exists). Do not apply `claude_local` `effort` or `codex_local` `modelReasoningEffort` to Cursor agents.

Heartbeat stays OFF until work is queued. Idle is success.

### Optional specialists

Researcher and Knowledge Keeper are not standing slots on the Grok path. If hired, they use the same Cursor lock unless Neo specifies otherwise (`config/models.json` `optional_specialists`).

---

## Policy — never `latest`, never invent ids

A `latest` alias used as a model id halted Product Design for five weeks. The rule is unchanged: pin an explicit id, or use the documented Cursor default `auto`. Do not write a plausible-looking Cursor model string that you have not verified on [docs.paperclip.ing](https://docs.paperclip.ing/reference/adapters/cursor-local/).

---

## Policy — API direct use forbidden

No production agent may be pointed at a raw Anthropic or OpenAI API key for model calls.

**Grok primary:** Cursor Local uses the local Cursor Agent CLI. Do not add API keys to make Cursor "work."

**Legacy five-slot:** Claude.ai subscription OAuth and ChatGPT subscription OAuth still apply to that portfolio.

**Exception:** gbrain embedding endpoint only (`~/.secrets/openai-embedding.env`), when that stack is in use.

---

## Legacy — five-slot Claude/Codex (Knowledge-central portfolio)

Not used by Grok Bot seats. Kept so that portfolio is not rewritten out of existence.

| Role | Adapter | Model (historical) |
|------|---------|-------------------|
| CEO | `claude_local` | `claude-opus-5` |
| Worker | `codex_local` | `gpt-5.6-sol` |
| Knowledge Keeper | `claude_local` | `claude-sonnet-4-6` |
| Researcher | `codex_local` | `gpt-5.6-sol` |
| Reviewer | `codex_local` | `gpt-5.6-sol` |

On that topology, reasoning effort was **high** for every role, set per agent in `adapterConfig`:

| Adapter | Field | Roles |
|---------|-------|-------|
| `claude_local` | `adapterConfig.effort` | CEO, Knowledge Keeper |
| `codex_local` | `adapterConfig.modelReasoningEffort` | Worker, Researcher, Reviewer |

Host files (`~/.claude/settings.json`, `~/.codex/config.toml`) do not control Paperclip agents. Paperclip gives each Codex agent a managed `CODEX_HOME`. That paragraph applies only to the legacy adapters.

`dangerouslyBypassApprovalsAndSandbox: true` was required for Codex workers. The CEO is the approval layer, not the adapter. Grok Cursor workers do not carry that Codex flag.

---

## Future model changes

When a model version change is needed, follow `paperclip-version-policy.md`:
- New model in same family: minor bump.
- New model family or provider swap: major bump.
- Pinning away from `auto` to a concrete Cursor id is a Neo decision and a minor bump if the previous id still functions.
- All changes go through a `spec/<topic>` branch → PR to `main` → merge → branch deletion, and require Atakan approval at `main` merge if they touch CEO or Worker models.
