# Paperclip Standards Version Policy

This repo uses semantic versioning (`MAJOR.MINOR.PATCH`). Tags on `main` are the canonical version markers.

---

## When to bump

### MAJOR (x.0.0) — breaking model topology change

Bump major when a change **breaks existing company configs** — that is, a company running the previous version stops working correctly until it is reconfigured.

Examples:
- Switching CEO model from `claude-opus-5` to a different provider/model family.
- Changing the mandatory adapter (e.g. `claude_local` -> something else).
- Removing a mandatory agent role (e.g. eliminating Knowledge Keeper as a requirement).
- Changing the OAuth-only rule (e.g. permitting direct API keys for a role).

**The test is breakage, not effort.** Both major and minor require touching every active company — major through validation issues, minor through adoption issues. "Every company must be reconfigured" therefore does **not** by itself imply major. Ask instead: does the old config still function?

- Old config errors, or references something invalid → **major**.
- Old config still runs, just no longer matches the standard → **minor**.

A same-family model move (`claude-opus-4-7` → `claude-opus-5`, `gpt-5.5` → `gpt-5.6-sol`) is **minor**: the previous id remains valid, so nothing breaks. This matches `model-topology.md` ("new model in same family: minor bump"). Adding or changing a required `adapterConfig` setting such as reasoning effort is likewise **minor** — an agent without it still runs, at a non-standard value.

Pinning a role away from a broken id is also minor when the standard is the fix rather than the break: `claude-sonnet-latest` → `claude-sonnet-4-6` (v0.3.0) corrected an already-invalid id; the change repaired configs rather than invalidating them.

**Process for major bump:**
1. Branch off `main` (`spec/<topic>` or `fix/<topic>`), open PR targeting `main`; CC + Knowledge CEO review.
2. Atakan approves merge to main.
3. CC creates a validation issue in every active company to verify compatibility.
4. All companies must acknowledge the new version before the old version is considered retired.

### MINOR (0.x.0) — new mandatory requirement

Bump minor when a new thing is required of all companies but existing configs still work.

Examples:
- Adding a new mandatory specialist role (e.g. adding Knowledge Keeper + Researcher was a 0.0.0 -> 0.1.0 bump).
- Adding a new mandatory tool to `config/required-tools.json`.
- Adding a new required section to AGENTS.md.
- Formalizing a new flow that all companies must run.

**Process for minor bump:**
1. Branch off `main`, PR targeting `main` (standard PR flow).
2. CC creates adoption issues in all active companies for the new requirement.
3. Knowledge company tracks adoption status until all companies are compliant.

### PATCH (0.0.x) — clarifications and corrections

Bump patch for:
- Clarifying existing text without changing behavior.
- Fixing typos or broken links.
- Updating UUIDs in `config/central-companies.json` (KI-PS-3 resolution).
- Adding or updating known issues.
- Adding examples or anti-patterns to existing docs.

**Process for patch bump:**
1. Branch off `main`, PR targeting `main` (standard PR flow).
2. No adoption issues needed — passive update.

---

## Tagging

Tags are created on `main` only. Format: `vMAJOR.MINOR.PATCH`.

CC creates the tag after merge:
```
git tag v0.1.0 -m "add Knowledge Keeper + Researcher as mandatory specialists"
git push origin v0.1.0
```

---

## Current version

`v0.2.2` — latest tag on `main`. 13 central companies. Mandatory stack. **5** standard agents per company (CEO, Worker, Researcher, Knowledge Keeper, Reviewer — Reviewer became mandatory in v0.2.0). OAuth-only policy.

`v0.3.0` is in review (PR #11): model topology update and the reasoning-effort standard.
