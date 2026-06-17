# Cross-tool compatibility — Claude ↔ Gemini ↔ AGENTS.md

How the generated framework stays identical across tools. Canonical content lives once in
`.claude/` + `CLAUDE.md`; everything else points back at it.

## The mapping

| Concern | Claude (canonical) | Gemini (thin adapter) | Bridge |
|---|---|---|---|
| Project context | `CLAUDE.md` | `GEMINI.md` → `@./CLAUDE.md`, `@./.claude/rules/workflow.md`, `@./.claude/rules/git-safety.md` | `AGENTS.md` |
| Subagent persona | `.claude/agents/<role>.md` | `.gemini/commands/<role>.toml` `prompt` = "read that file, adopt persona, then act on {{args}}" | `AGENTS.md` "Role Adoption" |
| Slash command | `.claude/skills/<cmd>/SKILL.md` | `.gemini/commands/<cmd>.toml` mirroring the SKILL body, `$ARGUMENTS`→`{{args}}` | `AGENTS.md` |
| Convention/knowledge skill | `.claude/skills/<name>/SKILL.md` | referenced from `GEMINI.md` ("read the relevant skill before coding") | `AGENTS.md` |
| Path-scoped rules | `.claude/rules/*.md` (`paths:`) | `GEMINI.md` tells Gemini to scan `.claude/rules/` before editing | `AGENTS.md` |
| Hooks | `.claude/settings.json` | **not auto-run by Gemini** — listed in `AGENTS.md` as manual steps | `AGENTS.md` "Hooks" |

## Gemini facts that constrain the design (verified against Gemini CLI docs)

- **Context file:** `GEMINI.md` (default; settable via `context.fileName` in
  `.gemini/settings.json`). Supports `@path/to/file.md` imports, relative or absolute.
  **Imports must be `.md` files.** Loading is hierarchical and concatenated.
- **Custom commands:** TOML files in `.gemini/commands/` (project) or `~/.gemini/commands/`
  (user). Keys: **`prompt`** (required), **`description`** (shown in `/help`).
  `{{args}}` injects user arguments; `!{...}` injects shell output. Subdirectories namespace
  the command: `.gemini/commands/git/commit.toml` → `/git:commit`.
- **No native subagents.** Emulate a subagent by a command whose `prompt` instructs Gemini to
  read the persona file in `.claude/agents/` and adopt it — exactly the Antigravity pattern.
- Gemini tooling also recognizes `AGENTS.md`, so the bridge file does double duty.

## Generation patterns (copy these shapes)

### GEMINI.md (thin)
```markdown
# {{PROJECT_NAME}} — Gemini context

This project's canonical context lives in CLAUDE.md and .claude/. Read these first:

@./CLAUDE.md
@./.claude/rules/workflow.md
@./.claude/rules/git-safety.md

## How to work here
- Slash commands: see .gemini/commands/ (analyze, architect, plan, implement, test, status, wrapup).
- Subagents are emulated: a command will ask you to read .claude/agents/<role>.md and adopt that persona.
- Before editing files, scan .claude/rules/ and obey any rule whose paths match the target.
- Before writing code, read the relevant .claude/skills/<name>/SKILL.md (conventions live there).

## GIT_SAFETY (non-negotiable)
Never commit, amend, push, or create branches without explicit user approval. Never assume git
intent. On any new development request, propose a branch name and ASK before creating it.
Never auto-commit — present the diff and wait.
```

### A subagent-emulating command — `.gemini/commands/implement.toml`
```toml
description = "Implement a task (developer persona). Usage: /implement <task-id-or-path>"
prompt = """
GIT_SAFETY: never auto-commit and never create a branch without asking first.

You are running the 'developer' subagent. First read `.claude/agents/developer.md` and adopt
that persona and its workflow exactly (ignore its YAML frontmatter — it's Claude metadata).
Also read CLAUDE.md for project context if you haven't this session.

Then implement the task: {{args}}
Follow the persona's steps: read the task file, implement, write tests, verify, update status
to 'review'. Do NOT commit — report the diff and stop.
"""
```

### A thin slash-command command — `.gemini/commands/analyze.toml`
```toml
description = "Analyze requirements (analyst persona). Usage: /analyze <domain>"
prompt = """
You are running the 'analyst' subagent. Read `.claude/agents/analyst.md`, adopt that persona,
and read CLAUDE.md for context. Then analyze requirements for: {{args}}
Produce the requirements package under docs/requirements/{{args}}/ as the persona specifies.
"""
```

### .gemini/settings.json
```json
{
  "context": { "fileName": ["GEMINI.md", "CLAUDE.md", "AGENTS.md"] }
}
```
(Listing CLAUDE.md and AGENTS.md as context filenames is belt-and-suspenders alongside the
`@import`s — Gemini concatenates all matched context files.)

## Rules
- **One source of truth.** Never duplicate persona/convention bodies into Gemini files — point
  to the `.claude/` originals. The only Gemini-native content is the thin command wrappers and
  the GEMINI.md pointer.
- **No dangling pointers.** Every `.claude/...` path named in a `.toml` or in `GEMINI.md` must
  exist. Verify before handing off.
- **GIT_SAFETY rides in the prompt for Gemini.** Hooks don't run there, so the dev-capable
  commands restate the rule inline.
