# Company KB Structure Pattern

The company-internal KB lives at:
```
~/Docs/paperclipcompanies/_knowledge-base/<company-name>/
```

All 11 production companies share this vault. Knowledge central has the root; per-company content is namespaced by company folder.

---

## Top-level structure

```
<company-name>/
  README.md                  (vault index; read this first)
  decisions/                 (architectural and product decisions)
  research/                  (research briefs from Researcher)
  patterns/                  (reusable patterns and templates adopted by this company)
  weekly-deltas/             (outbound delta archives — one file per week)
  _archived/                 (decayed or superseded entries)
```

---

## README.md (vault index)

Every company's KB folder must have a `README.md` that lists:
- Company name and prefix.
- Active sections with one-line descriptions.
- Tag set in use.
- Last gbrain sync date.
- Knowledge Keeper agent handle.

---

## decisions/

One file per major decision. Filename: `YYYY-MM-DD-<slug>.md`.

Example: `2026-06-02-reviewer-agent-model-assignment.md`

Use the decision record format from `skills.md`.

Group decisions by quarter subfolder if count exceeds 20:
```
decisions/
  2026-Q2/
    2026-06-02-reviewer-agent-model-assignment.md
```

---

## research/

One file per research brief. Filename: `YYYY-MM-DD-<topic-slug>.md`.

Do not modify brief content after ingestion. If a brief needs amendment, create a new brief (`v2`) and cross-link.

Each brief must have front matter:
```
---
source-issue: PREFIX-NN
researcher: <agent handle>
ingested: YYYY-MM-DD
tags: [tag1, tag2]
confidence: high / medium / mixed
---
```

---

## patterns/

Reusable implementation patterns adopted by this company. These are the "how we do things here" entries.

Example entries:
- `three-js-screen-transition.md` — standard pattern for game screen transitions.
- `heartbeat-lifecycle.md` — how this company manages heartbeat start/stop.

Patterns are proposed by Worker or Researcher via their Done report. The CEO creates a Knowledge Keeper issue to formalize the pattern. The Knowledge Keeper writes the pattern doc.

---

## weekly-deltas/

One file per week: `YYYY-WNN.md` (ISO week number).

Contains the outbound delta sent to Knowledge central. See `weekly-aggregation-handoff.md`.
Archive these; never delete.

---

## Naming conventions

- Filenames: `YYYY-MM-DD-<slug>.md` or `<topic-slug>.md` (for patterns, no date).
- Slugs: lowercase, hyphens only, no spaces.
- No emoji in filenames.
- No special characters except hyphens and underscores.
