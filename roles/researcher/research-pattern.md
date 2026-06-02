# Research Brief Pattern

Use this structure for all research briefs produced by the Researcher role.
A brief that deviates from this structure will be returned by the Knowledge Keeper with a re-format request.

---

## Brief header

```
# [Topic] — Research Brief
Company: <company name>
Issue: <PREFIX-NN>
Researcher: <agent handle>
Date: YYYY-MM-DD
Confidence summary: high / medium / mixed
```

---

## Section 1 — Question

One paragraph. Restate the research question exactly as the CEO assigned it.
If the question was ambiguous, note the interpretation you used.

---

## Section 2 — TL;DR (2-4 sentences)

The answer to the question, stated plainly. A reader who only reads this section should understand the key finding and action recommendation.

---

## Section 3 — Findings

Organized by finding (not by source). For each finding:

```
### Finding N — <title>

**Confidence:** high / medium / low
**Basis:** <list of sources that support this finding>

<2-4 sentence explanation of the finding and why it matters for the company's context.>
```

Keep to 3-6 findings. More than 6 means the question scope was too broad; split into sub-questions.

---

## Section 4 — Sources

```
| # | Title | Author/Org | Date | URL | Confidence tier |
|---|-------|-----------|------|-----|----------------|
| 1 | ... | ... | ... | ... | primary |
| 2 | ... | ... | ... | ... | primary |
| 3 | ... | ... | ... | ... | community |
```

Confidence tier:
- **primary** — official docs, peer-reviewed, verified practitioner content.
- **community** — X/forum/Discord signals, unverified but noted.
- **stale** — older than the recency threshold but included for historical context.

---

## Section 5 — Recommended actions

For each finding that warrants action, propose a specific next step:

```
- Finding N: [open a Worker issue / update KB entry / revisit in 30 days / no action needed]
```

Actions that require execution (code, file changes) go to Worker via a CEO-created issue.
Actions that require KB capture go to Knowledge Keeper.
The Researcher does not implement.

---

## Section 6 — What this brief does NOT cover

One bullet list of related questions that were out of scope for this brief.
This prevents the Knowledge Keeper from thinking the brief is more complete than it is.

---

## Length guidance

- Narrow question (one tool, one pattern): 300-600 words.
- Sector scan (multiple patterns): 600-1200 words.
- Frontier scan (whole domain): up to 2000 words, but split into sub-briefs if possible.
