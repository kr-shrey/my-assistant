---
name: implement
description: >
  Slash command: /implement. Delegates task implementation to the developer agent. Use when the
  user types "/implement [task-id-or-path]" to implement a single task.
---

# /implement — Task Implementation

Delegate to the **developer** agent:

> Implement the task `$ARGUMENTS`.
> 1. Read CLAUDE.md (if not already this session) and the task file.
> 2. Verify dependencies are `done`. Implement code + tests for this one task only.
> 3. Verify, set status to `review`, fill Implementation Notes, return a short summary.
> GIT_SAFETY: do not commit or branch — stop at `review` and report.

If `$ARGUMENTS` is empty, run `/status` to find the next `todo` task, then delegate that one.
