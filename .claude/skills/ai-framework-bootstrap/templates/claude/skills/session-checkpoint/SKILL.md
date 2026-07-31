---
name: session-checkpoint
description: >
  Save and resume active pipeline session state across token resets or multi-session workflows.
  Save a named checkpoint using /save-session <name> [summary] or resume progress using
  /resume-session <name>. Always preloaded across all agent roles; not stack-dependent.
---

# Session Checkpoint & Resumption Standards — {{PROJECT_NAME}}

This skill allows agents and human operators to save progress into structured named sessions under `docs/sessions/<session-name>.md`. It prevents context loss when tasks span multiple sessions or approach token limits.

---

## 1. When to save a checkpoint

Save a session checkpoint when:
- A task or subagent operation is approaching token/context limits.
- A multi-step workflow must pause for human review, external feedback, or overnight rest.
- Switching context to a different domain before completing the active pipeline stage.

---

## 2. Checkpoint Document Schema (`docs/sessions/<session-name>.md`)

Every saved session checkpoint MUST use the following markdown template:

```markdown
# Session Checkpoint: {{SESSION_NAME}}
Created: {{DATE_TIME}} | Role: {{ROLE_NAME}} | Stage: {{PIPELINE_STAGE}}

## 1. Objective & Target
- Target domain / task ID / feature being worked on.
- Primary requirement or specification file path.

## 2. Progress Completed
- [x] Step 1: Summary of work completed so far.
- [x] Step 2: Key files created or edited (list relative paths).

## 3. Pending & Next Actions
- [ ] Next Action 1: Exact step to resume with upon session load.
- [ ] Next Action 2: Remaining verification commands to execute.

## 4. Key Discoveries & Constraints
- Architectural decisions, edge cases discovered, or temporary workarounds.
- Anything a fresh agent instance must know without re-investigating.

## 5. Modified Files Manifest
- `path/to/file1.ext` (Modified)
- `path/to/file2.ext` (New)
```

---

## 3. Operations & Workflows

### `/save-session <name> [summary]`
1. Agent creates/updates `docs/sessions/<name>.md` adhering to the schema above.
2. Updates `docs/sessions/README.md` to list `<name>` as the latest active session checkpoint.
3. Reports the saved session path to the user.

### `/resume-session <name>`
1. Agent reads `docs/sessions/<name>.md` and `CLAUDE.md`.
2. Adopts the indicated role persona and pipeline stage.
3. Summarizes the loaded progress to the user and immediately executes the first item under `## 3. Pending & Next Actions`.
