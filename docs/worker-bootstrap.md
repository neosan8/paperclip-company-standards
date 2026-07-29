# Worker Bootstrap

Configuration and behavioral contract for the Worker agent in any Paperclip company.

---

## Model config

| Field | Value |
|-------|-------|
| Model | `gpt-5.6-sol` |
| Adapter | `codex_local` |
| Auth | ChatGPT subscription OAuth |
| Reasoning effort | **high** — `adapterConfig.modelReasoningEffort: "high"` |
| `dangerouslyBypassApprovalsAndSandbox` | `true` |
| API direct use | Forbidden |

**Effort is set per agent.** `codex_local` reads `adapterConfig.modelReasoningEffort`. Paperclip runs each codex agent in a managed per-agent `CODEX_HOME`, so `~/.codex/config.toml` is not read by company agents — a correctly configured host proves nothing about this worker. Verify the agent's own `adapterConfig`.

**Critical:** Codex must auth via ChatGPT subscription, never OpenAI API. Using API keys costs real money per call. If Codex prompts for an API key, stop and fix the auth config.

---

## Heartbeat policy

Default: **OFF**

Workers do not self-start. They pick up issues when the CEO assigns them and heartbeat is ON. CC or the CEO turns heartbeat ON when work is queued.

---

## Codex workflow (mandatory)

Every task the Worker executes must follow this sequence:

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
