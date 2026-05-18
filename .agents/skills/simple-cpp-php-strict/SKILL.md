---
name: simple-cpp-php-strict
description: Use when working on Open M3 `.phs` strict-mode code, especially when making authoring decisions, simplifying strict-style patterns, or validating Open M3 Simple C++ projects. Read this before changing OM3 strict PHP++ / PHS code or deciding how to build and retest OM3 modules and tools.
---

# Simple C++ PHP Strict

Use this skill for Open M3 strict-mode `.phs` work.

## Source Of Truth

For language rules, do not rely on this file as the source of truth.

Use the installed `scpp` tooling to discover the active upstream checkout:

```bash
scpp --doctor
```

Then read the upstream strict quick-learn from the reported `repo_root`, at:

- `<repo_root>/specs/simple_cpp_php_strict_quick_learn.md`

## Open M3 Scope

This local skill should stay thin and Open M3-specific.

Use it for:

- Open M3 build/validation workflow
- Open M3 cleanup strategy
- Open M3 retest expectations after shared strict-code changes

Do not duplicate upstream strict-language semantics here unless Open M3 needs a very short temporary addendum.

## Open M3 Workflow

- use the installed default `scpp` command
- treat Open M3 as a strict-profile project
- prefer the smallest correct source change
- after `scpp update`, if existing projects still point at stale runtime state, use `scpp build --build-runtime`
- use `scpp build --build-dependencies` when you intentionally want a fuller dependency rebuild or when diagnosing dependency-state issues
- if both runtime and dependency state may be stale, use `scpp build --build-runtime --build-dependencies`

## Open M3 Authoring Preferences

- simplify casts only where the source is already strongly typed
- prefer direct foreach keys/values from typed `hash<...>` collections
- prefer the foreach-provided typed value instead of re-indexing the same hash again
- keep explicit normalization when crossing mixed JSON or legacy-data boundaries
- after shared `base` strict-code changes, re-test all affected Open M3 `prism.json` projects

## Update Hygiene

When Open M3 updates `scpp`:

1. run `scpp --doctor`
2. treat the reported `repo_root` as the active upstream source of truth
3. refresh any local Open M3 notes that mention the current `scpp` version or behavior
4. cache the new `scpp --doctor` snapshot in the relevant Open M3 planning note when the update matters for workflow or debugging
