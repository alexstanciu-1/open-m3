# Open M3 ORM Schema Update Direction

Status: current working direction

Purpose: define how Open M3 should move from:

- desired in-memory DB structure

to:

- reading the current live schema
- computing schema update operations
- separating safe execution from proposal-only destructive changes

This note is about:

- schema introspection
- schema diffing
- update operation classification
- execution safety policy

This note is not about:

- model/materialization planning
- query planning
- runtime CRUD behavior

## Current Implementation Status

The first full schema-update slice is now implemented for the MySQL/MariaDB lane.

Implemented pieces:

- desired schema build into `db_database`
- live MySQL/MariaDB schema read into `db_database`
- explicit `schema_update_plan`
- executable vs proposal-only operation split
- SQL emission for both full-create and update-plan flows
- H2B compatibility policy for legacy-parity comparison

Main code entry points:

- [mysql_schema_reader.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/mysql_schema_reader.phs:1)
- [schema_differ.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/schema_differ.phs:1)
- [schema_update_sql_emitter.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/schema_update_sql_emitter.phs:1)
- [schema_live_update_probe/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/schema_live_update_probe/main.phs:1)
- [h2b_compatibility_policy.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/h2b_compatibility_policy.phs:1)

Current verified H2B legacy result:

- `current_tables=188`
- `desired_tables=188`
- `executable_ops=0`
- `proposal_ops=0`
- `warnings=0`
- `unsupported=0`

## Why This Note Exists

The current OpenM3 ORM can already build a desired in-memory schema:

- `db_database`
- `db_table`
- `db_column`
- `db_index`

That is the correct first step.

But SQL emission alone is not enough for a real ORM workflow.

The ORM must also:

1. read the current schema from the target database
2. normalize it into the same internal relational shape
3. compare current vs desired
4. classify the resulting operations by safety
5. execute only the allowed operations
6. keep destructive operations as proposals unless explicitly approved later

## Core Direction

OpenM3 should not jump directly from:

- desired schema

to:

- `ALTER TABLE ...`

Instead it should use a three-schema view:

1. desired schema
   - what the ORM wants after materialization

2. current schema
   - what the target database currently contains

3. schema update plan
   - explicit operations needed to move current toward desired

This keeps SQL generation as the final step, not the planning step.

## High-Level Flow

The intended flow is:

1. load model/storage metadata
2. build ORM/materialization routes
3. build desired `db_database`
4. introspect current DB schema into another `db_database`
5. diff desired vs current
6. produce `schema_update_plan`
7. split operations into:
   - safe executable operations
   - proposal-only destructive operations
8. emit SQL from the update plan
9. execute only the safe executable operations unless an explicit higher-level mode says otherwise

## The Main Principle

The ORM should compare normalized structure objects, not raw SQL text.

That means:

- DB introspection should produce `db_*` structures
- ORM materialization should produce `db_*` structures
- diffing should compare those structures directly

This avoids coupling the diff logic to any one SQL dialect string format.

## Current Schema Read Layer

OpenM3 should add a schema reader layer that maps live DB metadata into:

- `db_database`
- `db_table`
- `db_column`
- `db_index`
- later: `db_reference`

For MySQL/MariaDB, this should read at least:

- tables
- columns
- indexes
- table engine
- charset
- collation
- comments

The current legacy ORM does this with:

- `SHOW FULL COLUMNS`
- `SHOW INDEX`
- `SHOW TABLE STATUS`

OpenM3 does not need to copy those exact calls forever, but the first MySQL/MariaDB reader may use the same practical approach.

The current implementation does use this practical approach.

## Schema Identity Rules

The diff must compare using normalized schema identity, not only names in isolation.

Main identities:

- database name
- table name
- column name within table
- index name within table

Important note:

- the current desired schema builder should stay responsible for deciding what the desired names are
- the schema reader should only describe what exists now

The diff layer should not invent new naming rules.

## Desired Diff Output

OpenM3 should not hide changes inside transform flags alone.

It should produce explicit update operations.

Minimum useful operation families:

- `create_table`
- `update_table_options`
- `add_column`
- `modify_column`
- `add_index`
- `modify_index`
- `drop_index`
- `drop_column_proposal`
- `drop_table_proposal`

Later, when references are added:

- `add_foreign_key`
- `modify_foreign_key`
- `drop_foreign_key_proposal`

