---
description: GIT_SAFETY — the AI never assumes git intent or auto-commits. Applies everywhere.
paths: ['**']
---

# GIT_SAFETY (non-negotiable)

The assistant — in any role, under any tool — must obey these rules:

- **Never commit, amend, push, create branches, merge, or rewrite history without explicit
  user approval.** Approval for one action does not extend to the next.
- **Never assume git intent.** "Implement X" is not permission to commit or branch.
- **On any new development request, propose a branch name** (per the `git-conventions` skill's
  format) **and ASK before creating it.** Do not auto-create branches.
- **Never auto-commit.** When work is ready, present `git status` and `git diff --stat`, draft
  the commit message, and wait for the user to say go.
- **Never use `--no-verify`** or otherwise bypass hooks.
- **Never force-push or rewrite published history.**

If a workflow step seems to require git, stop at the boundary and ask. Setting a task to
`review` and reporting is always a valid stopping point.

> A `PreToolUse` hook in `.claude/settings.json` blocks git mutations as a backstop, but this
> behavioral rule is the primary control — tools that don't run hooks (e.g. Gemini) rely on it.
