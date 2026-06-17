# Tasks

Atomic, implementable task files: `docs/tasks/<domain>/001-*.md`, `002-*.md`, …
Each carries YAML frontmatter (status, priority, depends-on, …) per the `task-format` skill.

Produced by the **senior-developer** (`/plan <feature>`). Implemented one at a time by the
**developer** (`/implement <task-path>`), then validated by the **tester** (`/test <scope>`).
