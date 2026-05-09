# SimpleC++ Strict Compatibility Report

Status: active workaround report

Date: 2026-05-09

Purpose: capture the repo-side changes and temporary workarounds needed after updating Open M3 to `scpp 0.1.22`, and separate those from remaining SimpleC++ toolchain bugs.

## Scope

Projects checked:

- `base`
- `tools/foreach_mixed_repro`
- `tools/h2b_types_to_om3`
- `tools/hash_probe`
- `tools/verify_model_loader`

All of these are strict-profile projects via `prism.json`.

## Repo-Side Changes Made

### 1. Removed PHP file headers from `.phs`

The new standard strict guidance says `.phs` files must not start with:

```php
<?php
declare(strict_types=1);
```

That header pair was removed from all strict `.phs` files in this repo.

Reason:

- `scpp 0.1.22` strict guidance now treats headerless `.phs` as the standard source shape
- keeping the old header shape is now a compatibility risk and no longer the recommended source form

### 2. Added explicit parameter types required by stricter validation

In [base/model_validator.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_validator.phs), these parameters were made explicitly typed:

- `$known_types hash<bool>`

Reason:

- `scpp 0.1.22` now rejects the earlier annotation-only form in method parameter positions
- build failure was:
  - `Missing explicit parameter type for method ... $known_types`

### 3. Replaced top-level `const` declarations in one tool

In [tools/h2b_types_to_om3/step_02_json_literal.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/h2b_types_to_om3/step_02_json_literal.phs), top-level `const` declarations were replaced with tiny accessor functions such as:

- `debug_enabled()`
- `types_json_dir()`
- `samples_root_dir()`
- `type_blacklist()`

Reason:

- `scpp 0.1.22` currently crashes in the PHP generator on this pattern instead of compiling it cleanly
- error observed:
  - `Undefined property: ... ConstantDecl::$line`
  - `Generator::appendHeaderLine(): Argument #3 ($originLine) must be of type int, null given`

This is a workaround, not a preferred final source style decision.

### 4. Removed namespace from the `base` entrypoint

In [base/main.phs](/home/alexv/__AI/open_m3/open_m3_01/base/main.phs), the namespace line was removed.

Reason:

- the entrypoint built successfully but linked with:
  - `undefined symbol: main`
- the file is meant to be the executable entrypoint, not a namespaced library unit

### 5. Kept `require_once "... .hpp"` includes in `.phs`

Current code still uses lines such as:

```php
require_once "db/reference.hpp";
```

This remains in place intentionally.

Reason:

- in this codebase, those includes are part of current SimpleC++ project composition for local generated/transpiled units
- they are not ordinary PHP runtime includes in the normal PHP sense
- the new strict skill warns against PHP-style composition as a general rule, especially across projects, but current repo code still relies on this pattern for local unit visibility

This should be revisited later with the SimpleC++ team, but it was not changed in this pass because:

- it is widespread
- it is not the immediate source of the current build failures
- removing it would be a larger architectural migration, not a compatibility touch-up

## Validation Results

### `scpp build`

After the repo-side fixes above, these projects build successfully:

- `base`
- `tools/foreach_mixed_repro`
- `tools/h2b_types_to_om3`
- `tools/hash_probe`
- `tools/verify_model_loader`

### `scpp run`

`scpp run` is still not reliable after the update, but the remaining failures are now toolchain-side rather than repo-source-shape failures.

## Workarounds Needed

### Workaround A: restore local `simple_cpp` symlink

Local symlink restored:

- `/home/alexv/__AI/open_m3/open_m3_01/simple_cpp -> /home/alexv/__AI/simple_cpp`

Reason:

- current built binaries still refer to runtime paths that assume a `simple_cpp` path shape relative to the project tree
- without that link, the expected path shape is even less likely to exist

Important note:

- this symlink is a local compatibility workaround
- it should not be treated as the desired long-term workflow
- it is not meant to justify depending on a repo-local SimpleC++ checkout in docs or committed project layout

### Workaround B: use `scpp build` as the main verification signal

Because `scpp run` is still affected by the runtime loader issue, the main reliable validation signal right now is:

- `scpp build`

Reason:

- the source compatibility changes can be validated at compile/link time
- the remaining failures are in runtime launch behavior, not in the updated strict source shape

### Workaround C: manual run from `.prism/build` for deeper diagnosis

For diagnosis only, binaries can sometimes be run more successfully when invoked directly from `.prism/build` rather than through `scpp run`.

This was used only to separate:

- repo source issues
- from launcher/runtime-path issues

This is not a normal workflow and should not remain necessary.

## Remaining SimpleC++ Bugs

### 1. Top-level `const` declaration generator bug

Observed in:

- `tools/h2b_types_to_om3/step_02_json_literal.phs`

Symptom:

- generator crashes on top-level `const` declarations with missing line metadata

Repo workaround:

- replaced `const` declarations with tiny accessor functions

### 2. `scpp run` runtime loader issue

Observed in:

- `base`
- `tools/foreach_mixed_repro`
- `tools/hash_probe`
- `tools/h2b_types_to_om3`
- `tools/verify_model_loader`

Symptom:

- built binary fails to load `libruntime.so` when launched through `scpp run`

Example failure:

```text
error while loading shared libraries: ../../../../../../simple_cpp/stable/.prism/runtime/.../libruntime.so: cannot open shared object file: No such file or directory
```

Important diagnostic observation:

- `readelf -d` shows a correct absolute `RUNPATH`
- but `ldd` still reports the runtime library as `not found`
- direct/manual runs and `scpp run` behave inconsistently depending on launch location

This strongly suggests a launcher/runtime-linking bug in SimpleC++ rather than a remaining Open M3 source issue.

### 3. Relative runtime library path embedded in produced binaries

Observed with:

- `ldd .prism/build/main`

Example:

```text
../../../../../../simple_cpp/stable/.prism/runtime/.../libruntime.so => not found
```

This path resolves incorrectly from the actual build location in the Open M3 repo.

## What Should Be Removed Later

Once SimpleC++ is fixed, these repo-side workarounds should be revisited:

1. `type_blacklist()` / `*_dir()` accessor-function workaround in `step_02_json_literal.phs`
2. restored local `simple_cpp` symlink
3. any manual reliance on `.prism/build` direct execution for diagnosis

## Recommended Next Step

1. file SimpleC++ issues for:
   - top-level `const` generator failure
   - `scpp run` runtime loader failure
   - incorrect relative `libruntime.so` path in produced binaries
2. commit the repo-side strict compatibility pass separately from toolchain bug reports
3. continue Open M3 ORM/schema work using `scpp build` as the primary verification gate until `scpp run` is fixed
