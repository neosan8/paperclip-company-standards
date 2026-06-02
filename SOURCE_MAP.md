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

## 8. Machine-readable config (canonical values)

15. `config/models.json` — canonical model assignments per agent role
16. `config/required-tools.json` — required tools with purpose and notes
17. `config/central-companies.json` — 13 central companies with prefix and role
