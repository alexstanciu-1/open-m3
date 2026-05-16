# SimpleC++ Typed-Flow Cleanup Report

Date: 2026-05-16

## Scope

This pass removed only conservative strict-mode carry-over patterns where the source was already strongly typed.

Rules used:

- remove compatibility casts only where the source is already typed
- prefer direct `foreach` keys/values from typed `hash<...>` collections
- prefer the `foreach`-provided typed value instead of re-indexing the same hash again
- do not change raw `json_decode(...)` / mixed-data boundary normalization

## Files Updated

### Shared base code

- `base/json_loader.phs`
  - removed cast on typed `foreach` key in `attach_storage(...)`
  - removed re-indexing of typed `foreach` value in `attach_storage(...)`

- `base/model_assembler.phs`
  - removed re-indexing of typed `foreach` values in traversal/debug assembly paths
  - removed cast on typed `foreach` key in `clone_property(...)`
  - removed re-indexing of typed `foreach` values in `merge_property(...)`
  - removed re-indexing of typed override properties in `refine_sub_path(...)`

- `base/db/structure_builder.phs`
  - removed re-indexing of typed `foreach` values in `build_from_orm_root(...)`
  - removed cast/re-indexing of typed child property iteration in `inline_sub_columns(...)`
  - removed re-indexing of typed table/column/index iteration in `print_database(...)`

### Tool / repro code

- `tools/hash_probe/main.phs`
  - removed typed loop-local workaround and used the typed `foreach` value directly

- `tools/verify_model_loader/orm_audit_sample.phs`
  - removed re-indexing of typed table and column iteration helpers

- `tools/legacy_orm_m2m_repro/main.phs`
  - removed re-indexing of typed relation-table column iteration

- `tools/relation_reverse_m2m_repro/main.phs`
  - removed re-indexing of typed relation-table column iteration

## Explicit Non-Changes

The following were intentionally left alone:

- casts at raw `json_decode(...)` boundaries
- explicit normalization from legacy arrays/maps into typed schema objects
- mixed/nullability-sensitive source shapes not already proven safe by current `scpp`

These remain pending clearer upstream guidance, especially from:

- issue `#112` on mixed JSON boundary guidance
- issue `#113` on preferred nullable guard style

## Validation

All touched code rebuilt successfully after the cleanup.

Validated with:

- `scpp build --build-dependencies` in `tools/verify_model_loader`
- `scpp build --build-dependencies` in `tools/legacy_orm_m2m_repro`
- `scpp build --build-dependencies` in `tools/relation_reverse_m2m_repro`

Result:

- no reversions were needed
- no new build or link failures were introduced by this cleanup pass

## Outcome

This cleanup reduces historical strict-mode noise in OpenM3 while keeping the mixed-data boundaries explicit and conservative.

The repo is now relying more directly on current `scpp 0.1.42` typed `foreach` behavior in the places where the source type is already known.
