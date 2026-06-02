# VISION.md — Per-Company Constitution Schema

Copy this file to each company's root as `VISION.md`. Fill in all fields.
The CEO reads this file at every heartbeat before any other action.
Fields marked `[REQUIRED]` must not be left blank. Fields marked `[OPTIONAL]` may be left as "N/A" if not applicable.

---

## 1. Identity

**Company name:** [REQUIRED]
**Paperclip prefix:** [REQUIRED]
**Company type:** central / game
**Date established:** [REQUIRED] YYYY-MM-DD
**Last VISION update:** [REQUIRED] YYYY-MM-DD — _update this every time any field changes_

---

## 2. Mission

[REQUIRED] One sentence. What does this company exist to produce?

Example: "Produce template-level HTML game engineering patterns that any game company can fork to build a Stage 0 prototype."

---

## 3. Target customer (internal)

[REQUIRED] Who consumes this company's output?

For central companies: list the other companies or human teams that depend on this company's deliverables.
For game companies: list the game title, target player profile, and which central companies you depend on.

Example (Dev company):
> Primary customer: game company CEOs and Workers who need verified engineering patterns.
> Secondary customer: Giant Avocado Unity dev team (Dogukan) who adapts HTML patterns to Unity.

---

## 4. Current sprint goal

[REQUIRED — update every sprint]

One sentence. What does Done look like for the current active sprint?

---

## 5. Org structure

[REQUIRED] List the five agents currently configured for this company.

| Role | Agent handle | Status |
|------|-------------|--------|
| CEO | _handle_ | active / bootstrapping / missing |
| Worker | _handle_ | active / bootstrapping / missing |
| Researcher | _handle_ | active / bootstrapping / missing |
| Knowledge Keeper | _handle_ | active / bootstrapping / missing |
| Reviewer | _handle_ | active / bootstrapping / missing |

If any slot shows `missing`, opening a bootstrap issue is the CEO's first action.

---

## 6. CEO mandate

[REQUIRED] 2-4 sentences. What is the CEO of this company responsible for that no other agent can substitute?

Guidance: include the quality-gate obligation and the escalation threshold specific to this company's domain.

Example:
> The CEO of the Dev company ensures that every engineering pattern shipped to game companies is production-ready and Unity-adapted. No pattern leaves the working branch without Reviewer `ship it`. The CEO escalates to CC whenever a pattern requires a new tool dependency not in the studio stack.

---

## 7. Growth strategy

[OPTIONAL for central companies — REQUIRED for game companies]

For game companies: describe how the game title is expected to grow. Target metrics (D1/D7 retention, ARPU), pipeline stage targets, and timeline expectations.

For central companies: describe how this company's output templates are expected to scale as more game companies are added.

---

## 8. Guiding principles

[REQUIRED] 3-5 bullet points. Non-negotiable operating principles specific to this company.

These are NOT the studio-wide principles (Karpathy, OAuth-only, etc. — those apply universally).
These are company-specific: what this company values above other tradeoffs.

Examples:
- "Every output is tested in a real game context before being promoted to a template."
- "Research briefs cite primary sources only; community signals are never presented as facts."
- "KB entries are always tagged; untagged entries are deleted on next decay pass."

---

## 9. Anti-patterns

[REQUIRED] 3-5 bullet points. What this company must never do.

Examples:
- "Never ship a pattern that has not been validated against the Three.js performance budget."
- "Never ingest a research brief without cross-linking it to at least one existing KB entry."
- "Never run a heartbeat with an empty issue queue."

---

## 10. Key dependencies

[OPTIONAL but recommended]

List the external companies, tools, or humans this company depends on for its operation.

| Dependency | Type | Notes |
|-----------|------|-------|
| Knowledge (KNO) | Central company | Weekly delta recipient |
| CC | Orchestrator | Heartbeat lifecycle manager |
| _human name_ | Human team | _what they provide_ |

---

## 11. Open questions (company-level)

[OPTIONAL] Known open questions that affect this company's operating model.
Cross-reference with `../../docs/known-issues.md` for studio-wide KIs.

---

_VISION.md is owned by the CEO. The CEO updates it. The Knowledge Keeper captures version history in the company KB._
