# PHP++ Quick Learn (Strict Mode) Reference

Status: active reference

Purpose: keep a very short Open M3-side addendum that points to the active upstream Simple C++ strict quick-learn without maintaining a parallel copy of language rules.

## Source Of Truth

For PHP++ / PHS authoring rules, first discover the active installed Simple C++ checkout:

```bash
scpp --doctor
```

Then read the upstream strict quick-learn from the reported `repo_root`:

- `<repo_root>/specs/simple_cpp_php_strict_quick_learn.md`

Do not hard-code the upstream checkout path in Open M3 notes.

## Open M3 Addendum

Open M3 keeps only short project-specific workflow notes here.

### Build Guidance

- use `scpp build` as the normal first validation command
- after `scpp update`, if a project still points at stale runtime state, use `scpp build --build-runtime`
- use `scpp build --build-dependencies` for deeper dependency-refresh or dependency-state diagnosis
- use `scpp build --build-runtime --build-dependencies` when both layers may be stale

### Cleanup Guidance

- simplify casts first at typed `hash<...>` foreach boundaries
- keep explicit normalization at mixed JSON or legacy metadata boundaries unless a local repro proves otherwise
- after shared strict-code changes, re-test the affected Open M3 `prism.json` projects

### Update Hygiene

After `scpp update`:

1. run `scpp --doctor`
2. use the reported `repo_root` as the upstream documentation source of truth
3. refresh any Open M3 notes that mention the current `scpp` version or changed strict behavior
4. cache the current `scpp --doctor` snapshot in a planning/workflow note when the update affects debugging or local process

## Rule

Do not maintain a parallel Open M3-local copy of the upstream strict quick-learn unless Open M3 intentionally needs a short temporary addendum.
