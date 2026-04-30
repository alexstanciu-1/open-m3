# AGENTS.md

This repository uses local specs as the primary project context.

## Read First

- `specs/`

Read the task-relevant specs before making non-trivial changes.

## Core Rule

Do not guess. Inspect the relevant specs and code first, then change the smallest correct surface.

## Dev Server Linking

- If the user asks the AI agent to link, re-link, activate, or start watch-sync to a dev server, the agent must first find, know, or request the shared `_dev_deploy` folder location.
- If the `_dev_deploy` location is not already known from the current workspace or prior chat context, the agent must ask for it before continuing.
- After `_dev_deploy` is known, the agent must read the shared runbooks there before acting:
  - `dev_deploy_rules.md`
  - `dev_deploy_channel_swap.md`
  - `dev_deploy_helper_contract.md`
  - `tools/fsync/README.md`
- The agent must then read the repo-local hook files under `specs/dev-deploy/`.
- The agent must resolve and validate:
  - current worktree
  - current branch and commit
  - target channel and remote path
  - current runtime binding if one exists
  - activation instance URL if one is required
- If any required input is missing, the agent must request that extra data, then continue with the documented flow.
- The agent must use the shared `_dev_deploy` helper flow rather than improvising ad hoc sync commands.
- Unless the user explicitly asks for one-time sync only, linking to a dev server should include file-sync activation by default.

