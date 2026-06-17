# TRD template — canonical Technical Requirement Document structure

One template, both modes:
- **New project** — the user supplies a TRD; normalize it into this shape as `docs/TRD.md`.
- **Existing project** — you *produce* `docs/TRD.md` in this shape from the scan findings.

Mark every item as **[fact]** (evidenced in code/docs) or **[inferred]** (your deduction) in
existing-project mode. Quantify everything — no "fast", "secure", "scalable" without numbers.

```markdown
# Technical Requirement Document — {{PROJECT_NAME}}
Version: 0.1   |   Date: {{DATE}}   |   Source: {{supplied | reverse-engineered}}

## 1. Overview & Purpose
- What the system does, for whom, and the business value. One paragraph.
- Scope: in / out.

## 2. System Context & External References
- Upstream/downstream systems, APIs consumed/exposed, queues, third-party services.
- External references: submodules, vendored libraries, shared internal packages, datasets.
- A context diagram or bullet map of who-talks-to-whom.

## 3. Technology Stack
- Language(s) + versions, runtime, frameworks, key libraries.
- Datastores, messaging, caches.
- Package/build tooling, CI/CD.
- (existing mode: pull versions from manifests/lockfiles — cite the file.)

## 4. Architecture & Module Map
- Architecture style (layered / hexagonal / microservices / CLI / library / …).
- Module/package map: each module's responsibility and its dependencies.
- Entry points (main, routers, CLI commands, jobs).

## 5. Data Models
- Core entities/types, their fields, relationships, persistence.
- Validation rules and invariants.

## 6. Functional Capabilities
- What the system does, as capability statements ("The system shall …").
- Group by domain. These seed `docs/requirements/<domain>/` later.

## 7. Non-Functional Requirements
- Performance (latency/throughput targets), scalability, reliability (SLA/SLO), security,
  observability, maintainability — each with a measurable target and how it's measured.
- (existing mode: infer from timeouts, retries, caching, rate limits, auth in the code.)

## 8. Build / Test / Deploy
- Build: {{CMD_BUILD}}
- Test: {{CMD_TEST}}   (unit / integration / e2e split)
- Lint: {{CMD_LINT}}   Format: {{CMD_FORMAT}}   Typecheck: {{CMD_TYPECHECK}}
- Deploy/runtime topology (containers, serverless, hosts).

## 9. Conventions (Observed / Required)
- Naming, error handling, logging, async, module boundaries, public-API rules.
- Test layout and naming.
- Commit/branch style (from git history in existing mode).
- (existing mode: quote 1–2 representative code examples per convention.)

## 10. Domain Glossary
- Project-specific terms with definitions, drawn from the code's own vocabulary.

## 11. Open Questions / Risks
- Anything ambiguous, inconsistent, or unanswered by the source/code. Owner + how to resolve.
```

## How the TRD feeds generation
| TRD section | Drives |
|---|---|
| §3 Stack | which convention skills + which formatter/linter hooks |
| §4 Architecture | architect persona emphasis, ADR topics |
| §6 Capabilities | initial `docs/requirements/<domain>/` seeds |
| §7 NFRs | architect + test-strategy emphasis |
| §8 Commands | `.claude/settings.json` hooks, tester/developer verify steps |
| §9 Conventions | the generated `coding-standards`/`*-conventions` skill body |
| §10 Glossary | `CLAUDE.md` glossary section |
