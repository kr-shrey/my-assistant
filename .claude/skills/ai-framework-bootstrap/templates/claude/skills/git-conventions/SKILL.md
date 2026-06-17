---
name: git-conventions
description: >
  Git safety + commit message and branch naming conventions for this project. Opens with
  GIT_SAFETY. Use whenever composing a commit, naming a branch, or preparing a PR.
---

# Git Conventions — {{PROJECT_NAME}}

## GIT_SAFETY (read first, applies always)
Never commit, amend, push, or create branches without explicit user approval. Never assume git
intent. On a new dev request, propose a branch name (format below) and **ASK before creating
it**. Never auto-commit — show `git diff --stat` + the draft message and wait. Never
`--no-verify`, never force-push. Full rule: `.claude/rules/git-safety.md`.

## Commit messages
```
<type>(<scope>): <short description>

<optional body>
```
Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `style`, `perf`, `ci`, `build`.
Scope: the module/feature affected. Reference the task ID in the body when applicable.

Examples:
```
feat(auth): add token middleware for route protection
fix(api): handle null response from payment gateway
```

## Branch naming
```
<type>/<feature-or-task>
```
Examples: `feat/user-auth`, `fix/login-redirect`, `refactor/db-schema`.
**Propose the branch and confirm with the user before creating it.**

## PRs
Include: change summary, link to the relevant spec/task file, testing done, follow-up tasks.

{{GIT_OBSERVED_NOTES}}  <!-- existing-project mode: note the repo's actual commit/branch style here -->
