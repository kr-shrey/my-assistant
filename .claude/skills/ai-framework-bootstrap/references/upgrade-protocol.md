# Framework Upgrade Protocol — `/ai-framework-bootstrap upgrade`

This protocol specifies how `ai-framework-bootstrap` upgrades a project that was scaffolded with an earlier version of the framework.

---

## Non-Negotiable Rule for Upgrades

> **NEVER CLOBBER PROJECT-SPECIFIC CONTEXT OR CUSTOM CODE.**
> Upgrading updates the **meta-framework infrastructure** (skills, rules, command TOMLs, hooks).
> It MUST preserve project-specific sections in `CLAUDE.md` (Tech stack, Architecture, Glossary), existing ADRs, requirements, specs, tasks, and custom rules added by the team.

---

## Upgrade Workflow

### Step 1 — Detect existing framework version & delta
Read target project root:
- Read `CLAUDE.md`, `.claude/settings.json`, and `.gemini/settings.json`.
- List installed skills in `.claude/skills/` and commands in `.gemini/commands/`.
- Identify missing universal skills or outdated command templates against the latest `templates/` tree.

### Step 2 — Sync Universal Skills
Ensure all non-stack-dependent universal skills exist in `.claude/skills/`:
- `skill-lifecycle-standards/SKILL.md` (Continuous improvement, doc→code reference direction)
- `session-checkpoint/SKILL.md` (Session checkpointing via `/save-session` and `/resume-session`)
- `token-efficiency/SKILL.md` (Graph-first retrieval via `code-review-graph`/`codebase-memory-mcp`, instant `/query`, caveman output)
- `git-conventions/SKILL.md` (Enforcing GIT_SAFETY)

Preload missing universal skills into all agent personas in `.claude/agents/*.md`.

### Step 3 — Sync Gemini Commands & Model Routing
- Copy missing `.gemini/commands/*.toml` templates (`query.toml`, `save-session.toml`, `resume-session.toml`).
- Update existing `.gemini/commands/*.toml` files to include model directives (`model = "gemini-1.5-pro"` for Tier 1/2 reasoning, `model = "gemini-1.5-flash"` for Tier 3 fast lookups).

### Step 4 — Harden Security & Settings Hooks
- Update `.claude/settings.json` `PreToolUse` bash hook regex to the hardened pattern:
  `grep -qiE '(^|[[:space:]|;&])git([[:space:]]+-[^[:space:]]+)*[[:space:]]+(commit|push|merge|branch|checkout[[:space:]]+-b|tag)...'`
- Clean `.gemini/settings.json` `context.fileName` array to `["GEMINI.md", "AGENTS.md"]` (removing redundant `CLAUDE.md`).

### Step 5 — Update Root Context Files (`CLAUDE.md`, `GEMINI.md`, `AGENTS.md`)
- Update support commands list to include `/query`, `/save-session`, `/resume-session`.
- Document Token Efficiency & AI Readiness section in `CLAUDE.md` and `AGENTS.md`.
- Preserve all existing project-specific fields (`{{PROJECT_PURPOSE}}`, `{{STACK_*}}`, `{{GLOSSARY}}`).

### Step 6 — Manifest & Human Approval
- Present a detailed diff manifest showing added skills, updated commands, and settings edits.
- Ask the user to review the upgrades before completing the session.
