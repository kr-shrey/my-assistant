# my-assistant — AI Framework Bootstrap

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

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
| **Upgrade project** | An existing scaffolded repo | Upgrades framework infrastructure to the latest templates (skills, model routing, git hook gates) **without clobbering custom project rules or `CLAUDE.md` context**. |

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

## Git safety (non-negotiable in every generated project)

Every framework this skill produces enforces a hard rule: **the AI never assumes or
auto-commits anything, and asks before creating a branch on any new dev request.** It is
threaded through `CLAUDE.md`, `.claude/rules/git-safety.md`, the `git-conventions` skill, the
developer/tester personas, `GEMINI.md`, the Gemini command preambles, and a `PreToolUse` git
gate in `.claude/settings.json`.

## Installation

### Automated Shell Installer (`install.sh`)

Install globally for all your projects using `install.sh`:

```bash
# Option 1: Symlink mode (recommended — auto-updates when you git pull this repo)
./install.sh --symlink

# Option 2: Copy mode (standalone copy into ~/.claude/skills/)
./install.sh --copy

# Option 3: Remote install via curl
curl -sSL https://raw.githubusercontent.com/krshrey/my-assistant/main/install.sh | sh
```

## Usage

```bash
/ai-framework-bootstrap new path/to/TRD.md     # greenfield, from a TRD
/ai-framework-bootstrap existing               # brownfield, scan → TRD → framework
/ai-framework-bootstrap upgrade                # upgrade existing project to latest framework version
/ai-framework-bootstrap                         # auto-detect, will ask if unsure
```

In Gemini CLI, ask it to "read `.claude/skills/ai-framework-bootstrap/SKILL.md` and follow
it" (Gemini reads skill files on request; this repo also exposes matching `.toml` command wrappers).

## Layout

```
.claude/skills/ai-framework-bootstrap/
  SKILL.md                 # router: detect mode (new/existing/upgrade), orchestrate, verify
  references/              # the methodology (read on demand)
    new-project.md
    existing-project.md
    codebase-scan-protocol.md
    trd-template.md
    framework-blueprint.md
    placeholders.md        # master dictionary of template placeholders
    upgrade-protocol.md    # migration guide for upgrading scaffolded repos
    cross-tool-compat.md
  templates/              # skeletons the skill copies + fills per project
    shared/   claude/   gemini/
```

## Core Features

- **100% Zero-Dependency & Language-Agnostic**: Pure markdown meta-skill runnable in any AI environment (Claude, Gemini, Antigravity, Cursor) without host runtime dependencies.
- **Resumable Codebase Scanning**: Built-in scan ledger to map large brownfield repositories across sessions.
- **Named Session Checkpointing (`/save-session`, `/resume-session`)**: Save active pipeline context into `docs/sessions/<name>.md` to resume cleanly across token resets or multi-session workflows.
- **Instant Graph Q&A (`/query`)**: Graph-first symbol and dependency resolution via `code-review-graph` and `codebase-memory-mcp` without full directory scans.
- **Dual-Tool Model Routing**: Explicit model tiering (Opus/Pro for reasoning, Sonnet/Thinking for execution, Haiku/Flash for status & Q&A).
- **Defense-in-Depth Git Safety**: 7-point verification and bash pre-tool hook gate preventing automated commits, pushes, or branching.

## License

Distributed under the **MIT License**. See [LICENSE](LICENSE) for details.
