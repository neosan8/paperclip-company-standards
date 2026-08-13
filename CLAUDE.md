# Claude Instructions

**Read [`AGENTS.md`](./AGENTS.md) first**, then [`CONTEXT.md`](./CONTEXT.md) for the glossary.

There is deliberately no second copy of the rules here. The failure this repo suffers most is the same fact kept in two places and drifting apart — three of five errors made on 2026-07-29 were that class — so a `CLAUDE.md` restating `AGENTS.md` would be the very mistake the standard warns against.

Two things worth repeating anyway:

- **This repo's output is configuration, not documentation.** Thirteen companies configure their agents from it. A wrong model id here does not produce a confusing paragraph; it stops a company. One `latest` alias, used as a model id, halted Product Design for five weeks.
- **A standard nobody runs is not a standard.** If a new rule cannot be checked by `scripts/validate-stack.sh` or the consistency workflow, it will drift unnoticed. Prefer a verifiable rule over a well-written one.
