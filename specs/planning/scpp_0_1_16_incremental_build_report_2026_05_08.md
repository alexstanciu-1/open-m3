# SimpleC++ Incremental Build / PCH Report

Date: 2026-05-08

Environment:
- Workspace: `/home/alexv/__AI/open_m3/open_m3_01`
- Tool target: `/home/alexv/__AI/open_m3/open_m3_01/tools/verify_model_loader`
- `scpp`: `0.1.16`
- Compiler shown by `scpp run`: `g++ -fuse-ld=mold (gnu_like)`
- Runtime mode shown by `scpp run`:
  - `Runtime compilation: reuse existing artifact only`
  - `Dependency compilation: reuse existing artifacts only`

## Summary

There were two related observations:

1. Repeated unchanged `scpp run` executions previously rebuilt the local PCH/object chain every time for this target.
2. The emitted `build.ninja` still looks inconsistent when driven directly with `ninja -d explain`: Ninja reports missing dep state and missing in-edges for generated inputs and dependency objects.

After trimming the verifier to H2B-only, `scpp run` now reaches a stable warm state and reports `ninja: no work to do.` on the second unchanged run. So the first issue is currently **not reproducing in the reduced target**, but the second issue remains a useful clue.

## Reproduction History

### A. Repeated local rebuilds on unchanged runs

Before trimming the verifier from `h2b + travelfuse` to `h2b` only, repeated unchanged runs of:

```bash
cd /home/alexv/__AI/open_m3/open_m3_01/tools/verify_model_loader
SCPP_NINJA_VERBOSE=1 scpp run
```

were rebuilding these local artifacts every time:

- `.prism/build/app_pch.hpp.gch`
- `.prism/build/main.o`
- `.prism/build/orm_audit_sample.o`
- `.prism/build/assembly_sample.o`
- `.prism/build/main`

Example observed output:

```text
[1/5] g++ ... -x c++-header .prism/build/app_pch.hpp -o .prism/build/app_pch.hpp.gch
[2/5] g++ ... -c .prism/generated/main.cpp -o .prism/build/main.o
[3/5] g++ ... -c .prism/generated/orm_audit_sample.cpp -o .prism/build/orm_audit_sample.o
[4/5] g++ ... -c .prism/generated/assembly_sample.cpp -o .prism/build/assembly_sample.o
[5/5] g++ ... -o .prism/build/main
Rebuilt outputs: .prism/build/app_pch.hpp.gch, .prism/build/assembly_sample.o, .prism/build/main, .prism/build/main.o, .prism/build/orm_audit_sample.o
```

### B. Current reduced-target behavior

After reducing the verifier to H2B-only, first run:

```text
Transpiled PHP files: 1, skipped unchanged: 24
[1/2] CXX .prism/build/orm_audit_sample.o
[2/2] LINK .prism/build/main
```

Second unchanged run:

```text
Transpiled PHP files: 0, skipped unchanged: 25
ninja: no work to do.
Rebuilt outputs: none (up-to-date)
```

So the repeated PCH rebuild issue appears to be configuration-sensitive or related to the larger prior target shape, and is not currently reproducing in the smaller H2B-only version.

## Strong Clue: Generated Ninja Graph Looks Incomplete

Running Ninja directly against the emitted build file:

```bash
cd /home/alexv/__AI/open_m3/open_m3_01
ninja -C tools/verify_model_loader/.prism/build -d explain .prism/build/main
```

produces errors like:

```text
ninja explain: deps for '.prism/build/app_pch.hpp.gch' are missing
ninja explain: .prism/build/app_pch.hpp has no in-edge and is missing
ninja explain: deps for '.prism/build/main.o' are missing
ninja explain: .prism/generated/main.cpp has no in-edge and is missing
ninja explain: deps for '.prism/build/orm_audit_sample.o' are missing
ninja explain: .prism/generated/orm_audit_sample.cpp has no in-edge and is missing
ninja explain: ../../base/.prism/build/__deps/.../db/column.o has no in-edge and is missing
ninja: error: '../../base/.prism/build/__deps/.../db/column.o', needed by '.prism/build/main', missing and no known rule to make it
```

This is notable because those files do exist relative to the project root, and `scpp run` itself is able to build and run the target.

## Additional Concrete Observation

The local build dir does not retain the expected `.d` depfiles after `scpp run`.

Observed contents of `tools/verify_model_loader/.prism/build`:

- `app_pch.hpp`
- `app_pch.hpp.gch`
- `assembly_sample.o`
- `build.ninja`
- `main`
- `main.o`
- `orm_audit_sample.o`
- `runtime_pch.hpp`
- `runtime_pch.hpp.gch`
- `runtime_signature.txt`

Expected depfiles such as:

- `app_pch.hpp.gch.d`
- `main.o.d`
- `orm_audit_sample.o.d`
- `assembly_sample.o.d`

were not present after the run.

Since the Ninja rules declare:

```text
depfile = $out.d
deps = gcc
```

missing depfiles would be enough to destabilize incremental rebuild decisions.

## Files To Inspect

- `tools/verify_model_loader/.prism/build/build.ninja`
- `tools/verify_model_loader/.prism/build/app_pch.hpp.gch`
- `tools/verify_model_loader/.prism/build/main.o`
- `tools/verify_model_loader/.prism/build/orm_audit_sample.o`
- `base/.prism/build/__deps/...`

## Suggested Developer Questions

1. Are `.d` depfiles intentionally removed after `scpp run`, or should they persist for warm incremental builds?
2. Is the generated `build.ninja` expected to be directly runnable with `ninja -C ...`, or is it relying on `scpp`-side setup that Ninja alone cannot see?
3. Could the previous repeated PCH rebuild behavior have been caused by depfile invalidation or regeneration of local generated inputs even when `Transpiled PHP files: 0`?
4. Is there any difference in incremental treatment between:
   - local project-generated `.prism/generated/*`
   - dependency project objects under `base/.prism/build/__deps/...`

## Current Status

- `scpp 0.1.16` default warm-reuse behavior works in practice for `scpp run`.
- The reduced H2B-only verifier now reaches a stable `no work to do` state on unchanged reruns.
- The emitted Ninja graph still looks suspicious when inspected directly, especially around depfiles and dependency object ownership.
