# New ORM vs Legacy Schema Diff

Date: 2026-05-19
Toolchain: `scpp 0.1.51`

## Purpose

Fresh current-state comparison between:

- legacy H2B schema extracted from `specs/planning/legacy_sql_dumps/h2b_demo_2026-05-07_dev.sql`
- current OpenM3 generated schema from `tools/schema_diff_report`

This is a status note, not a normative spec.

## Snapshot Method

Legacy side:

- `php tools/legacy_sql_to_tsv/export_legacy_schema_tsv.php specs/planning/legacy_sql_dumps/h2b_demo_2026-05-07_dev.sql /tmp/openm3_legacy_schema_051`

New ORM side:

- `scpp build --build-runtime --build-dependencies && ./.prism/build/main > /tmp/openm3_schema_diff_report_columns13.txt` in `tools/schema_diff_report`

Compared:

- table names
- column keys (`table + column`)
- normalized column type strings where the same column key exists on both sides

## Scope Notes

These are currently treated as outside the effective ORM parity target for this comparison:

- `Sessions_Data_`
- `Early_Booking`
- `Facility`
- `Files`
- `Last_Minute`
- `Search_Check_Ins`
- `Search_Properties`
- `Search_Properties_Rate_Plans`
- `Search_Properties_Rooms`
- `Search_Standard`
- `Search_Standard_Locations`
- `Search_Standard_Properties`
- `Search_Standard_Property_Rooms`
- `Search_Standard_Rate_Plans`
- `Search_Standard_Rooms`
- `Cache_View`
- `Cache_Views`

## Current Effective Status

After excluding the accepted non-ORM / out-of-scope tables above:

- missing legacy column keys: `0`
- extra generated column keys: `0`
- shared-column type mismatches: `0`

So for the current in-scope ORM comparison, column parity is now clean too.

## What Improved In This Pass

### 1. Helper-table owner/backref naming

Two important naming fixes landed:

- helper collection owners now preserve legacy double-dollar parent refs where needed
  - example: `$Users_Authorized_IPs.$$Users`
  - instead of `$Users_Authorized_IPs.$Users`
- synthetic root-owner names now strip duplicate leading `$` on the property segment
  - example: `$Users.$$App$Users`
  - instead of `$Users.$$App$$Users`

This collapsed the major helper/backref naming family cleanly.

### 2. Singular model refs now plan as owner-table ref columns

Legacy singular refs such as:

- `Address.Country`
- `Address.County`
- `Property.Address`

were being defaulted to `type_table` in the legacy materialization probe, which caused us to materialize target types without planning the foreign-key column on the owner table.

That default was corrected to `ref_column`, and ref/value routing was pinned to the owner table for those modes.

### 3. Scalar SQL type propagation is now wired through

The legacy scalar type metadata was already being detected, but plain `value_column` routes were not actually attaching `scalar_sql_type` on the main route-map path.

That is now fixed, and examples like these now carry the correct SQL source type into the schema builder:

- `float`
- `datetime`
- `date`
- `time`
- `enum(...)`
- `TEXT`
- `DECIMAL(5,2)`

### 4. Final scalar-type normalization cleanup

The schema builder now preserves:

- `mediumtext`
- `longtext`

and normalizes legacy-mode plain `double` to `float` where that matches the legacy SQL surface.

### 5. Polymorphic type-column parity is now in place

The remaining true polymorphic/type-column cases from the previous pass are now handled with a clearer split:

- property-level type columns are emitted when the declared model property is abstract or genuinely multi-target
  - example: `Orders_Items.$Config$_type`
- table-entry `$_type` columns are emitted when multiple concrete classes share the same storage table
  - examples:
    - `$Users.$_type`
    - `Reverse_APIs.$_type`

That removed the last real `_type` parity gap in the current in-scope comparison.

### 6. Final owner-column naming parity

The last remaining ownership/naming families are now resolved too:

- App-owned synthetic owner refs now derive from the actual `App` property name
  - examples:
    - `Favorite_Order_Emails`
    - `Offer_Categories`
    - `Price_Profiles`
    - `Privacy_Policy_Pages`
- singular `oneToMany` metadata on model refs such as `Mail_Sender` no longer forces collection-style placement
- boolean `oneToMany = true` no longer leaks into owner-column naming as `$1`
- nested `one_to_many` branches now derive owner names from the immediate parent primary table, not always from the top-level `$App` root

## Current Column Result

There are no remaining in-scope column diffs after filtering the accepted non-ORM / out-of-scope tables:

- missing legacy column keys: `0`
- extra generated column keys: `0`
- shared-column type mismatches: `0`

## Runtime / Performance Status

The schema path remains fast enough for iteration:

- `tools/schema_diff_benchmark` total: about `1.37s`
- `App` root build: about `0.82s`
- shallow instantiable-type pass: about `0.49s`
- `App` append: about `0.06s`

So the major strict helper/runtime blocker is gone on `0.1.51`, and current work is correctness-focused rather than toolchain-blocked.

## Toolchain Note

While finishing this pass on `scpp 0.1.53`, a new strict compile regression appeared around:

- `php::microtime(true)`

That upstream issue is tracked here:

- [simplecpp issue #141](https://github.com/alexstanciu-1/simplecpp/issues/141)

OpenM3 currently carries a small temporary local workaround in [base/db/structure_builder.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/structure_builder.phs:1) so schema verification can continue while that upstream fix lands.

## Artifacts

Fresh generated artifact:

- `/tmp/openm3_schema_diff_report_columns13.txt`

Supporting timing checkpoint:

- `specs/planning/schema_diff_performance_report_2026_05_18.md`
