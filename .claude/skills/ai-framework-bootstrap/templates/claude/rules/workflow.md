---
description: Multi-agent SDLC pipeline and orchestration model for this project.
paths: ['**']
---

# Multi-Agent SDLC Workflow — {{PROJECT_NAME}}

The main session is the **orchestrator**. It delegates to subagents and facilitates human
review between stages. It does not implement features itself except for quick one-line fixes.

## Pipeline
```
/analyze → /architect → /plan → /implement → /test
```
Each stage produces artifacts that feed the next. **A human reviews and approves between every
stage.** Support commands run in the main session: `/status`, `/wrapup`.

## Roster
| Agent | Role | Command | Input → Output |
|---|---|---|---|
| analyst | requirements | `/analyze <domain>` | feature → `docs/requirements/<domain>/` |
| architect | design + ADRs | `/architect <feature>` | requirements → `docs/specs/<feature>-spec.md` + ADRs |
| senior-developer | task breakdown | `/plan <feature>` | spec → `docs/tasks/<feature>/NNN-*.md` |
| developer | implementation | `/implement <task>` | one task → code + tests, status `review` |
| tester | test + report | `/test <scope>` | suite → report; commit only on user approval |

## Artifact locations
`docs/requirements/` · `docs/specs/` · `docs/tasks/<domain>/` · `docs/decisions/` (ADRs) ·
`docs/handoffs/`. Code lives under the project's source root.

## Principles
- One task per `/implement`. Keep changes atomic and reviewable.
- Agents read; the main session orchestrates.
- Human reviews between every stage.
- **GIT_SAFETY** (see `git-safety.md`) — no commits/branches without approval.
- Run `/wrapup` at session end. Update `CLAUDE.md` after milestones.
- **Lifecycle standards** (see `skill-lifecycle-standards` skill, preloaded into every agent):
  propose new rules/limitations/skills as they're discovered instead of losing the insight;
  deliverables never reference docs, docs reference code; code comments explain logic/strategy/
  trade-offs where the choice isn't obvious, not just behavior.

## Cross-tool note
Under Gemini, "run the X subagent" / `/X` means: read `.claude/agents/X.md`, adopt that
persona, and follow it. See `AGENTS.md`.
