---
name: status
description: >
  Slash command: /status. Scans task files in docs/tasks/ and prints a dashboard of task
  states (todo / in-progress / review / done) and the suggested next task. Runs in the main
  session — no delegation.
disable-model-invocation: true
---

# /status — Task Dashboard

Do NOT delegate. Execute directly.

1. Glob `docs/tasks/**/*.md`. Read each file's frontmatter (status, priority, depends-on).
2. Group by status. Within `todo`, surface tasks whose dependencies are all `done`, ordered
   by priority (P0 → P2).
3. Print a compact table: task ID, title, status, priority, blocked-by (if any).
4. Recommend the next task to pick up (`/implement <task>`).
