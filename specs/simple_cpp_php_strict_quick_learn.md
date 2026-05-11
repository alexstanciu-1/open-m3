# PHP++ Quick Learn (Strict Mode) Reference

Status: active reference

Purpose: keep a short Open M3-side strict-mode addendum that points to the upstream Simple C++ / PHP++ quick-learn without duplicating it.

## Mandatory Read

For PHP++ / PHS authoring decisions, this is a mandatory read:

- repo-local skill path: `.agents/skills/simple-cpp-php-strict/`
- upstream repo path: `simple_cpp/specs/simple_cpp_php_strict_quick_learn.md`
- local workflow rule: use the default installed `scpp` command rather than a repo-local Simple C++ checkout path
- git repo: `https://github.com/alexstanciu-1/simplecpp`

## Open M3 Addendum

Open M3 keeps only short project-specific strict-mode notes here.

Read order:

1. this file for Open M3-local workflow notes
2. `.agents/skills/simple-cpp-php-strict/`
3. upstream strict quick-learn

## Current Build Guidance

For the current Open M3 workspace on `scpp 0.1.36`:

- standalone tool projects can usually be validated with `scpp build`
- `base` and tools depending on `base` should currently be validated with `scpp build --build-dependencies`

This is a current verification rule, not a source-style rule.

## Current Simplification Guidance

The newer strict updates have relaxed some earlier explicit-cast needs.

For Open M3 cleanup passes:

- simplify casts first at typed `hash<...>` foreach boundaries
- keep explicit casts where Open M3 is normalizing mixed JSON or legacy imported data
- re-test all affected `prism.json` projects after simplification

## Rule

Do not maintain a parallel Open M3-local copy of the full quick-learn content unless Open M3 intentionally needs project-specific addenda.

When Open M3 work depends on PHP++ / PHS authoring rules, read the upstream document first.
