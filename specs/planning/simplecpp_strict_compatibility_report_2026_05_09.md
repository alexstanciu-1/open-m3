# SimpleC++ Strict Compatibility Report

Historical note:

- this document captures the `scpp 0.1.22` compatibility pass and its then-current workaround set
- do not treat its workaround sections as active Open M3 workflow without revalidation on the current installed `scpp`
- several items recorded here were later fixed upstream or no longer reproduce on newer local tool versions

Status: historical workaround report

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

This was a workaround, not a preferred final source style decision.

Update:

- retested on `scpp 0.1.23`
- the original top-level `const` form now builds cleanly again
- the repo has been switched back to the normal `const` form

### 4. Removed namespace from the `base` entrypoint

In [base/main.phs](/home/alexv/__AI/open_m3/open_m3_01/base/main.phs), the namespace line was removed.

Reason:

- the entrypoint built successfully but linked with:
  - `undefined symbol: main`
- the file is meant to be the executable entrypoint, not a namespaced library unit

Current note:

- this should be read as a historical compatibility decision from the older failing period
- the specific `undefined symbol: main` issue discussed in later `0.1.36` notes no longer reproduces on the current local `scpp`

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

Historical note:

- the workaround list below reflects the repo state during the `0.1.22` transition
- some items may no longer be necessary on current tool versions

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

Current note:

- Open M3 should prefer current revalidation before assuming any of these workaround sections are still operationally required

## Remaining SimpleC++ Bugs

Historical note:

- the bug list below is historically valuable, but not all items are still current
- re-check against the installed `scpp` version before filing or reusing any of these as active bug claims

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

1. restored local `simple_cpp` symlink
2. any manual reliance on `.prism/build` direct execution for diagnosis

## Code-Focused Addendum

This section tracks remaining source patterns that still look like toolchain-driven workarounds or compatibility stabilizers, even when they are currently acceptable and build correctly.

The purpose is not to remove them blindly now.

The purpose is to:

- keep a review list
- map code patterns back to upstream SimpleC++ issues
- make later cleanup easier once fixes land

### A. Foreach Key Stabilization

Current repro locations:

- [tools/hash_probe/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/hash_probe/main.phs:28)
- [tools/hash_probe/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/hash_probe/main.phs:40)

Pattern:

```php
$key_s /** string */ = (string) $key;
```

Reason:

- typed `hash<T>` foreach keys still do not feel fully surfaced as naturally typed string keys at common typed boundaries

Related upstream issue:

- [simplecpp#54](https://github.com/alexstanciu-1/simplecpp/issues/54)

### B. Top-Level `const` Replacement With Accessor Functions

Historical location:

- [tools/h2b_types_to_om3/step_02_json_literal.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/h2b_types_to_om3/step_02_json_literal.phs:1)

Reason:

- top-level `const` declarations triggered a generator crash on `scpp 0.1.22`

Related upstream issue:

- [simplecpp#51](https://github.com/alexstanciu-1/simplecpp/issues/51)

Current status:

- resolved upstream
- retested successfully on `scpp 0.1.23`
- workaround removed from repo code

### C. Explicit Typed Parameter Upgrade For Checker Compatibility

Current location:

- [base/model_validator.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_validator.phs:49)
- [base/model_validator.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_validator.phs:62)
- [base/model_validator.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_validator.phs:84)

Pattern:

```php
$known_types hash<bool>
```

Reason:

- `scpp 0.1.22` rejected the earlier annotation-only parameter form

Assessment:

- this is probably acceptable final strict code
- but it is still recorded here because it was introduced specifically as part of the compatibility pass

### D. Broad Manual `(string)` Stabilization At Mixed/Hash Boundaries

These sites may be legitimate normalization points, but as a group they still deserve later review because they may partly reflect missing or awkward key/value typing behavior.

Representative locations:

- [base/json_loader.phs](/home/alexv/__AI/open_m3/open_m3_01/base/json_loader.phs:89)
- [base/model_validator.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_validator.phs:37)
- [base/model_validator.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_validator.phs:56)
- [base/model_validator.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_validator.phs:72)
- [base/model_validator.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_validator.phs:80)
- [base/db/structure_builder.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/structure_builder.phs:77)
- [base/db/structure_builder.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/structure_builder.phs:188)
- [base/db/structure_builder.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/structure_builder.phs:193)
- [base/db/structure_builder.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/structure_builder.phs:206)
- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:176)
- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:285)
- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:489)
- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:603)
- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:1256)
- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:1679)

Assessment:

- not every `(string)` cast here is necessarily a bug or workaround
- some are reasonable explicit normalization boundaries
- but this cluster should be re-reviewed after the foreach/hash typing issues are improved upstream

### E. Executable Entrypoint Namespace Constraint

Current location:

- [base/main.phs](/home/alexv/__AI/open_m3/open_m3_01/base/main.phs:1)

Change made:

- removed the namespace from the executable entrypoint

Reason:

- the namespaced entrypoint linked with `undefined symbol: main`

Assessment:

- this may simply be the required rule for executable entry files in strict projects
- still tracked here because it changed during the compatibility pass and should be documented explicitly

### F. Runtime Launch Workaround Attempts

These are not committed code patterns, but they are still important workaround history:

- temporarily restoring a local `simple_cpp` symlink
- manually trying to execute binaries from `.prism/build`
- using `scpp build` instead of `scpp run` as the reliable validation gate

Related upstream issues:

- [simplecpp#52](https://github.com/alexstanciu-1/simplecpp/issues/52)
- [simplecpp#53](https://github.com/alexstanciu-1/simplecpp/issues/53)

## Recommended Next Step

1. file SimpleC++ issues for:
   - top-level `const` generator failure
   - `scpp run` runtime loader failure
   - incorrect relative `libruntime.so` path in produced binaries
2. commit the repo-side strict compatibility pass separately from toolchain bug reports
3. continue Open M3 ORM/schema work using `scpp build` as the primary verification gate until `scpp run` is fixed
