# Codex WSL Handoff

Date: 2026-04-27

Purpose: transfer the useful know-how from the current Open M3 chat into a new Codex WSL agent chat, with emphasis on the Simple C++ / S-PHP stabilization work that now blocks or slows Open M3 implementation.

## Why A New Chat

This chat started as Open M3 implementation work, but it uncovered and then fixed several important Simple C++ issues.

That drift was useful, but the next best move is to separate:

- Open M3 feature work
- Simple C++ / S-PHP stabilization work

The new chat should focus on:

- matrix completion
- semantics clarification
- removal of workarounds
- runtime / generator correctness
- ergonomics improvements

Then Open M3 coding can resume on top of a more stable foundation.

## Main Open M3 Context

Repository:

- `D:\Work_2026\open_m3`

Local Simple C++ repos:

- `D:\Work_2026\open_m3\simple_cpp`
- `C:\scpp`

These two repos were kept in sync with `origin/main` after each merged hotfix during this chat.

## Open M3 Direction Agreed So Far

### Major Roadmap

Open M3 must be able to co-work with legacy projects.

First major objective:

- have the ORM up and running for co-working mode against legacy databases

Reference:

- [roadmap.md](D:\Work_2026\open_m3\specs\roadmap.md)

### Structure

Top-level structure:

- `specs/`
- `tools/`
- `samples/`
- `modules/`
- `_legacy_code/`
- `simple_cpp/`

Reference:

- [structure.md](D:\Work_2026\open_m3\specs\structure.md)

### Root Namespace And Naming

Use:

- root namespace: `om3`

Style:

- lowercase snake style
- this is Simple C++, not conventional C++ naming

Examples:

- `om3::base::schema::model`
- `om3::base::schema::storage_property`

Files mirror namespace except `om3` is omitted from path.

Reference:

- [base_structure.md](D:\Work_2026\open_m3\specs\base_structure.md)

## Open M3 Base Layer Already On Disk

Typed base schema classes:

- `D:\Work_2026\open_m3\base\schema\model.php`
- `D:\Work_2026\open_m3\base\schema\model_property.php`
- `D:\Work_2026\open_m3\base\schema\storage.php`
- `D:\Work_2026\open_m3\base\schema\storage_property.php`

Current intended relationships:

- `model -> attached_storage` strong
- `model_property -> attached_storage` strong
- `storage -> owner_model` weak
- `storage_property -> owner_property` weak

### Loader

Current JSON loader:

- `D:\Work_2026\open_m3\base\load\json_loader.php`

It now uses normal `json_decode(...)` plus bracket access:

- `$data["name"]`
- `$data["properties"]`
- `foreach ($data["properties"] as $property_name => $property_data)`

Important:

- use `["..."]` for decoded JSON object-like data
- not `->...`

### Base Project

Project:

- `D:\Work_2026\open_m3\base`

It has a working `prism.json` and `main.php`.

It builds and runs with the local `simple_cpp`.

Last observed successful output from the loader path:

```text
Property
66
21
Id
yes
```

Meaning:

- model loaded
- storage loaded
- properties counted
- storage attached

## Legacy Bridge Tool Already Working

Tool:

- `D:\Work_2026\open_m3\tools\h2b_types_to_om3`

Purpose:

- convert H2B `types_json` legacy metadata into Open M3 `model` and `storage` JSON samples

Outputs:

- `D:\Work_2026\open_m3\samples\h2b\model`
- `D:\Work_2026\open_m3\samples\h2b\storage`
- `D:\Work_2026\open_m3\samples\h2b\report`

Status:

- full `scandir` pass succeeded
- converted `640` H2B types

Useful sample files:

- `D:\Work_2026\open_m3\samples\h2b\model\Property.json`
- `D:\Work_2026\open_m3\samples\h2b\storage\Property.json`

## Important Simple C++ Fixes Discovered And Merged During This Chat

These are the major fixes that were found by real Open M3 work and then merged into `simple_cpp`.

### 1. Windows Runtime Path For `scpp run`

Problem:

- built exe could not find runtime shared library on Windows

Fix:

- runner now puts runtime directory on `PATH`

### 2. String-Key Pool Consistency Across Exe / Runtime Boundary

Problem:

- string-key ids got remapped across exe and runtime shared library
- object keys like `name` / `class` were corrupted

Fix:

- string interning moved to one shared runtime-owned pool

### 3. `foreach` Over Mixed Object-Like Tables

Problem:

- `foreach ($data as $v)` and `foreach ($data as $k => $v)` on object-like `mixed_t` were not lowering/iterating correctly

Fix:

- initial fix for mixed table iteration

### 4. `foreach (scandir(...))`

Problem:

- wrapped filesystem results were not iterable from PHP surface

