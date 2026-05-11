---
name: simple-cpp-php-strict
description: Use when working on Open M3 `.phs` strict-mode code, especially when making authoring decisions, simplifying strict-style patterns, or validating Open M3 Simple C++ projects. Read this before changing OM3 strict PHP++ / PHS code or deciding how to build and retest OM3 modules and tools.
---

# Simple C++ PHP Strict

Use this skill for Open M3 strict-mode `.phs` work.

## Read Order

1. Read [specs/simple_cpp_php_strict_quick_learn.md](/home/alexv/__AI/open_m3/open_m3_01/specs/simple_cpp_php_strict_quick_learn.md) first.
2. Then read the upstream strict quick-learn at `/home/alexv/__AI/simple_cpp/stable/specs/simple_cpp_php_strict_quick_learn.md` when authoring rules matter.

## OM3 Rules

- Use the installed default `scpp` command.
- Treat Open M3 as a strict-profile project.
- Prefer the smallest correct source change.
- Do not keep parallel local copies of the upstream quick-learn unless Open M3 needs short project-specific addenda.

## Current OM3 Build Rule

For the current Open M3 workspace state on `scpp 0.1.36`:

- standalone OM3 tools can usually be checked with `scpp build`
- `base` and tools that depend on `base` should currently be validated with `scpp build --build-dependencies`

This is a workflow workaround for the current dependency materialization behavior, not a permanent authored-code rule.

## Simplification Guidance

When updating OM3 strict code after toolchain improvements:

- remove compatibility casts only where the source is already strongly typed
- prefer direct foreach keys/values from typed `hash<...>` collections
- prefer the foreach-provided typed value instead of re-indexing the hash again
- keep explicit normalization when crossing mixed JSON or legacy-data boundaries
- re-test the touched project set after simplification

## Validation

- For standalone tool projects: run `scpp build`
- For `base` or any project depending on `base`: run `scpp build --build-dependencies`
- If a simplification affects shared `base` code, re-test all OM3 `prism.json` projects
