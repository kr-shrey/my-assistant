---
name: skill-lifecycle-standards
description: >
  Mandatory lifecycle standards for every agent in this project: (1) continuous-improvement
  checkpoints — propose new rules/limitations/skills as they're discovered, (2) doc↔code
  reference direction — deliverables never point at docs, docs point at code, (3) code
  documentation depth — explain logic, strategy, alternatives, and trade-offs, not just
  behavior. Always preloaded; not stack-specific.
---

# Skill Lifecycle Standards — {{PROJECT_NAME}}

This skill applies to every agent in the pipeline, regardless of role. It is generated once
per project and never dropped, unlike stack-specific skills.

## 1. Continuous improvement

At the end of any non-trivial unit of work (a completed task, a finished spec, a test run with
a surprising failure), pause and ask the human: **does anything just learned belong in the
project's standing knowledge?** Concretely, ask about:

- **A new rule** — something that should apply on every future run (`.claude/rules/`).
- **A new limitation** — a constraint or gotcha future agents must not rediscover the hard way
  (record in the relevant skill or in `CLAUDE.md`).
- **A new skill** — a convention or procedure that recurred, or would help a future agent do
  this job without re-deriving it.

Do not silently apply the change. Propose it, name where it would live (rule vs. skill vs.
`CLAUDE.md` — see the Context Visibility Model in `workflow.md`), and wait for approval before
writing it. This is a proposal step, not an extra deliverable — skip it for trivial or
one-off work.

## 2. Doc↔code reference direction

**Deliverables (code, config, generated artifacts) never embed references to documentation.**
No `// see docs/specs/x.md`, no docstring paths to ADRs, no comments pointing at task files.
Reasons: doc paths in code rot the moment a doc moves, and they leak process structure into
the artifact that has to outlive the process.

**Documentation points at code, not the other way around.** Once a task is implemented, the
*doc* gets updated with a pointer to where it landed:

- The spec (`docs/specs/<feature>-spec.md`) gets an "Implemented in" note listing the
  module/file the phase landed in.
- The task file's **Implementation Notes** section (see `task-format` skill) records the exact
  files/functions touched — this is the durable doc→code link, not a comment in the source.
- ADRs reference the decision's rationale, not specific line numbers (those move; the decision
  doesn't).

**Two-way mapping stays fresh only if it's re-checked on change, not written once and
forgotten.** Whenever a task modifies code that an existing doc already points to:
1. The developer checks whether the doc's pointer (file/module named in Implementation Notes
   or spec) still matches reality.
2. If code moved, was renamed, or was removed, the developer updates the doc pointer as part
   of the same change — not as separate cleanup debt.
3. If the mapping is unclear or spans multiple docs, flag it in the task's Implementation Notes
   for human review rather than guessing.

If this manual re-check starts missing drift across a project (docs pointing at code that no
longer exists), that's a signal for the continuous-improvement step above: propose a dedicated
doc-sync skill or a `PostToolUse` check rather than continuing to rely on memory.

## 3. Code documentation depth

Where a file/function/module warrants a comment or docstring at all, it should explain more
than *what* the code does (naming should already cover that). Prefer to capture, briefly:

- **The logic** — the non-obvious part of *how* it works, if it isn't a straight read of the
  code.
- **The reasoning behind the chosen strategy** — why this approach, not a rewrite of the
  approach itself.
- **Alternatives considered and their trade-offs** — one line is enough: "chose X over Y
  because Z"; skip this when there was no real alternative.

Do not add this kind of comment everywhere — only where the choice isn't obvious from reading
the code once. A one-line helper doesn't need a trade-offs essay; a retry strategy, a caching
choice, or a non-default algorithm does. This is the same "why not what" bar the
`<stack>-conventions` skill's Docstrings/comments section states for this project's language —
this section adds the strategy/trade-off expectation on top of it.
