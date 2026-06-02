# Worker Skills Catalog — Cross-Role Index

This file enumerates every skill available across role packs, identifies its source, and specifies which roles need it.

---

## Install instructions

Skills are installed via `skills.sh` (the uinaf skills marketplace) or via the Codex CLI plugin system.

```bash
skills.sh install <source>/<skill-name>
```

For Codex CLI:
```bash
codex skills install <skill-name>
```

---

## Core skills (all execution roles: Worker + Reviewer)

| Skill | Source | Target roles | Purpose |
|-------|--------|-------------|---------|
| `codex-review` | `uinaf/codex-review` | Worker, Reviewer | `$codex-review` advisory mid-execution check + `$review` final gate |
| `autoreview` | `uinaf/agents` | Reviewer | Branch-diff advisory review; never self-review |
| `review-gang` | `uinaf/agents` | Reviewer | Parallel multi-persona review (correctness, karpathy, security, performance, a11y) |

---

## CEO skills

| Skill | Source | Target roles | Purpose |
|-------|--------|-------------|---------|
| `autoplan` | studio standard | CEO | Decompose goals into ordered sub-issues before work begins |

The CEO does not install execution skills. If a CEO is found running `$codex-review` or `autoreview` directly, that is a role-scope violation.

---

## Worker-specific skills

| Skill | Source | Target roles | Purpose |
|-------|--------|-------------|---------|
| `gstack-qa` | `gstack` | Worker | Real-browser QA verification for UI/WebGL changes |
| `threejs-patterns` | `codex-game-studio` | Worker | Three.js/WebGL game template patterns |
| `tokenjuice` | studio standard | Worker | Token-efficient bash output wrappers |

---

## Researcher-specific skills

| Skill | Source | Target roles | Purpose |
|-------|--------|-------------|---------|
| `paper-search` | `mcp__claude_ai_Hugging_Face` | Researcher | HuggingFace + arXiv paper search |
| `hf-doc-search` | `mcp__claude_ai_Hugging_Face` | Researcher | HuggingFace doc search |
| `bird-read` | `bird` CLI | Researcher | X (Twitter) post fetch (read-only) |

---

## Knowledge Keeper-specific skills

| Skill | Source | Target roles | Purpose |
|-------|--------|-------------|---------|
| `gbrain-sync` | `gbrain` | Knowledge Keeper | Re-index KB after batch writes |
| `graphify-add` | `graphify` | Knowledge Keeper, Worker | Add knowledge graph nodes |

---

## Studio-wide mandatory stack (all roles)

These are not installable skills — they are tools that must be present in the environment. Verify on bootstrap.

| Tool | Install reference | Verify command |
|------|-----------------|----------------|
| gbrain | `docs/stack-standard.md` | `gbrain query "test"` |
| gstack | `docs/stack-standard.md` | `gstack --version` |
| graphify | `docs/stack-standard.md` | `graphify status` |
| LLM Wiki / Obsidian | `docs/stack-standard.md` | vault exists at `~/Docs/paperclipcompanies/_knowledge-base/` |
| TokenJuice | `docs/stack-standard.md` | `tokenjuice --version` |

---

## Version policy

All skill versions are tracked in `../config/skills-manifest.json`.
When a skill is updated upstream (new version in `uinaf/agents` or `uinaf/codex-review`), the Knowledge company Researcher opens a frontier-scan issue; the Knowledge company Worker updates `skills-manifest.json`; CC distributes the update via `sync-bootstrap.sh`.

Do not update skills unilaterally without updating `skills-manifest.json`.
