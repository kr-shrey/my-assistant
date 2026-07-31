# {{PROJECT_NAME}}

> Canonical project context. Claude Code reads this natively; `GEMINI.md` `@import`s it; other
> tools read it via `AGENTS.md`. Keep this the single source of truth — adapters point here.

{{PROJECT_PURPOSE}}

## Non-negotiable rules

> **GIT_SAFETY.** Never commit, amend, push, or create branches without explicit user
> approval. Never assume git intent. On any new development request, propose a branch name
> (per the `git-conventions` skill) and ASK before creating it. Never auto-commit — present
> the diff and wait for the user to say go. See `.claude/rules/git-safety.md`.

- {{OTHER_NON_NEGOTIABLES}}  <!-- e.g. security/PII rules, data invariants from TRD §7/§9 -->

## Tech stack

- **Language(s):** {{STACK_LANGUAGE}}
- **Framework / runtime:** {{STACK_FRAMEWORK}}
- **Datastore / messaging:** {{STACK_DATA}}
- **Tooling:** build `{{CMD_BUILD}}` · test `{{CMD_TEST}}` · lint `{{CMD_LINT}}` ·
  format `{{CMD_FORMAT}}` · typecheck `{{CMD_TYPECHECK}}`

## Architecture

- **Style:** {{ARCH_STYLE}}
- **Module map:** {{MODULE_MAP}}
- **Entry points:** {{ENTRY_POINTS}}

Full detail in `docs/TRD.md`. Architecture decisions are recorded as ADRs in `docs/decisions/`.

## Multi-agent SDLC workflow

This project is driven by a five-stage pipeline. Full description in
`.claude/rules/workflow.md`.

```
/analyze → /architect → /plan → /implement → /test
```

Main session orchestrates; each stage is a subagent; **a human reviews and approves between
every stage.** Support commands: `/status`, `/wrapup`, `/query`, `/save-session`, `/resume-session`.

## Token Efficiency & AI Readiness

- **Graph-First Context Retrieval**: Use `code-review-graph` or `codebase-memory-mcp` per `.claude/skills/token-efficiency/SKILL.md` before doing full file scans.
- **Model Routing Strategy**: Tasks are routed by model tiers:
  - **Tier 1 (High Reasoning / Opus & Gemini Pro)**: `/analyze`, `/architect`, `/plan`
  - **Tier 2 (Execution / Sonnet & Gemini Pro/Thinking)**: `/implement`, `/test`
  - **Tier 3 (Fast Lookups / Haiku & Gemini Flash)**: `/query`, `/status`, `/wrapup`, `/save-session`, `/resume-session`

## Requirements Documentation

- Requirements live in `docs/requirements/<domain>/` — one self-contained package per domain
  (`clarification.md`, `functional-reqs.md`, `nonfunctional-reqs.md`, `traceability.md`).
- Specs in `docs/specs/`, tasks in `docs/tasks/<domain>/`, ADRs in `docs/decisions/`,
  session handoffs in `docs/handoffs/`, named session checkpoints in `docs/sessions/`.

## Domain glossary

{{GLOSSARY}}

## Verification checklist (before any change is considered done)

1. `{{CMD_LINT}}` and `{{CMD_TYPECHECK}}` pass.
2. `{{CMD_TEST}}` passes for affected modules.
3. The change matches the conventions in `.claude/skills/{{STACK_CONVENTIONS_SKILL}}/SKILL.md`.
4. GIT_SAFETY respected — no commit/branch without approval.
