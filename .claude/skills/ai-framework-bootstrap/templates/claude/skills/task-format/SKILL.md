---
name: task-format
description: >
  Canonical schema for task files in docs/tasks/<domain>/. Use when reading, creating, or
  updating task frontmatter and body.
---

# Task File Format — {{PROJECT_NAME}}

Task files live at `docs/tasks/<domain>/NNN-<slug>.md`.

## Frontmatter
```yaml
status: todo            # todo | in-progress | review | done
priority: P1            # P0 (critical) | P1 (high) | P2 (normal)
depends-on: []          # task filenames this blocks on
assigned-agent: developer
complexity: M           # S | M | L
created: YYYY-MM-DD
updated: YYYY-MM-DD
```

## Body
1. **Title** + spec reference (`docs/specs/<feature>-spec.md`).
2. **Description** — what to build, scoped to one session.
3. **Acceptance Criteria** — numbered, each independently testable.
4. **Context Snapshot** — patterns, interfaces, file paths, spec excerpts the developer needs
   so they don't re-explore. (senior-developer fills this.)
5. **Technical Notes** — hints, gotchas.
6. **Verification** — exact commands to confirm done.
7. **Implementation Notes** — filled by the developer at completion (files, decisions, issues).

## Status lifecycle
`todo` → (developer) `in-progress` → `review` → (tester + human-approved commit) `done`.
The developer sets `review`, never `done`. GIT_SAFETY governs the commit that precedes `done`.
