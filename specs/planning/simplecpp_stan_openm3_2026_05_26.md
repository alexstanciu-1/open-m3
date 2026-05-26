# SimpleC++ `0.1.62` STAN Open M3 Note

Status: active toolchain note

Date: 2026-05-26

Purpose:

- record the Open M3 `scpp 0.1.62` update snapshot
- capture the first Open M3 observations about the new STAN-backed build flow
- note the current actionable STAN findings after a first probe cleanup

## Installed Toolchain

Verified with `scpp --doctor` on 2026-05-26:

- `scpp 0.1.62`
- upstream repo root: `/home/alexv/__AI/simple_cpp/stable`
- upstream commit: `1b12c55fc561`
- `git_up_to_date_with_origin_main: yes`

Update command used:

- `scpp update`

Confirmed upstream release:

- `0.1.62`
- published 2026-05-25
- release page: [simplecpp v0.1.62](https://github.com/alexstanciu-1/simplecpp/releases/tag/v0.1.62)

## Main `0.1.62` Workflow Change

`scpp build` and `scpp run` now treat STAN as a normal pre-build check unless `--no-stan` is passed.

Current upstream migration notes also matter for Open M3:

- STAN is now part of the ordinary build path
- `--no-stan` is the explicit bypass when needed
- warm STAN reuse currently fingerprints only the root project `prism.json` plus root-project source files
- dependency-only edits are still a known early-release freshness limitation

## First Open M3 STAN Pass

Probe used:

- [tools/orm_writer_probe/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/orm_writer_probe/main.phs:1)

Initial observed effect:

- the first `0.1.62` build surfaced property-read failures in the probe before native compilation
- those failures came from reusing the same local name for different concrete loop item types in one function

First local cleanup applied:

- split loop locals by concrete meaning:
  - `read_group`
  - `write_group`
  - `sql_batch`
  - `link_batch`
  - `execution_statement`
  - distinct SQL-string loop locals
  - distinct bridge placeholder local

Result after that cleanup:

- `scpp build --build-dependencies` for `tools/orm_writer_probe` succeeds on `0.1.62`
- STAN no longer reports probe property-read failures for that function

## Current STAN Findings Worth Tracking

Current advisory `scpp stan` result for `tools/orm_writer_probe` still reports a small set of warnings that look real and useful:

1. local single-type discipline
   - `model_assembler::build_legacy_orm_root_from_map`
   - `orm_writer::build_row_signature_from_hash`
   - `orm_writer::extract_node_resolved_id`

2. typed-call boundary warning
   - `mysql_schema_reader::apply_column_type`
   - `substr()` length argument currently inferred as `result_or_false<int>` instead of plain `int`

These are good candidates for a follow-up strict/STAN cleanup pass.

## Practical Open M3 Takeaway

For Open M3, STAN already looks useful in two ways:

1. it catches strict local-type drift earlier, before C++ compilation
2. it rewards splitting mixed-purpose locals into clearly single-typed locals

That matches the existing Open M3 strict authoring direction and should be treated as part of normal probe validation going forward.
