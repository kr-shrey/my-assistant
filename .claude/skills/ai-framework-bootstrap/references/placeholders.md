# Master Placeholder Dictionary

This document defines the canonical list of all placeholders used throughout the `templates/` tree. When bootstrapping a framework, every placeholder must be replaced with a concrete value derived from the TRD (new mode) or codebase scan (existing mode).

---

## Master Dictionary

| Placeholder | Category | Description | Default Fallback | Target Files Consuming It |
|---|---|---|---|---|
| `{{PROJECT_NAME}}` | General | Human-readable project name | Directory basename | `CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, `docs/TRD.md`, `skill-lifecycle-standards/SKILL.md` |
| `{{PROJECT_PURPOSE}}` | General | One-line project summary / objective | `"AI-assisted software development repository."` | `CLAUDE.md`, `GEMINI.md` |
| `{{STACK_LANGUAGE}}` | Stack | Primary programming language(s) | `"Polyglot / Unspecified"` | `CLAUDE.md`, `docs/TRD.md` |
| `{{STACK_FRAMEWORK}}` | Stack | Main runtime/framework (e.g. FastAPI, Next.js, Go stdlib) | `"Standard Library / Core Framework"` | `CLAUDE.md`, `docs/TRD.md` |
| `{{STACK_DATA}}` | Stack | Datastores, caches, message queues (e.g. PostgreSQL, Redis) | `"N/A"` | `CLAUDE.md`, `docs/TRD.md` |
| `{{ARCH_STYLE}}` | Architecture | Architectural pattern (layered, microservices, CLI, hexagonal) | `"Layered Architecture"` | `CLAUDE.md`, `docs/TRD.md` |
| `{{MODULE_MAP}}` | Architecture | High-level module breakdown | `"See docs/TRD.md"` | `CLAUDE.md` |
| `{{ENTRY_POINTS}}` | Architecture | Main entry points (main.py, index.ts, CLI commands) | `"Main module"` | `CLAUDE.md` |
| `{{CMD_BUILD}}` | Tooling | Command to build the project | `"echo 'No build step required'"` | `CLAUDE.md`, `docs/TRD.md`, `developer.md`, `tester.md` |
| `{{CMD_TEST}}` | Tooling | Test execution command | `"pytest"` / `"npm test"` / `"go test ./..."` | `CLAUDE.md`, `docs/TRD.md`, `developer.md`, `tester.md` |
| `{{CMD_LINT}}` | Tooling | Linter execution command | `"ruff check"` / `"eslint ."` / `"golangci-lint run"` | `CLAUDE.md`, `docs/TRD.md`, `developer.md`, `tester.md` |
| `{{CMD_FORMAT}}` | Tooling | Formatter execution command | `"ruff format"` / `"prettier --write ."` / `"gofmt -w ."` | `CLAUDE.md`, `docs/TRD.md`, `settings.json (claude)` |
| `{{CMD_TYPECHECK}}` | Tooling | Type-checking command | `"mypy ."` / `"tsc --noEmit"` / `"N/A"` | `CLAUDE.md`, `docs/TRD.md`, `developer.md` |
| `{{STACK_CONVENTIONS_SKILL}}` | Conventions | Name of primary convention skill | `"coding-standards"` | `CLAUDE.md`, `developer.md` |
| `{{GLOSSARY}}` | Glossary | Key project-specific domain terms | `"None defined yet."` | `CLAUDE.md`, `docs/TRD.md` |
| `{{NFR_SUMMARY}}` | Requirements | Summary of non-functional targets (SLAs, latency, memory) | `"Standard maintainability & reliability standards."` | `docs/TRD.md`, `analyst.md`, `architect.md` |
| `{{OTHER_NON_NEGOTIABLES}}` | Rules | Critical domain/security/PII constraints | `"None."` | `CLAUDE.md` |
| `{{FORMAT_HOOK}}` | Hooks | PostToolUse formatter script logic keyed on file extension | Case match block per extension | `.claude/settings.json` |

---

## Derivation Checklist

Before generating files, the orchestrator MUST verify that values are assigned to all 18 placeholders above. No unreplaced `{{PLACEHOLDER}}` strings may remain in generated outputs.
