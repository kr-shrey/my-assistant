---
name: {{STACK_CONVENTIONS_SKILL}}
description: >
  Coding conventions for {{STACK_LANGUAGE}} in this project — the rules humans/agents must
  enforce (beyond what {{CMD_LINT}}/{{CMD_FORMAT}} catch automatically). Auto-applies to any
  code generation or review.
---

# {{STACK_LANGUAGE}} Coding Conventions — {{PROJECT_NAME}}

> Formatting, import order, and naming are enforced by `{{CMD_FORMAT}}` / `{{CMD_LINT}}` —
> omitted here. This skill covers the judgment rules only people/agents enforce.
> EXISTING project: fill each section from the conventions *observed in the code* (TRD §9),
> with a representative example. Do not impose a style the codebase doesn't already use.

## Error handling
{{CONV_ERROR_HANDLING}}  <!-- catch specificity, custom error base, no silent catches, chaining -->

## Logging
{{CONV_LOGGING}}  <!-- module logger, levels, what never to log (secrets/PII) -->

## Docstrings / comments
{{CONV_DOCS}}  <!-- public-API doc style; comments explain WHY not WHAT; TODO(author): format -->
See `skill-lifecycle-standards` for the added bar on non-obvious choices: logic, strategy
rationale, and alternatives/trade-offs — not just why, when the choice isn't obvious from the
code alone. Never reference doc files (specs/ADRs/tasks) from code comments — see that skill's
doc↔code direction rule.

## Defensive coding
{{CONV_DEFENSIVE}}  <!-- guard clauses, no deep nesting, immutability defaults, enums over magic values -->

## Concurrency / async
{{CONV_CONCURRENCY}}  <!-- threading/async rules, no blocking in async paths, cancellation -->

## Module boundaries & public API
{{CONV_BOUNDARIES}}  <!-- what's public vs internal, deprecation policy, versioning -->

## Security & input validation
{{CONV_SECURITY}}  <!-- size limits, no eval/exec on untrusted input, sanitize before logging -->

## Testing
{{CONV_TESTING}}  <!-- test file layout, naming, fixtures; mirror in test-strategy skill -->

## Quick checklist
- [ ] {{CHECKLIST_ITEMS}}
