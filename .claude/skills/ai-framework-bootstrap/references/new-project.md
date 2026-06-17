# NEW project workflow — adapt the framework to a supplied TRD

Greenfield. You have a Technical Requirement Document (TRD) and an empty (or near-empty)
target repo. Goal: emit a complete, stack-appropriate framework.

## 1. Read the TRD

Read the supplied document in full. It may follow `trd-template.md` or be free-form. If it is
thin or ambiguous on any of the extraction fields below, **ask the user** rather than guessing
— a wrong stack guess poisons every generated file.

## 2. Extract the project profile

Pull these into a short working profile (you will feed it into every `{{PLACEHOLDER}}`):

| Field | Placeholder | Notes |
|---|---|---|
| Project name / one-line purpose | `{{PROJECT_NAME}}`, `{{PROJECT_PURPOSE}}` | |
| Primary language(s) | `{{STACK_LANGUAGE}}` | drives convention-skill choice |
| Frameworks / runtime | `{{STACK_FRAMEWORK}}` | e.g. FastAPI, Spring, Next.js, Go stdlib |
| Architecture style | `{{ARCH_STYLE}}` | layered, hexagonal, microservices, CLI, library |
| Build command | `{{CMD_BUILD}}` | |
| Test command | `{{CMD_TEST}}` | |
| Lint command | `{{CMD_LINT}}` | |
| Format command | `{{CMD_FORMAT}}` | drives the PostToolUse formatter hook |
| Type-check command | `{{CMD_TYPECHECK}}` | optional |
| Domain glossary | `{{GLOSSARY}}` | key terms for CLAUDE.md |
| NFRs | `{{NFR_SUMMARY}}` | performance/security/scale targets |

## 3. Choose the roster and the convention skills

- **Agent roster** — default to the five-stage roster (analyst, architect, senior-developer,
  developer, tester). Add `auditor` and `status-reader` if the project is non-trivial. Drop a
  stage only if the user asks (e.g. a tiny library may not need a separate architect).
- **Convention skills** — pick by stack, do **not** hardcode Python:
  - Python → `python-conventions`, `python-architect`
  - TypeScript/JS → `ts-conventions`, a node/React architect skill
  - Go → `go-conventions`
  - Java/Kotlin → `jvm-conventions`
  - …otherwise create a `coding-standards` skill seeded from the TRD's stated standards.
- Always include: `git-conventions` (with GIT_SAFETY), `task-format`, `test-strategy`,
  and an `api-conventions` skill if the project exposes an API.

Record the chosen roster + skills — `framework-blueprint.md` maps roster → which agent files
and which `skills:` frontmatter entries to emit.

## 4. Generate

Hand off to `framework-blueprint.md` + `cross-tool-compat.md` (SKILL.md Step 2). Fill the
templates with the profile from §2 and the roster from §3. Seed `docs/TRD.md` from the
supplied TRD (copy it in, normalized to `trd-template.md` structure).

Create the empty pipeline dirs with their README placeholders:
`docs/requirements/`, `docs/specs/`, `docs/tasks/`, `docs/decisions/`, `docs/handoffs/`.

## 5. Checkpoint & manifest

Print the full file manifest and a review checklist. **Do not commit.** Tell the user:
- which stack/roster you inferred (so they can correct it),
- the next pipeline step (`/analyze <first-domain>`),
- that git is theirs to run.
