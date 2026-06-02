# Company Architecture

Giant Aicado uses a two-layer Paperclip company structure.

---

## Layer 1 — 13 Central Companies

Central companies are permanent. They own template-level work and cross-game functions. Every game company consumes their outputs via cross-company issues.

| # | Name | Prefix | Role |
|---|------|--------|------|
| 1 | Market | GAM | Idea discovery, competitor analysis, deconstruction |
| 2 | Product Design | PROA | Template-level architect: GDD/level/economy/monetization templates; handoff to game-company PD |
| 3 | Dev | GIAAAAAA | Template-level HTML engineering patterns; handoff to game-company dev |
| 4 | Creatives | CRE | CTR creative production: video, banners, ads |
| 5 | Marketing | MAR | Campaign management, ASO, social |
| 6 | Art | ART | Figma GUI Kit, UI asset production |
| 7 | Animation | ANI | Game + UI + FX animations |
| 8 | SFX & Haptic | SFX | Sound design + haptic feedback templates (added 2026-06-02) |
| 9 | Analytics | ANA | Data pipeline; feeds all companies |
| 10 | Test | TES | QA, test reports, delivery to Giant Avocado |
| 11 | Lab | GIAAAAAAA | R&D, AI tool scouting, frontier scan |
| 12 | Website | GIAAAAAAAA | giantavocado.games ops (only `/giantaicado/*` paths) |
| 13 | Knowledge | KNO | Hermes review gate; owns this standards repo; weekly aggregation of per-company KBs |

**Note:** Knowledge sits outside the production swarm. Its role is validation, aggregation, and doctrine. It does not produce game content.

---

## Layer 2 — N Per-Game Companies

One Paperclip company is created per active game title.

Examples:
- Balloon Flow Studio (active, Stage 1 Unity)
- Match Derby Studio (active, meta substrate lab)

### Per-game company standard structure

Each game company contains:

| Agent | Role | Model |
|-------|------|-------|
| CEO | Orchestrates all work inside the game company | claude-opus-4-8 |
| Worker | Executes tasks (code, research, file ops) | gpt-5.5 via Codex |
| Knowledge Keeper | Maintains company-internal KB; weekly delta to Knowledge central | claude-sonnet-latest |
| Researcher | Finds gold standards and frontier patterns for the game's domain | gpt-5.5 via Codex |

**Open (KI-PS-1):** The above is the current safe default (tiered model). The question of whether game companies should be lean (CEO + Worker only) or full-mirror (all 13 roles internal) is pending Atakan answer in Q3 2026.

---

## Cross-company flow

```
Market
  |
  v
Product Design (template-level GDD)
  |
  v
Game Company CEO
  |-- Game Company Knowledge Keeper  <-- weekly delta --> Knowledge (central)
  |-- Game Company Researcher        <-- frontier scan
  |
  v
Game Company Worker
  |
  v
Giant Avocado (human team: Dogukan Unity dev, Burc/Osman art)
```

Central companies (Art, Animation, SFX, Analytics, Test) receive cross-company issues from game company CEOs. They do not embed agents inside game companies.

---

## Creating a new game company

Follow `flows/new-company-checklist.md`. Validate against `config/models.json` and `config/required-tools.json` before marking the company ready.
