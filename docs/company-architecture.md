# Company Architecture

**Primary path (Grok Bot seats, 2026-09-14):** one Paperclip company per game title. Three required Cursor agents: CEO, Worker, Reviewer. Layer-1 centrals are not required for seat spawn. Researcher and Knowledge Keeper are optional specialists, not standing slots.

Machine-readable values: `config/roles.json`, `config/models.json`. Operator path: `docs/operator-stack.md`.

---

## Primary — Grok game company (3-slot Cursor)

One company per active game title. Required seats:

| Agent | Role | API role | Adapter | Model |
|-------|------|----------|---------|-------|
| CEO | Orchestrates. Never executes. | `ceo` | `cursor` (`cursor-local` on Linux Grok Bot workers) | `auto` unless Neo pins a concrete Cursor id |
| Worker | Executes tasks | `engineer` | same Cursor lock | same |
| Reviewer | Independent quality gate. Verdict before CEO reports Done. Never reviews own work. | `qa` | same Cursor lock | same |

`reviewer_must_exist` remains true. No Grok-created game company is bootstrapped without an active Reviewer.

**Locked Neo / Atakan 2026-09-14:** On this required 3-slot profile the CEO MUST remain idle of production execution and only orchestrate and distribute work. The CEO does not write or produce deliverables. Worker produces. Reviewer independently gates quality. Heartbeat OFF is not this rule. Source: `roles/ceo/SOUL.md`.

Optional specialists (hire only when the CEO has a reason, not to recreate five-slot doctrine):

| Agent | Role | API role | Standing slot? |
|-------|------|----------|----------------|
| Researcher | Gold standards / frontier scan | `researcher` | no |
| Knowledge Keeper | Company KB; weekly delta only if Knowledge-central ingest is in use | `pm` | no |

If hired, optional specialists use the same Cursor lock unless Neo specifies otherwise. See `config/models.json` `optional_specialists`.

Grok Bot seats do **not**:

- bootstrap or recreate the 13-central layer
- adopt cross-company routing
- hire Claude/Codex adapters for required seats
- treat Hosted GHA as a spawn gate

---

## Legacy — Knowledge-central portfolio (not used by Grok Bot seats)

The material below is the historical two-layer studio: 13 standing central companies plus a five-slot mirror inside each company. It remains so Knowledge-central ownership is not erased. **Grok Bot seats must not be told to recreate it.**

### Layer 1 — 13 Central Companies

Central companies were permanent owners of template-level work and cross-game functions. Registry: `config/central-companies.json` (`grok_bot_seats_bootstrap_this_layer` is `false`).

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

**Note:** Knowledge sits outside the production swarm. Its role is validation, aggregation, and doctrine. It does not produce game content. Grok seats do not archive, recreate, or route through it as part of spawn.

### Layer 2 — historical five-slot per-game company

Each game company in this portfolio contained CEO + Worker + Researcher + Knowledge Keeper + Reviewer on Claude/Codex adapters. Model ids for that topology live only under `config/models.json` `legacy_five_slot`.

**KI-PS-1 (2026-06-02):** five-slot was the standard for this portfolio (lean CEO+Worker rejected). **Superseded for Grok seats 2026-09-14:** Grok seats are 3-slot Cursor. Five-slot remains findable here and is not the spawn path.

---

## Cross-company flow (legacy portfolio only)

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

Deliberately not adopted for Grok Bot seats: 13 permanent centrals, and cross-company routing. Game-company CEOs in the Grok path do not emit cross-company issues into Layer 1 as a required step.

---

## Creating a new game company

Follow `flows/new-company-checklist.md`. Operator layers: `docs/operator-stack.md`. Validate required seats against `config/models.json` and `config/roles.json` before marking the company ready.
