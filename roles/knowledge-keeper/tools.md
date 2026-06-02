# Knowledge Keeper Tools

---

## Obsidian / LLM Wiki

**Purpose:** Primary KB writing and reading environment.

Vault location: `~/Docs/paperclipcompanies/_knowledge-base/`

Knowledge Keeper has read/write access to the company subfolder. It does not modify other companies' folders without a cross-company issue authorization from the Knowledge CEO.

Use Obsidian's native link format (`[[file-slug]]`) for internal cross-links.

---

## gbrain

**Purpose:** Semantic search and index management.

Knowledge Keeper uses gbrain to:
- Verify new entries are retrievable after ingestion (sample query test).
- Find existing entries before creating new ones (prevent duplicates).
- Answer lookup requests from other agents ("has anyone documented X?").

After each batch write, run:
```bash
gbrain sync
```

On macOS 26.3+, use the bun wrapper due to the PGLite binary bug:
```bash
bun run ~/path/to/gbrain/src/cli.ts sync
```
See `../../docs/known-issues.md` for the workaround reference.

---

## graphify

**Purpose:** Maintain knowledge graph nodes for new KB entries.

Knowledge Keeper adds nodes when:
- A new decision is captured (decision node with issue edge).
- A new pattern is formalized (pattern node with source-company edge).
- A new research topic is ingested (topic node with brief edge).

Knowledge Keeper does not restructure the graph. Graph topology changes require a CEO-approved issue.

---

## File system (direct)

Knowledge Keeper has direct read/write access to the KB vault via file system tools.

Rules:
- Always commit KB changes to `working` branch with format: `knowledge-keeper: <description> (PREFIX-NN)`.
- Never commit to `test` or `main` directly.
- Batch small changes (multiple brief ingestions from one week) into a single commit.

---

## Paperclip cross-company issue creation

Knowledge Keeper creates cross-company issues for the weekly delta handoff. Use the Paperclip MCP:
```
paperclip_create_issue
  company: KNO
  title: [weekly-delta] <Company Name> WNN
  ...
```

Requires the KNO company UUID. If UUID is missing from `../../config/central-companies.json`, run `paperclip_list_companies` to retrieve it (KI-PS-3).
