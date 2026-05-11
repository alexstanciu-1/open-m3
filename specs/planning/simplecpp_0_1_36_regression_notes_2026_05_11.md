# SimpleC++ 0.1.36 Regression Notes

Status: active investigation note

Date: 2026-05-11

Purpose: record the Simple C++ issues encountered while re-testing the updated Open M3 strict projects on `scpp 0.1.36`, so they can be raised upstream with concrete evidence.

## Environment

- repo: `open_m3_01`
- command: installed default `scpp`
- observed version: `scpp 0.1.36`
- repo root used by the tool:
  - `/home/alexv/__AI/simple_cpp/stable`

## Scope

Projects checked:

- `base`
- `tools/hash_probe`
- `tools/h2b_types_to_om3`
- `tools/foreach_mixed_repro`
- `tools/inherited_nullable_vector_repro`
- `tools/inherited_nullable_vector_repro_multi`
- `tools/verify_model_loader`
- `tools/legacy_orm_first_node_repro`
- `tools/orm_runtime_repro`

## High-Level Result

Standalone strict tools still build successfully:

- `tools/hash_probe`
- `tools/h2b_types_to_om3`
- `tools/foreach_mixed_repro`
- `tools/inherited_nullable_vector_repro`
- `tools/inherited_nullable_vector_repro_multi`

The failures were concentrated around the `base` entry project and tools that depend on `base`:

- `base`
- `tools/verify_model_loader`
- `tools/legacy_orm_first_node_repro`
- `tools/orm_runtime_repro`

## Issue 1: entrypoint lowering regression in `base`

### Symptom

`scpp build` for `base` compiles object files but fails at final link with:

```text
mold: error: undefined symbol: main
>>> referenced by /usr/lib/x86_64-linux-gnu/Scrt1.o:(.text)
>>>               /usr/lib/x86_64-linux-gnu/Scrt1.o:(_start)
```

### Repro

```bash
cd base
scpp build
```

### What makes this look like a Simple C++ regression

The source entry file is normal top-level strict code in `base/main.phs`. It does not contain unsupported syntax, and other entry files with top-level code still build correctly under the same `scpp` version.

Passing comparison:

- `tools/hash_probe/main.phs`

That file has:

- a namespace declaration
- class declarations
- top-level executable statements

and `scpp build` emits a proper generated C++ entrypoint with:

- `scpp::om3::tools::hash_probe::__scpp_main()`
- a real global `int main(...)`

### Generated-output evidence

For `base`, generated C++ at:

- [base/.prism/generated/main.cpp](/home/alexv/__AI/open_m3/open_m3_01/base/.prism/generated/main.cpp:1)

contains only:

- `int __scpp_unit_952d61615694()`

and no emitted global `main(...)`.

The compiled object confirms that shape:

```bash
nm -C base/.prism/build/main.o | rg 'main|__scpp_unit'
```

Observed symbols:

- `scpp::__scpp_unit_952d61615694()`
- no `main`

By contrast, the passing `hash_probe` object contains:

- `scpp::om3::tools::hash_probe::__scpp_main()`
- `main`

### Why this matters

This turns a valid strict entry project into an unlaunchable executable even though code generation and compilation otherwise succeed.

### Suggested upstream issue framing

Possible title:

- `strict entrypoint regression: top-level main.phs lowered to __scpp_unit instead of emitting main on scpp 0.1.36`

Suggested repro package:

- failing project: `base`
- passing contrast: `tools/hash_probe`
- include generated `main.cpp` and `nm -C` symbol output from both

## Issue 2: dependency artifact resolution failure for projects depending on `base`

### Symptom

Projects that depend on `../../base` fail before link/compile with Ninja reporting missing dependency objects under the synthetic `__deps` tree.

Observed failure:

```text
ninja: error: '../../../../base/.prism/build/__deps/cfdf4685774c9b30aa9f77d52536d5be/db/column.o', needed by 'main', missing and no known rule to make it
```

Affected projects in this pass:

- `tools/verify_model_loader`
- `tools/legacy_orm_first_node_repro`
- `tools/orm_runtime_repro`

### Repro

```bash
cd tools/verify_model_loader
scpp build
```

Equivalent failures were observed in:

```bash
cd tools/legacy_orm_first_node_repro
scpp build

cd tools/orm_runtime_repro
scpp build
```

### Important context

`base` had already produced normal local objects directly under:

- `base/.prism/build/db/*.o`
- `base/.prism/build/orm/*.o`
- `base/.prism/build/schema/*.o`

But the dependent project Ninja file expects them under:

- `base/.prism/build/__deps/<hash>/...`

That expected tree was not present.

This may be downstream fallout from Issue 1, but it is still worth tracking explicitly because the dependent-project failure mode is opaque and looks like a separate dependency materialization problem from the perspective of a tool consumer.

### Suggested upstream issue framing

Possible title:

- `strict dependency build expects missing __deps object tree when dependency entry project fails to link`

Suggested note:

- if this is intended fallout from a failed dependency executable build, the tool should surface that dependency root cause directly instead of only reporting missing `__deps/.../*.o` paths

## Command Results Summary

Successful `scpp build`:

- `tools/hash_probe`
- `tools/h2b_types_to_om3`
- `tools/foreach_mixed_repro`
- `tools/inherited_nullable_vector_repro`
- `tools/inherited_nullable_vector_repro_multi`

Failed `scpp build`:

- `base`
- `tools/verify_model_loader`
- `tools/legacy_orm_first_node_repro`
- `tools/orm_runtime_repro`

## Repo-Side Conclusion

This pass did not point to a broad strict-syntax regression across Open M3.

The evidence is more specific:

1. one `main.phs` entry project is being lowered incorrectly and loses its executable `main`
2. dependent projects then fail looking for dependency objects in a missing `__deps` tree

Because multiple standalone strict tools still build successfully on the same install, the current evidence leans toward a targeted Simple C++ regression in entrypoint/dependency handling rather than a general Open M3 source-shape problem.
