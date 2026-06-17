---
name: test
description: >
  Slash command: /test. Delegates test execution to the tester agent. Use when the user types
  "/test [scope]" to run tests and produce a report.
---

# /test — Test Execution

Delegate to the **tester** agent:

> Run tests for scope `$ARGUMENTS` (empty = most recent `status: review` task).
> 1. Read CLAUDE.md for the lint/typecheck/test commands.
> 2. Run static checks, then tests; analyze failures; produce a structured report.
> GIT_SAFETY: if green, PROPOSE a commit (show the diff + draft message) and wait for the
> user's approval — never auto-commit.
