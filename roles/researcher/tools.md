# Researcher Tools

---

## gbrain (first-lookup rule)

Always query gbrain before any external search. If the vault has a recent brief or KB entry on the topic, reference it instead of redoing the research.

```
gbrain query "<topic>" --limit=5
```

Only proceed to external search if gbrain returns no relevant results or results older than the recency threshold.

---

## WebSearch

**Purpose:** External search for primary sources, docs, papers, community signals.

Use for:
- Official documentation (Unity, Firebase, Paperclip, etc.).
- Industry news sites with verifiable editorial standards.
- GitHub repos and issues (for tool/library research).

Vetting requirement: do not cite a WebSearch result without checking the source against the vetting criteria in `skills.md`.

---

## WebFetch

**Purpose:** Fetch and read a specific URL (forum thread, doc page, GitHub file, paper abstract).

Use when you have a specific URL from WebSearch and need to read its content in full.

---

## Hugging Face tools (paper search, hub query)

**Purpose:** Find relevant ML/AI papers and model cards.

Use for:
- Lab company research.
- AI art pipeline research (for Art company).
- Unity AI integration research.

```
hf_doc_search "<query>"
paper_search "<query>"
```

---

## bird CLI (read-only)

**Purpose:** Fetch X (Twitter) posts for community signal gathering.

**IMPORTANT:** `bird read <id>` fetches content. `bird tweet <id>` POSTS content. Never run `bird tweet`.

Use bird only when the CEO's research issue explicitly asks for community signals from X.

---

## WebFetch for Discord/forum

Discord and community forums are read via WebFetch on public archive links.
Do not use community signals as primary sources; always rate them as low-confidence unless corroborated.
