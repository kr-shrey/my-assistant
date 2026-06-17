---
name: test-strategy
description: >
  Testing conventions for {{PROJECT_NAME}}: test types, naming, layout, fixtures/mocks, and
  acceptance-criteria-to-test mapping. Use when writing or reviewing tests.
---

# Test Strategy — {{PROJECT_NAME}}

> EXISTING project: fill from the test conventions observed in the codebase (TRD §9). Quote a
> representative test. NEW project: derive from the TRD's stated tooling.

## Test types & commands
- **Unit** (fast, no I/O): {{CMD_TEST_UNIT}}
- **Integration** (DB/containers): {{CMD_TEST_INTEGRATION}}
- **E2e** (full stack): {{CMD_TEST_E2E}}
- Full suite: `{{CMD_TEST}}`

## Layout & naming
- Mirror source paths: `{{SRC_PATH_EXAMPLE}}` → `{{TEST_PATH_EXAMPLE}}`.
- Test naming: `{{TEST_NAMING_PATTERN}}` (e.g. `test_<unit>_<scenario>_<expected>`).
- Arrange / Act / Assert, separated clearly.

## Fixtures & mocks
{{TEST_FIXTURE_RULES}}  <!-- fixture framework, factory pattern, no order dependencies, what to mock -->

## Acceptance-criteria mapping
Every numbered acceptance criterion in a task maps to at least one test. Test both the happy
path and the error/edge paths named in the criteria.

## Coverage
{{COVERAGE_TARGET}}  <!-- target + how it's measured, if the project tracks it -->
