---
name: token-efficiency
description: >
  Mandatory token efficiency & graph-first context retrieval standards for all agents:
  (1) Graph-first retrieval using code-review-graph and codebase-memory-mcp,
  (2) Requirement-to-code traceability lookups via docs/requirements/<domain>/traceability.md,
  (3) Caveman token-dense output style to minimize context overhead. Always preloaded across all roles.
---

# Token Efficiency & AI-Readiness Standards — {{PROJECT_NAME}}

This skill applies to every agent in the pipeline to maximize token efficiency, prevent context window bloat, and allow instant Q&A without full-codebase scans.

---

## 1. Graph-First Context Retrieval (Zero-Scan Protocol)

Never perform brute-force file scans or dump whole directories into context when answering questions or starting a task. Always follow this 3-tier lookup hierarchy:

```
[Tier 1: Graph Query]  ──► Query code-review-graph / codebase-memory-mcp for exact symbol & call graph
        │
        ▼
[Tier 2: Traceability]  ──► Check docs/requirements/<domain>/traceability.md for feature → file mapping
        │
        ▼
[Tier 3: Surgical Read] ──► Read ONLY the specific line range returned by Tier 1 or Tier 2
```

### Preferred MCP Tool Usage Matrix

| Operation | Tool / Command | Why it saves tokens |
|---|---|---|
| Module/architecture overview | `code-review-graph:get_architecture_overview_tool` | Summarizes system components without reading source files |
| Context for specific function/file | `code-review-graph:get_minimal_context_tool` | Extracts only declaration & direct dependencies |
| Change impact analysis | `code-review-graph:get_impact_radius_tool` | Identifies affected callers without searching all files |
| Call flow tracing | `code-review-graph:get_flow_tool` / `traverse_graph_tool` | Traces execution path directly |
| Symbol lookups | `codebase-memory-mcp` search / graph query | $O(1)$ symbol search |

---

## 2. Token-Dense Communication Protocol ("Caveman" Discipline)

When outputting step summaries, handoffs, or status updates to other agents or logs:

- **Eliminate Conversational Filler**: Omit introductory pleasantries ("Sure, I can help with that", "Here is the code you requested").
- **Concise Bullet Summaries**: Summarize changes, decisions, and verification results in short bullet points.
- **No Duplicate File Dumps**: Do not re-print entire source files in chat output. Show diff snippets or point directly to file line numbers.
- **Focus on Decisions & Delta**: Report what changed, why it changed, and verification status.

---

## 3. Dual-Tool Model Routing Guidelines

Agents and slash commands in this repository are assigned to optimal model tiers to maximize reasoning quality while minimizing token costs:

| Tier | Role / Command | Claude Model | Gemini Model |
|---|---|---|---|
| **Tier 1 (High Reasoning)** | `analyst`, `architect`, `senior-developer` | Opus / Pro | `gemini-1.5-pro` / `gemini-2.0-pro` |
| **Tier 2 (Execution)** | `developer`, `tester` | Sonnet | `gemini-1.5-pro` / `gemini-2.0-flash-thinking` |
| **Tier 3 (Fast Lookups)** | `status-reader`, `/query`, `/save-session` | Haiku | `gemini-1.5-flash` / `gemini-2.0-flash-lite` |
