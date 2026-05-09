# Open M3 Toolchain Direction

Status: draft

Purpose: record how Open M3 should consume Simple C++ changes without losing its own strict-mode direction.

## Current Context

Open M3 currently depends on the installed default `scpp` tool for compilation and runtime behavior.

For PHP++ / PHS authoring decisions, the upstream quick-learn at `simple_cpp/specs/simple_cpp_php_strict_quick_learn.md` should be treated as a mandatory read.

Important reference paths:

- legacy reference root: `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code`

Operational rule:

- use the default installed `scpp` command
- do not rely on a repo-local Simple C++ checkout path in Open M3 docs or workflows

The current upstream release page shows newer releases through:

- `v0.1.6` published on 2026-05-02

## What Matters From Recent Simple C++ Releases

Relevant release notes between the older local state and `v0.1.6` include:

- runtime and lowering fixes for mixed-object `foreach`
- by-reference `foreach` support on the shared runtime path
- same-namespace forward declaration cycle fixes
- CLI entrypoint helper fixes for `$argc`, `$argv`, `cli_argc()`, and `cli_argv()`
- canonical `.phs` frontend handling in the current upstream default frontend surface while keeping `.php` compatibility

## Open M3 Rule

Open M3 must remain a strict-mode project with its own library surface.

Therefore:

- compiler/runtime correctness fixes from Simple C++ should be adopted when useful
- Open M3 should not automatically adopt upstream frontend branding, naming, or extension choices just because they became canonical upstream
- the Open M3 authored surface should be decided by Open M3 strict-mode needs first
- any eventual replacement for upstream-facing labels or branding should be handled as a separate naming discussion

## Immediate Guidance

For now:

- keep existing Open M3 source files stable unless a strict-mode migration plan explicitly says otherwise
- treat `.php` versus `.phs` as a separate migration decision, not an automatic repo-wide rename
- prefer spec and architecture updates first, then targeted runtime adoption, then authored-surface migration only when the strict library shape is clear

## Practical Upgrade Split

When updating against newer Simple C++ releases, split the work into three separate questions:

1. Which generator/runtime fixes should Open M3 consume immediately?
2. Which project-config or build-flow changes should Open M3 adopt?
3. Which authored-surface conventions belong to strict-mode Open M3 itself?

These should not be collapsed into one decision.
