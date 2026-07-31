# Framework blueprint — the full inventory of generated files + derivation rules

This is the spec the generator targets. For each file: where it goes, its role, which template
backs it, and how to fill it. "What good output looks like."

## Generated tree (in the target project root)

```
CLAUDE.md                         # canonical project context (Claude reads natively)
GEMINI.md                         # thin: @imports CLAUDE.md + workflow (Gemini reads natively)
AGENTS.md                         # universal bridge (Gemini/Cursor/Antigravity instructions)

.claude/
  agents/
    analyst.md  architect.md  senior-developer.md  developer.md  tester.md
    (optional) auditor.md  status-reader.md
  skills/
    analyze/SKILL.md  architect/SKILL.md  plan/SKILL.md  implement/SKILL.md  test/SKILL.md
    status/SKILL.md   wrapup/SKILL.md     save-session/SKILL.md  resume-session/SKILL.md
    git-conventions/SKILL.md      # opens with GIT_SAFETY
    <stack>-conventions/SKILL.md  # e.g. python-conventions, ts-conventions (multiple if polyglot)
    task-format/SKILL.md  test-strategy/SKILL.md  (api-conventions/SKILL.md if API)
    skill-lifecycle-standards/SKILL.md  # always generated, not stack-dependent
    session-checkpoint/SKILL.md        # session state saving & resumption across token resets
  rules/
    git-safety.md                 # GIT_SAFETY, paths: '**'
    workflow.md                   # pipeline summary, paths: '**'
  settings.json                   # hooks: PostToolUse formatter, PreToolUse git gate + test gate

.gemini/
  settings.json                   # context.fileName: ["GEMINI.md", "AGENTS.md"]
  commands/
    analyze.toml  architect.toml  plan.toml  implement.toml  test.toml  status.toml  wrapup.toml
    save-session.toml  resume-session.toml

docs/
  TRD.md
  requirements/README.md  specs/README.md  tasks/README.md  decisions/README.md  handoffs/README.md
  sessions/README.md
```

## Derivation rules (how stack details flow in)

| Decision | Source | Rule |
|---|---|---|
| Which `*-conventions` skill | TRD §3 / observed config | one per primary language; fall back to generic `coding-standards` |
| Formatter hook command | TRD §8 `{{CMD_FORMAT}}` | PostToolUse on Edit\|Write, matched by file extension |
| Lint/typecheck in tester | TRD §8 | tester runs these before tests |
| Test command + split | TRD §8 | developer/tester verify steps |
| Agent `model:` | complexity | analyst/architect → opus; developer/tester → sonnet; status-reader → haiku |
| Agent `skills:` frontmatter | roster ↔ skills map below | only preload what the role needs |
| API skill present? | TRD §2/§6 | include `api-conventions` only if the system exposes/consumes APIs |
| ADR topics | TRD §4/§7 | architect seeds `docs/decisions/` from these |

### Roster ↔ preloaded skills
| Agent | model | skills |
|---|---|---|
| analyst | opus | functional-requirements, non-functional-requirements, requirement-traceability, skill-lifecycle-standards, session-checkpoint |
| architect | opus | technical-spec, api-conventions (if API), adr-writing, skill-lifecycle-standards, session-checkpoint |
| senior-developer | sonnet | task-breakdown, task-format, skill-lifecycle-standards, session-checkpoint |
| developer | sonnet | task-format, `<stack>-conventions`, api-conventions (if API), git-conventions, skill-lifecycle-standards, session-checkpoint |
| tester | sonnet | test-strategy, git-conventions, skill-lifecycle-standards, session-checkpoint |

(If a listed skill isn't being generated for this project, drop it from the frontmatter — no
dangling skill references. `skill-lifecycle-standards` and `session-checkpoint` are universal exceptions: they are never stack- or API-conditional, so every agent always gets them.)

## Filling rules

- Replace every `{{PLACEHOLDER}}` from the project profile (new) / TRD (existing). Leave none.
- **Genericize the persona bodies** from `templates/claude/agents/*`: swap any Python-specific
  phrasing for the project's stack. Keep the step structure (Orient → work → verify → report)
  and the token-budget discipline.
- The slash-command skills are thin delegators — each just hands its `$ARGUMENTS` to the named
  agent. Keep them short.
- Keep `CLAUDE.md` as the *only* place full context lives; `GEMINI.md` and `AGENTS.md` point
  to it, they don't duplicate it.

## GIT_SAFETY — mandatory, seven locations

The rule (canonical wording, keep it verbatim across files):

> **GIT_SAFETY.** Never commit, amend, push, or create branches without explicit user
> approval. Never assume git intent. On any new development request, propose a branch name
> (per git-conventions) and ASK before creating it. Never auto-commit — present the diff and
> wait for the user to say go.

Emit it into all of:
1. `CLAUDE.md` — "Non-negotiable rules" block (top, impossible to miss).
2. `.claude/rules/git-safety.md` — full rule, `paths: '**'`.
3. `.claude/skills/git-conventions/SKILL.md` — first section, before commit/branch format.
4. `.claude/agents/developer.md` — Behavioral Rules.
5. `.claude/agents/tester.md` — replaces any "commit on green" step with "report green +
   **propose** commit, then wait for approval."
6. `GEMINI.md` — imports the rule + restates it inline.
7. Each dev-capable `.gemini/commands/*.toml` (`implement`, `test`) — one-line preamble.

Plus the **hook backstop** in `.claude/settings.json`: a `PreToolUse` Bash gate that blocks
`git commit` / `git push` / `git checkout -b` / `git branch` / `git merge` / `--no-verify`
unless an approval marker is present. Defense-in-depth, not a replacement for the behavioral
rule (Gemini won't run it).

## Verification (run before handing off)
1. Frontmatter parses on every `.claude/agents/*.md` and `.claude/skills/*/SKILL.md`.
2. Every `GEMINI.md` `@import` path exists and ends in `.md`.
3. Every `.gemini/commands/*.toml` has `prompt` + `description`; every `.claude/...` path it
   references exists (no dangling pointers).
4. Every `skills:` entry in an agent file corresponds to a generated skill dir.
5. GIT_SAFETY present in all seven locations; no persona instructs auto-commit/auto-branch.
6. `.claude/settings.json` is valid JSON; `.gemini/settings.json` is valid JSON; each `.toml`
   parses.
7. Print the manifest.
