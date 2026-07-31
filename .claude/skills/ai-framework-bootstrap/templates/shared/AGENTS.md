# Agent Instructions — {{PROJECT_NAME}}

This project shares one AI agent setup across **Claude Code** and **Gemini CLI** (and, for
free, Cursor / Antigravity). One canonical source under `.claude/`; thin adapters elsewhere.

## Read first
1. **`CLAUDE.md`** — canonical project context. Always your first read at session start.
2. **`.claude/rules/workflow.md`** — the pipeline.
3. **`.claude/rules/git-safety.md`** — GIT_SAFETY (non-negotiable).

## Where things live
| What | Path | Read by |
|---|---|---|
| Project context | `CLAUDE.md` | Claude natively; Gemini via `GEMINI.md` `@import`; others here |
| Subagents (analyst, architect, senior-developer, developer, tester, …) | `.claude/agents/*.md` | Claude natively; Gemini/others adopt the persona on request |
| Preloaded skills (methodology, conventions) | `.claude/skills/<name>/SKILL.md` | all tools |
| Slash commands | `.claude/skills/<cmd>/SKILL.md` (Claude) · `.gemini/commands/<cmd>.toml` (Gemini) | their tool |
| Path-scoped rules | `.claude/rules/*.md` (`paths:`) | Claude & others |
| Hooks | `.claude/settings.json` | Claude auto; others run manually |

## Gemini CLI setup & instructions
Gemini ingests `GEMINI.md` (which `@import`s `CLAUDE.md`) and recognizes this `AGENTS.md`.
- **Role adoption:** asked to "run the architect subagent" / via `/architect`, Gemini MUST
  first read `.claude/agents/architect.md` and adopt that persona and steps (ignore its YAML
  frontmatter — Claude metadata).
- **Commands:** for `/analyze`, `/implement`, `/query`, `/save-session`, `/resume-session`, etc., read the matching
  `.gemini/commands/<cmd>.toml` (or the `.claude/skills/<cmd>/SKILL.md` it mirrors) and follow
  it.
- **Token Efficiency:** obey `.claude/skills/token-efficiency/SKILL.md` — use `code-review-graph` or `codebase-memory-mcp` before doing full scans.
- **Rules:** before editing files, scan `.claude/rules/` and obey any rule whose `paths:`
  match the targets — always including `git-safety.md`.
- **Hooks:** Gemini does not auto-run `.claude/settings.json` hooks. After editing code, run
  the formatter (`{{CMD_FORMAT}}`) manually; before any git action, obey GIT_SAFETY.

## GIT_SAFETY (applies to every tool)
Never commit, amend, push, or create branches without explicit user approval. Never assume git
intent. On any new dev request, propose a branch name and ASK before creating it. Never
auto-commit — present the diff and wait.

## Editing guidelines
- Update `CLAUDE.md` when project-wide context changes. `GEMINI.md` need not change (it
  imports `CLAUDE.md`).
- Skills, subagents, rules, and hooks under `.claude/` are single-source. The only Gemini
  duplicates are the thin `.gemini/commands/*.toml` wrappers — keep them aligned with the
  matching `.claude/skills/<cmd>/SKILL.md`.
