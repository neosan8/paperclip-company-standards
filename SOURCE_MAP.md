# paperclip-company-standards — Source Map

Recommended read order for any agent or developer picking up this repo.

## 1. Orient (start here)

1. `README.md` — what this repo is, who owns it, branch model
2. `CONTEXT.md` — domain glossary; decode all jargon before reading docs
3. `SOURCE_MAP.md` — this file; orient read order

## 2. Issues and known gaps (read early)

4. `docs/known-issues.md` — open KIs; check before making decisions that touch open questions

## 3. Architecture and stack (foundation)

5. `docs/company-architecture.md` — 13 central companies + N game companies; full company tier
6. `docs/stack-standard.md` — mandatory tool stack for every company and every human team CC install

## 4. Agent bootstrap configs

7. `docs/ceo-bootstrap.md` — CEO agent config: model, adapter, heartbeat, capabilities
8. `docs/worker-bootstrap.md` — Worker agent config: model, adapter, Codex workflow

## 5. Specialist roles (mandatory per company)

9. `docs/specialists/knowledge-keeper.md` — per-company Knowledge Keeper (Sonnet)
10. `docs/specialists/researcher.md` — per-company Researcher (GPT-5.5)

## 6. Operational flows

11. `docs/flows/new-company-checklist.md` — atomic checklist CC runs when creating a new Paperclip company
12. `docs/flows/weekly-knowledge-aggregation.md` — CC + Knowledge handoff playbook

## 7. Governance

13. `docs/governance/paperclip-version-policy.md` — semver policy; when to bump major/minor/patch
14. `docs/governance/model-topology.md` — prose mirror of config/models.json; explains model choices

## 8. Role packs (v0.2.0 — new)

15. `roles/_shared/CONTEXT.md` — canonical vocabulary for all roles; read before any role doc
16. `roles/_shared/CONTRIBUTING.md` — commit format, secrets rule, no-push-without-review
17. `roles/_shared/DEFINITION-OF-DONE.md` — DoD checklist: Worker self-check + Reviewer verification
18. `roles/_shared/PROJECT-INVENTORY.md` — template: CEO reads before delegating each heartbeat
19. `roles/ceo/` — CEO role pack: README, skills, heartbeat (12-step), tools, SOUL, autoreview-invocation
20. `roles/worker/` — Worker role pack: README, skills, heartbeat (Step 8 DoD mandatory), tools
21. `roles/researcher/` — Researcher role pack: README, skills, research-pattern, handoff-to-keeper, tools
22. `roles/knowledge-keeper/` — Keeper role pack: README, skills, wiki-pattern, weekly-aggregation-handoff, tools
23. `roles/reviewer/` — Reviewer role pack: README, skills (autoreview + review-gang), review-pattern, verdict-format, tools

## 9. Templates (v0.2.0 — new)

24. `templates/VISION.md` — per-company constitution schema (CEO reads every heartbeat)
25. `templates/CEO_BOOTSTRAP.md` — one-time per-company first-boot checklist (9 steps)

## 10. Standards (v0.2.0 — new)

26. `standards/reviewer-pattern.md` — end-to-end gate flow: worker done → reviewer → verdict → Done to CC
27. `standards/sync-bootstrap.sh` — idempotent merge to ~/.codex/AGENTS.md + ~/.claude/CLAUDE.md symlink
28. `standards/approval-wake-protocol.md` — PAPERCLIP_APPROVAL_ID handling; checkout-before-work; 409 rule
29. `standards/worker-skills-catalog.md` — cross-role index of all skills, sources, target roles

## 11. Machine-readable config (canonical values)

30. `config/models.json` — canonical model assignments per agent role (includes reviewer as of v0.2.0)
31. `config/roles.json` — 5 role definitions + agent slot counts + model assignments (v0.2.0)
32. `config/skills-manifest.json` — all skills, source repos, target roles, versions (v0.2.0)
33. `config/required-tools.json` — required tools with purpose and notes
34. `config/central-companies.json` — 13 central companies with prefix and role (5-slot note added v0.2.0)
