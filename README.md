# my-assistant — AI Framework Bootstrap

A reusable **meta-skill** that scaffolds a multi-agent SDLC framework into any project and
keeps it working identically under **Claude Code** and **Gemini CLI**.

It takes the `analyze → architect → plan → implement → test` pipeline — analyst, architect,
senior-developer, developer, and tester agents, plus their skills, rules, and hooks — and
turns it into a generator you can drop onto any repo, greenfield or brownfield.

## What it does

| Mode | Input | What happens |
|---|---|---|
| **New project** | A Technical Requirement Document (TRD) | Reads the TRD, derives the stack/domain/pipeline, and generates a framework tailored to it. |
| **Existing project** | A codebase (possibly huge) | Deep-scans the code — **resumable across sessions** — synthesizes a comprehensive TRD, then generates a framework whose conventions are **reverse-engineered from the real code**. |

## How it's built (cross-tool model)

Single source of truth lives in `.claude/`. Gemini gets thin adapters that point back at it,
and `AGENTS.md` is the universal bridge (so Cursor / Antigravity work for free too).

| Concern | Claude (canonical) | Gemini (thin adapter) |
|---|---|---|
| Project context | `CLAUDE.md` | `GEMINI.md` → `@import`s `CLAUDE.md` + workflow |
| Subagent personas | `.claude/agents/<role>.md` | `.gemini/commands/<role>.toml` → "read that file, adopt the persona" |
| Slash commands | `.claude/skills/<cmd>/SKILL.md` | `.gemini/commands/<cmd>.toml` |
| Conventions / rules | `.claude/skills/*`, `.claude/rules/*` | referenced from `GEMINI.md` |
| Hooks | `.claude/settings.json` | documented as manual steps |

Gemini has no native subagents, so personas are emulated by a command that reads the agent
file — the same trick `AGENTS.md` already uses for Antigravity.

## Git safety (non-negotiable in every generated project)

Every framework this skill produces enforces a hard rule: **the AI never assumes or
auto-commits anything, and asks before creating a branch on any new dev request.** It is
threaded through `CLAUDE.md`, `.claude/rules/git-safety.md`, the `git-conventions` skill, the
developer/tester personas, `GEMINI.md`, the Gemini command preambles, and a `PreToolUse` git
gate in `.claude/settings.json`.

## Usage

### Install (make the skill available)

- **This repo, directly:** the skill already lives at
  `.claude/skills/ai-framework-bootstrap/` — open Claude Code here and it's loaded.
- **Globally (all your projects):** symlink or copy it into `~/.claude/skills/`:
  ```bash
  ln -s "$(pwd)/.claude/skills/ai-framework-bootstrap" ~/.claude/skills/ai-framework-bootstrap
  ```

### Run

```
/ai-framework-bootstrap new path/to/TRD.md     # greenfield, from a TRD
/ai-framework-bootstrap existing               # brownfield, scan → TRD → framework
/ai-framework-bootstrap                         # auto-detect, will ask if unsure
```

In Gemini CLI, ask it to "read `.claude/skills/ai-framework-bootstrap/SKILL.md` and follow
it" (Gemini reads skill files on request; this repo can also expose it as a Gemini command).

## Layout

```
.claude/skills/ai-framework-bootstrap/
  SKILL.md                 # router: detect mode, orchestrate, verify
  references/              # the methodology (read on demand)
    new-project.md
    existing-project.md
    codebase-scan-protocol.md
    trd-template.md
    framework-blueprint.md
    placeholders.md        # master dictionary of template placeholders
    cross-tool-compat.md
  templates/              # skeletons the skill copies + fills per project
    shared/   claude/   gemini/
```

## Core Features

- **100% Zero-Dependency & Language-Agnostic**: Pure markdown meta-skill runnable in any AI environment (Claude, Gemini, Antigravity, Cursor) without host runtime dependencies.
- **Resumable Codebase Scanning**: Built-in scan ledger to map large brownfield repositories across sessions.
- **Named Session Checkpointing (`/save-session`, `/resume-session`)**: Save active pipeline context into `docs/sessions/<name>.md` to resume cleanly across token resets or multi-session workflows.
- **Defense-in-Depth Git Safety**: 7-point verification and bash pre-tool hook gate preventing automated commits, pushes, or branching.

## Status

The framework this skill emits is **proposed configuration only** — it never writes source
code or runs git. You review the generated files and drive the pipeline yourself.
