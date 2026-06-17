---
name: wrapup
description: >
  Slash command: /wrapup. Summarizes the session's accomplishments, decisions, in-progress
  work, and next steps, then saves a dated handoff to docs/handoffs/. Runs in the main session.
disable-model-invocation: true
---

# /wrapup — Session Handoff

Do NOT delegate. Execute directly.

1. Review the session. Create `docs/handoffs/` if missing.
2. Write `docs/handoffs/YYYY-MM-DD.md` (suffix `-2`, `-3` if today's exists) with sections:
   **Accomplished**, **Decisions Made** (with rationale), **In Progress**, **Blocked / Open
   Questions**, **Next Steps**, **Files Changed**.
3. Be specific — reference task IDs and file paths; one line per bullet. Use
   `git diff --stat` (read-only) to populate Files Changed accurately.

GIT_SAFETY: this command only writes the handoff file — it never commits.
