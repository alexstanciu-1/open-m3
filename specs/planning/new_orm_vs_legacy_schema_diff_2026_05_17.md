# New ORM vs Legacy Schema Diff

Date: 2026-05-17

## Purpose

Quick current-state comparison between:

- legacy H2B schema extracted from `specs/planning/legacy_sql_dumps/h2b_demo_2026-05-07_dev.sql`
- current OpenM3 generated schema from `tools/verify_model_loader`

This is a diff/status note, not a normative spec.

## Snapshot Method

Legacy side:

- `php tools/legacy_sql_to_tsv/export_legacy_schema_tsv.php specs/planning/legacy_sql_dumps/h2b_demo_2026-05-07_dev.sql /tmp/openm3_legacy_schema`

New ORM side:

- `scpp build --build-dependencies && ./.prism/build/main` in `tools/verify_model_loader`

Compared:

- table names
- column keys (`table + column`)
- exact column type strings where the same column key exists on both sides

## Headline Counts

Legacy:

- `190` tables
- `1358` columns

Current new ORM:

- `189` tables
- table-level extra count currently `0`

Common coverage:

- `189` common table names

Current diff counts:

- `1` legacy table missing from new ORM
- `0` extra tables in new ORM
- `343` legacy column keys missing from new ORM
- `170` extra column keys in new ORM
- `588` shared-column type mismatches

`Sessions_Data_` is not part of the ORM model graph. It comes from framework/runtime session storage and should be treated outside ORM parity scope.

That means effective ORM table parity is now:

- `0` missing ORM tables
- `0` extra ORM tables

## What Improved

The specific root one-to-many over-generation we were focused on is now improved.

Current `mat` output:

- `Omi/App.Addresses -> mode=one_to_many, table=Addresses`
- `Omi/App.Users -> mode=one_to_many, table=$Users`
- `Omi/App.Properties -> mode=one_to_many, table=Properties`
- `Omi/App.Offers -> mode=one_to_many, table=Offers`

This is closer to legacy intent than the older helper-table-heavy behavior.

## Main Remaining Diff Categories

### 1. Still missing legacy collection/helper tables

Current missing table:

- `Sessions_Data_`

This is now effectively table-level parity from the `Omi\App` root. The `_h2b_model_` / instantiable-descendant fix recovered the `Room_Order_Item_Config` branch, including:

- `Room_Order_Item_Configs`
- `Room_Order_Item_Configs_Occupants`
- `Room_Occupants`

The scalar-collection helper-table fix also recovered cases such as:

- `$Users_Authorized_IPs`
- `Rooms_Occupancy_Beds_Setup_Age_Intervals`

### 2. Remaining column-level gaps are now the main diff

Representative missing legacy columns:

- `$GroupRelations.$Subject`
- `$GroupRelations_Groups.$$GroupRelations`
- `$GroupRelations_Groups.$Groups`
- `$UserGroups.$SelfUser`
- `$Users.$Access_Template`
- `$Users.$Cart`
- `$Users.$Favorite_Order`
- `$Users.$Language`
- `$Users.$Mail_Sender`
- `$Users.$Person`

Representative extra generated columns:

- `$GroupRelations_Groups.$GroupRelations`
- `$GroupRelations_Groups.Groups`
- `$UserGroups_Groups.$UserGroups`
- `$UserGroups_Groups.Groups`
- `$Users.$$App$$Users`
- `$Users.Access_Template`
- `$Users.Owner`
- `$Users.id`
- `$Users_Access.$Users`
- `$Users_Notifications.$Users`

These are mostly naming-policy differences:

- legacy often uses `$RefName` / `$$Owner`-style columns
- current ORM often uses normalized names without the exact legacy prefixing pattern
- some owner/backreference columns are still derived from current ORM conventions instead of exact legacy storage names

### 3. Scalar SQL typing still diverges broadly

Representative type mismatches:

- `$Users.Access_Level` legacy `enum` vs new `varchar`
- `$Users.Active` legacy `tinyint` vs new `varchar`
- `$Users.Type` legacy `enum` vs new `varchar`
- `API_Systems.Reverse_API_Default_Setup` legacy `text` vs new `varchar`
- `Account_Configurations.Active` legacy `tinyint` vs new `varchar`
- `Addresses.Latitude` legacy `float` vs new `varchar`

This is now the dominant remaining parity category.

### 2. Column naming/backreference mismatch is still large

Representative legacy-vs-new differences:

Legacy:

- `$GroupRelations.$Subject`
- `$Users.$Owner`
- `$Users.$Person`
- `$Users.$UI_Language`

New ORM:

- `$GroupRelations.$$App$Relations`
- `$Users.$$App$$Users`
- `$Users.$$App$Authorized_IPs`

This indicates the new ORM is still generating OpenM3/derived backreference columns in places where legacy uses a different ownership/reference convention.

### 3. Scalar typing is still much too broad

Representative shared-column type mismatches:

- `$Users.Access_Level` legacy `enum` vs new `varchar`
- `$Users.Active` legacy `tinyint` vs new `varchar`
- `Addresses.Latitude` legacy `float` vs new `varchar`
- `Addresses.Place_Mtime` legacy `datetime` vs new `varchar`
- `BNR_Rates.Rate` legacy `float` vs new `varchar`
- `Account_Configurations.Active` legacy `tinyint` vs new `varchar`

This is currently one of the biggest schema-quality gaps.

The new ORM is still collapsing many legacy scalar distinctions into generic `varchar`.

## Interpretation

The current state is better than the earlier “too many helper tables everywhere” phase, and the table-level shape is now effectively at ORM parity.

The schema gap now looks more like this:

1. the earlier path-shaped extra-table problem is removed
2. the `_h2b_model_` descendant-expansion gap is fixed enough for the missing `Room_Order_Item_Config` / `Room_Occupant` branch
3. scalar and model collection helper tables are now materializing correctly
4. `Sessions_Data_` is outside ORM scope
5. the remaining schema diff is now primarily column naming and scalar SQL typing

## Suggested Next Focus

The next comparison work should likely prioritize:

1. reference/backreference column policy:
   - align generated FK/owner column names to legacy storage conventions

2. scalar SQL type derivation:
   - recover legacy `tinyint`, `int`, `float`, `datetime`, `enum`, `text` instead of defaulting so often to `varchar`

3. then refresh the column diff after those two changes

## Temporary Diff Artifacts

Generated during this comparison under `/tmp`:

- `/tmp/openm3_legacy_schema/legacy_tables.tsv`
- `/tmp/openm3_legacy_schema/legacy_columns.tsv`
- `/tmp/openm3_generated_tables.txt`
- `/tmp/openm3_generated_columns.txt`
- `/tmp/openm3_tables_missing_from_new.txt`
- `/tmp/openm3_tables_extra_in_new.txt`
- `/tmp/openm3_columns_missing_from_new.txt`
- `/tmp/openm3_columns_extra_in_new.txt`
- `/tmp/openm3_column_type_mismatches.txt`

Current two-phase comparison artifacts:

- `/tmp/openm3_verify_output_two_phase.txt`
- `/tmp/openm3_generated_tables_two_phase.txt`
- `/tmp/openm3_generated_columns_two_phase.tsv`
- `/tmp/openm3_tables_missing_two_phase.txt`
- `/tmp/openm3_tables_extra_two_phase.txt`
- `/tmp/openm3_columns_missing_two_phase.tsv`
- `/tmp/openm3_columns_extra_two_phase.tsv`
- `/tmp/openm3_column_type_mismatches_two_phase.tsv`
