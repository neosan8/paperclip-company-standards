# Operator stack — Grok Bot seats

How a Grok Bot seat talks to Paperclip when creating or running a game company. Values here are the seat contract. Re-check [docs.paperclip.ing](https://docs.paperclip.ing) before a command family you have not used recently — the live site is the current surface; this page names layers, not a pasted CLI manual.

Paperclip documentation is CC BY-NC-ND. Summarize and link. Do not paste large verbatim upstream docs.

Source of the live docs: repo `paperclipai/paperclip-docs`. Do not use `aronprins/paperclip-docs` (404). Standing rule: inject/check this URL whenever operator docs are opened.

---

## Layers

| Layer | Role |
|-------|------|
| MCP primary | `neosan8/paperclip-mcp`. `PAPERCLIP_URL=http://127.0.0.1:3100`. Call `paperclip_health` first. MCP is CRUD only (companies, agents, issues, projects, goals). Do not vendor that repo into this standards repo. |
| CLI fallback | `npx paperclipai … --json` for operations MCP does not cover: approvals, wake, checkout, routines, budgets, secrets, whoami. Never `pnpm paperclipai`. Command names change — confirm on [docs.paperclip.ing](https://docs.paperclip.ing) (CLI reference) before running. |
| Browser | Never the default. Do not open the Paperclip UI to create a company, hire a seat, wake an agent, or handle an approval unless MCP and CLI both cannot do the job. |
| Docs | Always re-check https://docs.paperclip.ing (repo `paperclipai/paperclip-docs`). Standing: inject/check always. |

---

## What MCP may do

Health, then create/read/update of companies, agents, issues, projects, and goals. That is the create/hire path. See `flows/new-company-checklist.md`.

## What CLI must do

Wake, approvals, issue checkout (409 means stop), routines, budgets, secrets, `whoami`. MCP does not cover these. Always pass `--json`.

## What not to install as Grok runtime

`run-paperclip` and `paperclip-vision` as plugins are not the Grok seat runtime. Borrow ideas only. Do not install them to satisfy this standard.

Hosted GitHub Actions is not a spawn gate. A company is ready when the 3-slot Cursor hire and first CEO-Worker-Reviewer loop succeed, not when a hosted workflow is green.

---

## Studio wiring (seat context, not a spawn checklist)

- Monorepo the companies work in: `neosan8/giant-aicado`
- Bank: `coding-agent::giant-aicado`
- One Paperclip company per game title
- Heartbeat OFF until work is queued
- Board / deputy (the Grok Bot seat) talks only to the company CEO — see `standards/cc-paperclip-communication-protocol.md`

Giant-aicado operator lock lives in that repo (`studio/docs/flows/paperclip.md`). This standards repo is what seats read. Do not recreate the lock here as a second copy of every giant-aicado fact.

---

## Still-valid doctrine

CEO never executes. Reviewer is independent. Approval-wake first. Checkout before work; 409 means another owner — do not proceed. Backlog is invisible until flipped to `todo`. Idle is success when the queue is empty. One fact in one place. `latest` is not a model id.
