# Schema Diff Performance Report

Status: active investigation

Date: 2026-05-18

## Goal

Reduce legacy-vs-new ORM DB schema generation to a few seconds by:

1. avoiding repeated metadata reads
2. caching where the legacy ORM caches
3. narrowing traversal so the all-types pass only visits direct properties

## Changes Made

### Metadata / lookup reuse

In [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:1):

- added `raw_models_by_key`
- added `assembled_models_by_key`
- added `assembled_model_entry_index`
- added `legacy_type_maps`
- added `legacy_children_by_parent`

This means:

- raw model lookup is no longer a vector scan
- assembled model lookup is no longer a vector scan
- the legacy `types_json` directory is loaded once per assembler instance
- parent-to-children inheritance expansion no longer rescans the full type map each time

### Legacy-style semantic caches

Also in [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:1):

- added `legacy_instantiable_types_by_type`
- added `legacy_visible_properties_by_type`

These are the clean OpenM3 equivalents of the memoized behavior seen in legacy `QModelProperty` / `QModelType`.

### Traversal narrowing

- the all-types pass now uses `build_legacy_orm_root(..., 1)`
- when `max_depth = 1`, the legacy root builder no longer:
  - hydrates visible child properties for the next level
  - enqueues deeper traversal entries

This makes the all-types pass truly “direct properties only”.

## Benchmark Tool

Created:

- [tools/schema_diff_benchmark/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/schema_diff_benchmark/main.phs:1)

Purpose:

- measure the main schema-build phases without the huge compare output
- stream progress so we can see where time is actually spent

## Effective Timing Snapshot

Measured with:

```bash
timeout 10s stdbuf -o0 ./.prism/build/main
```

in:

- [tools/schema_diff_benchmark](/home/alexv/__AI/open_m3/open_m3_01/tools/schema_diff_benchmark:1)

Observed output after the cache + shallow-traversal pass:

```text
phase:app_root:start
phase:app_root:done:1.006516
phase:list_types:start
phase:list_types:done:0.003532:121
phase:begin_db:start
phase:begin_db:done:0.000121
phase:shallow_types:start
phase:shallow_types:progress:0/121
phase:shallow_types:first_loop:after_type_name:0:Omi/Address
phase:shallow_types:first_loop:before_root_compare:0:Omi/App
phase:shallow_types:first_roots:build_start:Omi/Address
phase:shallow_types:first_roots:build_done:Omi/Address:0.005988
phase:shallow_types:first_roots:nodes:Omi/Address:18
phase:shallow_types:first_roots:append_start:Omi/Address
```

## Current Interpretation

The timing result is now much clearer than before:

- `App` root build is fast: about `1.01s`
- listing instantiable types is effectively free: about `0.004s`
- DB initialization is effectively free
- the slowdown is not in shallow root construction:
  - first shallow root build for `Omi/Address` is about `0.006s`
- the first shallow root is small:
  - `Omi/Address` shallow root contains `18` ORM nodes
- despite that, execution still does not finish the first append within `10s`

So the current dominant cost is now strongly isolated to:

- `structure_builder->append_orm_root_to_database(...)`

and more specifically to work performed after:

- shallow root construction
- file/type metadata loading
- instantiable type listing

This means the current dominant cost has shifted away from:

- file rereads
- type lookup scans
- descendant expansion scans

to:

- DB schema append/materialization for shallow roots

## Effective Time Spend So Far

Based on the measured probe:

- metadata loading and normalization: no longer dominant
- model lookup / raw assembled-model lookup: no longer dominant
- instantiable descendant expansion: no longer dominant
- `App` root assembly: acceptable
- first shallow type-root assembly: acceptable
- first shallow type-root append: currently the blocker

In other words, the current report runtime is being spent overwhelmingly in the schema append path, not in traversal setup.

## Traversal Status

The all-types traversal is now intentionally shallow:

- all instantiable types use `build_legacy_orm_root(..., 1)`
- when `max_depth = 1`, the legacy root builder does not enqueue deeper child traversal

So the all-types pass is already in the intended “direct properties only” mode.

The `App` pass is still full traversal, not yet “customized paths only”.

## Compare Tool Status

[tools/schema_diff_report/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/schema_diff_report/main.phs:1) is cleaned back up and builds successfully.

It is still too slow to finish quickly, but the benchmark above shows that the next hotspot to inspect is the schema-builder append path, not model loading.

## Legacy Comparison

Legacy ORM caches:

- inheritance expansion answers
- per-property instantiable type answers
- per-type/per-property derived storage names
- table/id/type column naming

OpenM3 now matches part of that behavior, but not all of it.

The next likely cache candidates, if still needed after builder inspection, are:

- shallow legacy roots by type
- route/materialization results by property signature

## Next Step

Inspect:

- [base/db/structure_builder.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/structure_builder.phs:1)

with focus on:

- `append_orm_root_to_database(...)`
- per-root repeated full passes over `root->nodes`
- repeated work inside `apply_orm_node_materialization(...)`
- any hidden expensive path between shallow root construction and first append completion
- table lookup/reuse only if it turns out to be non-hash-backed in a nested path
