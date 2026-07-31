---
name: query
description: >
  Instant graph-backed codebase Q&A. Answers detailed questions about project behavior,
  implementation, and dependencies using code-review-graph and codebase-memory-mcp without scanning everything.
  Usage: /query <question>
---

# Instant Codebase Query

Answer questions about system behavior, implementation, or dependencies efficiently.

## Protocol
1. Read `.claude/skills/token-efficiency/SKILL.md`.
2. Execute `code-review-graph` tools (`query_graph_tool`, `get_minimal_context_tool`, `get_impact_radius_tool`) or `codebase-memory-mcp` to locate relevant code nodes.
3. Check `docs/requirements/<domain>/traceability.md` if the query is requirement-related.
4. Read only the specific target line ranges identified.
5. Provide a token-dense, detailed answer citing exact file paths and line ranges.
