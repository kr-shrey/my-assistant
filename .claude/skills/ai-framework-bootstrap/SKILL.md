---
name: ai-framework-bootstrap
description: >
  Scaffold a multi-agent SDLC framework (analyst → architect → senior-developer →
  developer → tester pipeline; agents, skills, rules, hooks) into ANY project, working
  under both Claude Code and Gemini CLI. Two modes: NEW project (adapt the framework to a
  supplied Technical Requirement Document) and EXISTING project (deep-scan the codebase —
  resumable across sessions — synthesize a comprehensive TRD, then adapt the framework with
  conventions reverse-engineered from the real code). Use when the user says "bootstrap the
  framework", "scaffold the AI workflow", "set up the multi-agent SDLC", "adapt the framework
  to this project/codebase", or "make this repo Claude+Gemini ready".
---

# AI Framework Bootstrap — meta-skill

This skill **generates** a portable multi-agent SDLC framework into a target project. It does
not implement features. It produces the configuration files (agents, skills, rules, hooks,
context files) that make a project drive itself through the
`analyze → architect → plan → implement → test` pipeline, identically under **Claude Code**
and **Gemini CLI**.

You are the orchestrator. Read the reference docs as you go — do not hold the whole framework
in your head. Stop for human review at each marked checkpoint.

---

## Step 0 — Detect mode

Decide which mode you are in:

| Signal | Mode |
|---|---|
| User passed `new` and/or a path to a TRD / requirements doc | **NEW** |
| User passed `existing` | **EXISTING** |
| Target dir has source code but no TRD | **EXISTING** (confirm) |
| Target dir is empty or has only a TRD/spec | **NEW** (confirm) |
| Ambiguous | **ASK the user** which mode, and where the target project is |

Also establish, before doing anything else:

- **Target project root** — where the framework will be written (may differ from cwd).
- **Tech stack hint** — language(s)/framework(s), if the user stated them.
- **Tool scope** — default: Claude + Gemini native adapters + `AGENTS.md` universal bridge.

> **GIT_SAFETY — this skill never runs git.** It only writes files. It does not stage,
> commit, branch, or push in the target repo. Git is the user's. (The *generated* framework
> also enforces git-safety on every future agent — see `references/framework-blueprint.md`.)

---

## Step 1 — Branch to the mode workflow

### NEW project
Read **`references/new-project.md`** and follow it. In short:
1. Read the supplied TRD.
2. Extract stack, domain, architecture, test/build/lint/format commands, NFRs, glossary.
3. Choose the agent roster + convention skills appropriate to the stack.
4. Generate the framework from `templates/` (Step 2).

### EXISTING project
Read **`references/existing-project.md`** and follow it. In short:
1. Run the resumable deep scan per **`references/codebase-scan-protocol.md`** — this may span
   multiple sessions on a large repo. The scan ledger is the resumable spine; always resume
   from it, never restart.
2. Synthesize a comprehensive `docs/TRD.md` using **`references/trd-template.md`**.
3. **Reverse-engineer conventions from the observed code** — generated standards must match
   the existing style, not impose a new one.
4. **Checkpoint:** present the TRD for human review before generating anything.
5. Generate the framework from `templates/` (Step 2), using the produced TRD as input.

---

## Step 2 — Generate the framework

Read **`references/framework-blueprint.md`** (the full inventory + derivation rules),
**`references/placeholders.md`** (master variable schema), and
**`references/cross-tool-compat.md`** (how each file maps across Claude / Gemini / AGENTS.md).
Then emit, into the target root, the files described there by copying the matching
`templates/` skeleton and filling every `{{PLACEHOLDER}}` with project specifics:

- `CLAUDE.md`, `GEMINI.md`, `AGENTS.md`
- `.claude/agents/*.md`, `.claude/skills/<name>/SKILL.md`, `.claude/rules/*.md`,
  `.claude/settings.json`
- `.gemini/settings.json`, `.gemini/commands/*.toml`
- `docs/{requirements,specs,tasks,decisions,handoffs,sessions}/` skeleton + `docs/TRD.md`

Mandatory in every generated project (do not skip): the **GIT_SAFETY** rule, threaded through
`CLAUDE.md`, `.claude/rules/git-safety.md`, the `git-conventions` skill, the developer/tester
personas, `GEMINI.md`, the dev-capable `.gemini/commands/*.toml` preambles, and the
`.claude/settings.json` PreToolUse git gate.

Also mandatory, and equally non-conditional on stack/API:
1. `.claude/skills/skill-lifecycle-standards/SKILL.md` (continuous improvement, doc→code direction, code doc depth).
2. `.claude/skills/session-checkpoint/SKILL.md` (saving & resuming named session checkpoints via `/save-session` and `/resume-session` across token resets).
3. `.claude/skills/token-efficiency/SKILL.md` (graph-first context retrieval via `code-review-graph` / `codebase-memory-mcp`, instant `/query`, and caveman token-dense output).

Preload all three into **every** generated agent's `skills:` frontmatter (see `references/framework-blueprint.md` § Roster ↔ preloaded skills). Do not drop them to save tokens.

---

## Step 3 — Verify & hand off

Run the checks in `references/framework-blueprint.md` § Verification:

- Every `.claude/skills/*/SKILL.md` and `.claude/agents/*.md` has valid frontmatter.
- Every `GEMINI.md` `@import` target exists and is `.md`.
- Every `.gemini/commands/*.toml` has `prompt` + `description` and its referenced
  `.claude/...` file exists (no dangling pointers).
- GIT_SAFETY appears in all seven locations above; no generated persona instructs
  auto-commit or auto-branch.

Then print a **file manifest** (everything created/modified) and a short **review checklist**.
Do not commit. Tell the user the framework is ready and that git is theirs to run.

---

## Conventions for this skill

- **Read references on demand**, not all upfront. Each mode doc names the next file to read.
- **Genericize, don't hardcode.** Nothing here is Python-specific; derive stack details from
  the TRD/scan. The `{{STACK_*}}` placeholders carry that.
- **Checkpoints are real stops.** Surface the TRD (existing mode) and the file manifest
  (both modes) for human approval, mirroring the framework's own "human reviews between
  stages" principle.
