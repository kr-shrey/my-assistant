---
name: architect
description: >
  Slash command: /architect. Delegates architecture design to the architect agent. Use when the
  user types "/architect [feature]" to produce a spec and ADRs from a requirements package.
---

# /architect — Architecture & Spec

Delegate to the **architect** agent:

> Design the architecture for `$ARGUMENTS`.
> 1. Read CLAUDE.md and docs/TRD.md.
> 2. Read the requirements package `docs/requirements/$ARGUMENTS/`.
> 3. Produce `docs/specs/$ARGUMENTS-spec.md` (phased plan, contracts, risks) and ADRs in
>    `docs/decisions/`.

If `$ARGUMENTS` is empty, ask which feature to design before delegating.
