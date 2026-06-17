---
name: plan
description: >
  Slash command: /plan. Delegates task breakdown to the senior-developer agent. Use when the
  user types "/plan [feature]" to decompose a spec into implementable tasks.
---

# /plan — Task Breakdown

Delegate to the **senior-developer** agent:

> Break down the spec for `$ARGUMENTS`.
> 1. Read CLAUDE.md and `docs/specs/$ARGUMENTS-spec.md`.
> 2. Produce atomic task files under `docs/tasks/$ARGUMENTS/NNN-*.md` per the task-format skill,
>    each with acceptance criteria, a Context Snapshot, dependencies, and verification.

If `$ARGUMENTS` is empty, ask which feature/spec to decompose before delegating.