## Safe vs Proposal-Only Policy

This is the main OpenM3 policy for the first schema-update direction.

### Safe executable operations

These may be emitted as executable SQL by default:

- `create_table`
- `update_table_options`
- `add_column`
- `modify_column`
  - only when the system considers the change safe enough under the chosen dialect policy
- `add_index`
- `modify_index`
- `drop_index`

These are still subject to future safety refinement, but they belong in the executable class by default.

### Proposal-only destructive operations

These must not be auto-executed by default:

- `drop_table`
- `drop_column`
- `drop_database`

In OpenM3, these should appear only as:

- proposal records
- report output
- optional manual-review SQL text

Not as default executed operations.

This rule is stronger and cleaner than the legacy behavior.

## Important Design Choice

A destructive proposal should still be a first-class operation object.

That means OpenM3 should not ignore missing current objects on one side of the diff.

Instead it should say clearly:

- this table exists in current but not in desired
- proposed action: `drop_table_proposal`

and:

- this column exists in current but not in desired
- proposed action: `drop_column_proposal`

This preserves visibility without risking silent destructive execution.

## Recommended Plan Structure

The update result should likely be a typed object such as:

- `schema_update_plan`

with separate collections such as:

- executable operations
- proposal-only operations
- warnings
- unsupported differences

This makes it easy to:

- print a human report
- emit SQL
- execute safe updates
- fail clearly when a diff cannot be safely classified

## First MySQL/MariaDB Scope

The first update-planning slice should support:

- table presence diff
- column presence diff
- basic column definition diff
  - type
  - nullability
  - unsigned
  - auto increment
  - charset
  - collation
  - comment
- index presence diff
- table option diff
  - engine
  - charset
  - collation
  - comment

The first slice does not need to solve every advanced case before being useful.

For the H2B compatibility lane, the current policy now treats these as non-semantic unless explicitly authored:

- engine drift
- charset drift
- collation drift
- comment drift
- MySQL integer display width drift
- implicit `varchar(255)` drift

It also intentionally avoids SQL uniqueness by default:

- legacy `storage.index = unique` is currently normalized to a plain non-unique index
- future uniqueness behavior should be ORM-level policy, not automatic `UNIQUE KEY` emission

## Recommended First Safety Rule For Column Changes

For the first implementation, `modify_column` should stay conservative.

Good first direction:

- allow clearly additive or metadata-safe changes
- flag risky narrowing/destructive changes as proposals or warnings instead of auto-executing them

Examples of changes that may need warning/proposal treatment:

- smaller varchar length
- nullable to not-null without safe default strategy
- type family narrowing
- enum value removals

So “modify column” should not mean “blindly execute any change”.

It should mean:

- classify
- execute if safe
- otherwise surface as proposal/warning

## Relationship To SQL Emission

SQL emission should read:

- desired schema for full-create workflows
- update plan for live-schema-update workflows

Those are different outputs.

That means OpenM3 should keep separate emit paths for:

1. full schema create
2. schema update plan execution/proposal

This keeps the update logic from collapsing back into raw table creation code.

## Relationship To Legacy ORM

The legacy ORM already has an important useful shape:

1. read current table from DB
2. build/adjust in-memory table objects
3. detect change state
4. emit sync SQL

OpenM3 should keep the good part:

- compare normalized in-memory structures

But improve the weak parts:

- make the diff operations explicit
- separate executable vs proposal-only changes
- do not auto-run destructive operations by default

## Suggested Implementation Layers

The likely clean layering is:

1. `structure_builder`
   - builds desired `db_database`

2. `schema_reader`
   - builds current `db_database` from a live connection

3. `schema_differ`
   - compares desired vs current
   - returns `schema_update_plan`

4. `schema_sql_emitter`
   - emits SQL from:
     - either full desired schema
     - or update operations

5. `schema_applier`
   - executes only allowed executable operations

## Open Questions

Still to decide:

- exact operation class layout
- exact rule set for safe vs risky `modify_column`
- whether index drops stay executable by default or become proposal-only in some modes
- how to represent rename detection vs add+drop
- whether comments are part of parity for every dialect

## Main Goal

The goal is:

- read current schema
- compute explicit update operations
- execute safe forward changes
- never auto-execute destructive schema removals by default

That gives OpenM3 a safer and clearer schema-update model than the legacy ORM while keeping the same useful “current vs desired relational model” foundation.