Fix:

- result-wrapper iteration support added

### 5. Header Forward Declarations For Cyclic Class References

Problem:

- mutually referring classes in different files failed because generated headers did not emit enough forward declarations

Fix:

- generator now emits forward declarations for referenced classes used in class definitions

### 6. Runtime-Adapter-Based `foreach`

Problem:

- generator was choosing iteration strategy based on partial type inference
- this was fragile, especially for decoded JSON and wrapped values

Fix:

- `foreach` lowering moved toward one runtime adapter path
- runtime adapter now supports mixed object-like values and wrapped/vector carriers more robustly

Merged reference from local log:

- `a8853a4 Merge pull request #10 from alexstanciu-1/hotfix/foreach-runtime-adapter`

## Dedicated Foreach Probe

Probe project:

- `D:\Work_2026\open_m3\tools\foreach_mixed_repro`

Report:

- `D:\Work_2026\open_m3\tools\foreach_mixed_repro\report.md`

The probe covered all 4 required forms:

- `foreach ($data as $v)`
- `foreach ($data as $k => $v)`
- `foreach ($data as &$v)`
- `foreach ($data as $k => &$v)`

For both:

- direct object-like data
- `json_decode(...)` object-like data

All 8 cases passed in that probe.

## Why The Agent Kept Expecting PHP

This matters for the semantics cleanup.

The assistant repeatedly defaulted toward PHP assumptions because:

- syntax is PHP-shaped
- builtin names are PHP names
- some behavior really does overlap with PHP
- missing or undocumented spaces get auto-filled with PHP expectations

Key lesson:

- S-PHP must be documented as PHP-like, not PHP
- semantic differences must be explicit, especially for:
  - `require_once`
  - `json_decode`
  - `foreach`
  - references
  - wrappers like `result<T>`
  - typing rules

## Still Not Fully OK In Simple C++

These are the remaining rough edges or workaround areas that should be audited and likely addressed before continuing too much Open M3 coding.

### `take(...)` Ergonomics

Still unresolved or not clean:

- `take($files, scandir(...))`

During this chat, the decision was:

- do not use `take(...)` for now unless explicitly requested

### `require_once` Semantics

Current practical rule:

- compile-time static include only
- literal path
- file prologue

This is not necessarily wrong, but it should be documented as S-PHP behavior so people do not keep expecting PHP include semantics.

### Included-File Top-Level Variable Behavior

This still felt weaker/less natural than PHP expectations.

Workaround used:

- prefer constants/functions in included config-like files
- do not rely on top-level include variable sharing

This deserves a deliberate later audit.

### Generator Type Guessing Pressure

Even after the foreach runtime-adapter work, the broader lesson remains:

- the s2s generator should not guess too much from partial inferred types

Future similar cases may need:

- more runtime adapters
- less direct lowering to internal container details

### Naming / Keyword / Collision Safety

We already hit:

- `struct` is invalid as namespace part after lowering to C++

And had to adjust:

- `nullable` -> `is_nullable`
- some attachment property names

This suggests more systematic collision-safe naming guidance may be useful.

### Windows Tooling / Environment Smoothness

Reliable build/run path in practice:

- Windows Git Bash / MSYS path

Less reliable:

- plain PowerShell for some `git` / build flows
- WSL `/mnt/...` paths were considered slow and should be avoided for big file trees

### Test Runtime Artifact Cleanup

`tests/.runtime` artifacts sometimes stayed locked or noisy.

This is not a core language blocker, but it makes iterative work messier than ideal.

## Recommended Focus For The New Stabilization Chat

The new Codex WSL agent chat should focus on Simple C++ / S-PHP stabilization, not Open M3 feature expansion.

Suggested priorities:

1. finish / monitor matrix work
2. list and remove remaining Open M3 workarounds
3. create one S-PHP examples/semantics file
4. verify `take(...)` behavior and intended syntax
5. clarify include semantics and included-file rules
6. review remaining generator assumptions that should move to runtime adapters
7. improve Windows workflow guidance where needed

## Suggested First Task In The New Chat

Start with:

- “Review this handoff and produce a stabilization checklist for Simple C++ / S-PHP, separating already fixed issues from still-open semantics and ergonomics gaps.”

That should give a clean platform-focused thread before returning to Open M3 implementation.

## Short Summary

This chat achieved:

- first real Simple C++ app
- first real typed Open M3 base layer
- first real JSON loader
- first large H2B legacy bridge
- several meaningful Simple C++ fixes merged upstream

The right next move is not “write more Open M3 code immediately”.

The right next move is:

- stabilize the language/runtime/compiler experience for the patterns Open M3 now depends on
- then resume ORM and SQL generation work with less friction
