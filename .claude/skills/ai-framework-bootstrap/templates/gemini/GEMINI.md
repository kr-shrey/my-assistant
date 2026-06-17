# {{PROJECT_NAME}} — Gemini context

This project's canonical context lives in `CLAUDE.md` and `.claude/`. Read these first:

@./CLAUDE.md
@./.claude/rules/workflow.md
@./.claude/rules/git-safety.md

## How to work here
- **Slash commands** are in `.gemini/commands/` (`analyze`, `architect`, `plan`, `implement`,
  `test`, `status`, `wrapup`). Each mirrors the matching `.claude/skills/<cmd>/SKILL.md`.
- **Subagents are emulated.** When a command (or the user) asks you to run a role, read
  `.claude/agents/<role>.md`, adopt that persona and its workflow, then act. Ignore the YAML
  frontmatter in those files — it's Claude metadata.
- **Before editing files**, scan `.claude/rules/` and obey any rule whose `paths:` match the
  target — always including `git-safety.md`.
- **Before writing code**, read the relevant `.claude/skills/<name>/SKILL.md` — conventions
  (`{{STACK_CONVENTIONS_SKILL}}`, `git-conventions`, `test-strategy`, `task-format`) live there.
- **Hooks** in `.claude/settings.json` do not run under Gemini. After editing code, run the
  formatter manually (`{{CMD_FORMAT}}`). Before any git action, obey GIT_SAFETY.

## GIT_SAFETY (non-negotiable)
Never commit, amend, push, or create branches without explicit user approval. Never assume git
intent. On any new development request, propose a branch name (per `git-conventions`) and ASK
before creating it. Never auto-commit — present the diff and wait for the user to say go.
