---
name: analyze
description: >
  Slash command: /analyze. Delegates requirement analysis to the analyst agent. Use when the
  user types "/analyze [domain]" to produce a structured requirements package.
---

# /analyze — Requirement Analysis

Delegate to the **analyst** agent:

> Analyze requirements for `$ARGUMENTS`.
> 1. Read CLAUDE.md first.
> 2. If `docs/requirements/$ARGUMENTS/` exists, review and extend — don't overwrite.
> 3. Produce `clarification.md`, `functional-reqs.md`, `nonfunctional-reqs.md`, `traceability.md`.
> 4. Save under `docs/requirements/$ARGUMENTS/`.

If `$ARGUMENTS` is empty, ask which domain to analyze before delegating.
