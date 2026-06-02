# CEO Tools

Tools available to the CEO role. CEOs use these for read, plan, and coordinate operations — never for execution.

---

## Paperclip CLI / MCP

**Purpose:** Issue management — create, read, update, checkout, assign, close.

Key operations:
- `paperclip_list_issues` — get current queue with status.
- `paperclip_create_issue` — create a sub-issue; include title, description, acceptance criteria, assignee role.
- `paperclip_update_issue` — update status, add comments, attach Reviewer verdict.
- `POST /api/issues/{id}/checkout` — claim exclusive ownership before delegating. 409 = owned by other agent.
- `paperclip_list_companies` — list companies with UUIDs for cross-company issue creation.

**Auth:** uses the ambient Paperclip session (no separate OAuth step).

---

## gbrain

**Purpose:** Semantic search across the shared Knowledge vault before asking CC or opening external search.

When to use:
- Before creating a new doc, check if one already exists.
- Before making an architecture decision, check if a prior decision was captured.
- Before researching a topic, check if the Knowledge Keeper already has a briefing.

**Lookup order:** gbrain first, then CC, then external.

See `../../docs/stack-standard.md` for setup.

---

## graphify

**Purpose:** Knowledge graph — add nodes and edges for decisions, files, and concepts.

CEO adds to the graph when:
- A significant architectural decision is made.
- A new pattern or template is adopted.
- A cross-company relationship is established.

The GRAPH_REPORT.md referenced in AGENTS.md is generated from graphify. Keep it current.

---

## GitHub CLI (`gh`)

**Purpose:** Branch inspection, PR creation, diff review.

CEO uses `gh` to:
- Check `working` branch status before triggering Reviewer.
- Verify that deliverable commits are pushed.
- Create PRs from `working` to `test` after CC review gate.

CEO does NOT use `gh` to:
- Commit code.
- Merge to `main` without Atakan approval.
- Force-push any branch.

---

## LLM Wiki (Obsidian)

**Purpose:** Second-brain lookup — company decisions, past context, playbooks.

Vault location: `~/Docs/paperclipcompanies/_knowledge-base/`

CEO reads from the vault; does not write to it directly. Writing is the Knowledge Keeper's responsibility. If the CEO needs to capture something, it creates a Knowledge Keeper issue to do so.
