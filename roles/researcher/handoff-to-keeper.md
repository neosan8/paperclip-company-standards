# Researcher → Knowledge Keeper Handoff

The Researcher's brief has no value until it is ingested into the KB. This doc defines the handoff format and cadence.

---

## When to hand off

- Immediately after completing a research brief (do not batch).
- Do not wait for CEO to trigger the handoff; the Researcher initiates it.
- If the brief is time-sensitive (frontier alert, competitive signal), flag it as `priority` in the handoff comment.

---

## How to hand off

**Option A — Paperclip sub-issue (preferred)**

After the research brief is committed to `working`, create a sub-issue for the Knowledge Keeper:

```
Title: [ingest] Research brief: <topic> (PREFIX-NN)
Assignee: Knowledge Keeper
Description:
  Brief location: <file path on working branch>
  Source issue: PREFIX-NN
  Priority: normal / priority
  Action required: ingest into company KB; tag with <suggested tags>
  Recommended section: <suggested KB section>
```

Attach the brief file path, not its contents. The Knowledge Keeper fetches the file.

**Option B — Paperclip issue comment (when briefing is small)**

If the brief is short (under 400 words) and stands alone, the Researcher can post it as a comment on the original research issue and mention the Knowledge Keeper with `@knowledge-keeper`.

---

## What the Researcher includes in the handoff

1. Brief file path or full text.
2. Suggested KB taxonomy tags (1-3 tags from the company's existing tag set — use gbrain to look them up).
3. Recommended KB section.
4. Any time-sensitivity flag.
5. List of recommended actions from Section 5 of the brief (for the CEO to create Worker issues from).

---

## Cadence

- **Ad hoc:** research briefs are handed off immediately on completion.
- **Weekly digest:** if multiple small briefs were produced in a week, the Researcher creates a weekly digest comment listing all briefs by issue ID, for the Knowledge Keeper's weekly aggregation window.

---

## Confirmation

The Knowledge Keeper posts a confirmation comment on the handoff issue when ingestion is done:
```
Ingested. KB section: <section>. Tags: <tags>. Brief cross-referenced at <KB entry path>.
```

The Researcher's issue is closed only after the Keeper's confirmation is received and the CEO has reviewed the recommended actions list.
