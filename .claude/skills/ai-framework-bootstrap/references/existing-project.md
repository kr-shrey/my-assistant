# EXISTING project workflow — scan → TRD → framework

Brownfield. There is real code, possibly a large codebase with external references, and no
(or an outdated) TRD. Goal: understand the project deeply, write the TRD for it, then emit a
framework whose conventions **match the code that already exists**.

This is the harder mode. It may take **multiple sessions**. Resumability is mandatory.

## 1. Deep scan (resumable)

Follow **`codebase-scan-protocol.md`** exactly. Its scan ledger
(`docs/ai-bootstrap/scan-progress.md`) is the resumable spine:

- On a fresh session, **read the ledger first**. Resume from the first `pending` area. Never
  restart a scan that is partly done.
- Fan out with **Explore subagents** per area (read-only; they return conclusions, not file
  dumps) when the repo is large.
- After each area, append findings to `docs/ai-bootstrap/findings/<area>.md` and flip the
  ledger row to `scanned`.
- At session end, write a handoff note (see protocol) so the next session continues cleanly.

Do not proceed to §2 until the ledger shows every area `scanned` (or the user accepts a
partial scope and you record what was skipped).

## 2. Synthesize the TRD

Using `trd-template.md`, write `docs/TRD.md` from the accumulated findings. It must capture
what is *actually true* of the system:

- real tech stack and versions (from manifests/lockfiles),
- module map and how the pieces talk,
- data models and external integrations/references,
- **conventions as observed** (naming, error handling, logging, test layout, commit style
  from git history) — quote representative examples,
- build/test/lint/deploy commands that actually exist,
- NFRs evident from the code (timeouts, retries, caching, security controls),
- a domain glossary built from the code's own vocabulary,
- an Open Questions section for anything the code couldn't answer.

Mark inferences explicitly vs. confirmed facts.

## 3. Reverse-engineer conventions (critical)

The generated convention skills must **describe the existing style, not impose a new one.**
Examples:
- If the code uses 4-space indent, tabs in tests, a custom logger wrapper, a specific error
  base class, or a particular layering — encode *that*.
- Derive the formatter/linter from config files actually present (`ruff.toml`,
  `.eslintrc`, `.golangci.yml`, `pyproject`, `package.json` scripts, Makefile targets).
- Derive the commit/branch style from `git log` — but the generated `git-conventions` skill
  still opens with **GIT_SAFETY** regardless of what history shows.

If the existing style is inconsistent, note the inconsistency in the TRD and pick the
dominant pattern; flag it for the user rather than silently choosing.

## 4. Checkpoint — TRD review

**Stop.** Present `docs/TRD.md` and the convention findings to the user for approval before
generating any framework files. This mirrors the framework's "human reviews between stages"
rule and is the cheapest place to correct a misread of the codebase.

## 5. Generate

Once the TRD is approved, run the same generation path as new projects — hand off to
`framework-blueprint.md` + `cross-tool-compat.md` (SKILL.md Step 2), filling placeholders from
the TRD and the observed conventions from §3.

Two brownfield-specific cautions:
- **Do not clobber existing config.** If the repo already has `CLAUDE.md`, a `.claude/`,
  `.gemini/`, or `AGENTS.md`, diff against them and propose a merge — never overwrite without
  showing the user what changes.
- **Respect existing hooks/CI.** Wire the generated hooks to the project's real commands; do
  not introduce a formatter the project doesn't use.

## 6. Manifest & handoff

Print the file manifest + review checklist. **Do not commit.** Point the user at the next
pipeline step and remind them git is theirs.
