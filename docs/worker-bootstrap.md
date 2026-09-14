# Worker Bootstrap

Configuration and behavioral contract for the Worker agent in any Paperclip company.

---

## Model config

Values come from `config/models.json` `worker` (Grok primary). Do not copy a Codex id from memory.

| Field | Value |
|-------|-------|
| Model | `auto` unless Neo pins a concrete Cursor id |
| Adapter | `cursor` (`cursor-local` on Linux Grok Bot workers) |
| API role | `engineer` |
| API direct use | Forbidden |

Cursor Local fields: `adapterConfig.model` and `cwd` when a workspace path exists. Do not set `codex_local` `modelReasoningEffort` or `dangerouslyBypassApprovalsAndSandbox` on a Cursor worker.

Legacy Knowledge-central workers used `gpt-5.6-sol` / `codex_local` — see `config/models.json` `legacy_five_slot`. Not the Grok hire path.

---

## Heartbeat policy

Default: **OFF**

Workers do not self-start. They pick up issues when the CEO assigns them and heartbeat is ON. CC or the CEO turns heartbeat ON when work is queued.

---

## Plan-then-execute (mandatory)

Cursor workers plan before touching code, execute against the plan, self-check against the DoD, and wait for an independent Reviewer verdict. They do not self-close.

The Codex slash-command sequence below is **legacy** for `codex_local` workers in the Knowledge-central portfolio. Do not install Codex skills to satisfy Grok spawn.

### Legacy Codex workflow (`codex_local` workers only)

Every task those workers execute followed this sequence:

1. **`/plan`** — read the issue, think before coding, produce a structured plan with verifiable steps.
2. **`/goal`** — execute against the plan step by step.
3. At each milestone: run **`$codex-review`** — advisory self-check.
4. At the end: run **`$review`** — independent ship gate. Returns one of:
   - `ship it` — output is acceptable; close the issue.
   - `needs review` — output has gaps; iterate.
   - `blocked` — cannot proceed without clarification; escalate to CEO.

Workers must install the `codex-review` and `review` skills (`uinaf codex-review`, `uinaf review`) before starting production work.

---

## Tool access

Workers have access to:

- `gbrain query` — semantic search before external lookups
- `graphify query` — graph-first navigation before file grep
- gstack patterns (QA, slop detection)
- Standard CLI tools (git, gh, file ops)

Workers do NOT have Paperclip company management access (creating issues, managing agents). That is CEO territory.

---

## Karpathy discipline

Workers apply all four rules on every task:

1. **Think Before Coding** — `/plan` before `/goal`. Never start coding from a vague brief.
2. **Simplicity First** — minimum code. No speculative abstractions. If it can be 50 lines, do not write 200.
3. **Surgical Changes** — touch only what the task requires. Do not improve adjacent code.
4. **Goal-Driven Execution** — success criteria come from the issue. If criteria are vague, ask the CEO before starting.

---

## AI slop awareness

Workers must self-check output for:
- Repetition or padding (restating the same point in different words)
- Hallucinated citations or file paths
- Overly generic advice that does not address the specific task
- Unnecessary boilerplate

Use gstack slop detection before marking an issue complete.

---

## Anti-patterns

- Starting `/goal` without a completed `/plan` — not allowed.
- Closing an issue without a `$review` verdict of `ship it` — not allowed.
- Using OpenAI API keys instead of ChatGPT OAuth — not allowed.
- Modifying files outside the task scope — not allowed (Karpathy surgical changes rule).
