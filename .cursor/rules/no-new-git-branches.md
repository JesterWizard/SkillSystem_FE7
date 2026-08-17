---
description: Never create git branches unless the user explicitly asks
alwaysApply: true
---

# No New Git Branches

Do not create, checkout, or switch to a new git branch unless the user explicitly asks for a new branch in the current message.

## Forbidden without an explicit request

- `git checkout -b`
- `git switch -c`
- `git branch <name>` (creating a branch)
- Any tool, script, or PR flow that creates a branch as a side effect

## Allowed without asking

- Work on the current branch
- Commit, stage, and unstage (only when the user asked)
- Inspect remotes, status, log, and diff
- Push the **current** branch (only when the user asked)

## Explicit request examples (OK)

- "create a branch named `fix-mss`"
- "make a new branch for this"
- "checkout `-b feat/str-mag`"

## Not an explicit request (do not create a branch)

- "create a PR"
- "commit this"
- "fix this bug"
- "split this into PRs" (ask which existing branch to use, or wait until they name a new one)

If a workflow would normally create a branch first, stay on the current branch and say you did not create one.
