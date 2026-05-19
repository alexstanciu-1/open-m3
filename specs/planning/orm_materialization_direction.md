# Open M3 ORM Materialization Direction

Status: current implementation note

Purpose: describe how the new ORM currently turns model metadata into in-memory DB structure, using the verified OpenM3 flow rather than the older legacy internals.

This note is about:

- model to ORM planning
- ORM planning to DB structure
- identity and ownership rules

This note is not about:

- SQL sync/apply
- query planning
- CRUD merge/hydration

## Why This Note Exists

The legacy H2B ORM is still useful for extracting rules, but it mixes too many concerns in one place:

- type/property interpretation
- inheritance expansion
- storage naming
- table/column creation
- DB sync

The new ORM direction is to keep those concerns separated:

1. load raw metadata
2. assemble effective ORM nodes and materialization routes
3. build internal DB structure from those routes
4. only later compare/apply to a database

The aim is not to mimic the legacy code layout.

The aim is to keep the new flow explicit, path-aware, and easier to reason about.

## The Current Two-Layer Flow

The verified current flow is:

1. `json_loader`
   - loads raw metadata into typed OpenM3 structures

2. `model_assembler`
   - builds an `orm_root`
   - expands visible types
   - decides one or more `orm_mat` routes per visible node

3. `structure_builder`
   - reads the `orm_root`
   - resolves final table/column identities
   - creates in-memory `db_database`, `db_table`, `db_column`, `db_index`

So the practical contract is:

- `model_assembler` answers: what storage route does this visible path use
- `structure_builder` answers: what actual schema objects does that route create or reuse

## The Main Runtime Structures

The current materialization path is centered on:

- [base/orm/root.phs](/home/alexv/__AI/open_m3/open_m3_01/base/orm/root.phs:1)
- [base/orm/node.phs](/home/alexv/__AI/open_m3/open_m3_01/base/orm/node.phs:1)
- [base/orm/mat.phs](/home/alexv/__AI/open_m3/open_m3_01/base/orm/mat.phs:1)

Important fields:

- `orm_root`
  - root path/type
  - full discovered node list
  - optional root entry type column

- `orm_node`
  - visible path
  - `branch_kind`
  - `type_models`
  - one or more `mat[]` entries

- `orm_mat`
  - materialization mode
  - target table or link table
  - owner/ref/value/type column identities
  - target type list

That means the current materialization unit is:

- one visible node
- with zero or more concrete materialization routes

## High-Level Rule

A visible path does not create schema by itself.

It must first resolve to:

- a storage identity
- a storage mode
- an ownership role

Only then can the schema builder create or reuse DB objects.

This is why the current implementation distinguishes:

- type table identity
- relation/helper table identity
- path identity

Path identity alone is not storage identity by default.

## Root Strategy

The current schema verification flow uses two phases:

1. all instantiable stored types first
   - shallow traversal only
   - direct properties only
   - used to ensure standalone type tables and direct property-driven helper structures are discovered

2. `Omi\App` second
   - full business graph traversal
   - uses the same table/relation registries
   - fills in the app-root-owned paths, relations, and helper structures

This was chosen because legacy schema coverage is not fully reachable from `App` alone.

Important implementation direction:

- type roots should contribute type tables
- property semantics should contribute helper/relation tables

Not:

- every reachable path invents its own table

## Traversal Inputs

The materialization planner currently uses these inputs:

- current path
- current effective property data
- parent type data
- expanded target type list
- legacy/OpenM3 storage metadata
- root-vs-non-root context
- list-vs-singular shape
- model-target-vs-scalar-target shape

This happens mainly in:

- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:744)
- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:843)
- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:1254)

## Materialization Modes

The current important `orm_mat.mode` values are:

- `value_column`
- `ref_column`
- `type_table`
- `one_to_many`
- `collection_table`
- `join_table`

These should be read as follows.

### `value_column`

Meaning:

- scalar data stored on an existing owner table

Schema effect:

- create or reuse a scalar column on the target table

Examples:

- plain scalar properties
- scalar helper-table values when the relation/helper table already exists

### `ref_column`

Meaning:

- singular reference stored on an existing owner table

Schema effect:

- create or reuse an integer ref column
- optionally add a companion `$_type` column for polymorphic refs

Important rule:

- the target model may still have its own type table
- `ref_column` is about where the reference lives, not where the target rows live

### `type_table`

Meaning:

- use the target model’s own type table

Schema effect:

- ensure that target type table exists
- attach columns there as required by the route

This is usually used for:

- reusable concrete type storage
- not for synthetic helper/relation tables

### `one_to_many`

Meaning:

- the relation lives on the child/target table through an owner/backreference column

Schema effect:

- reuse/create the child type table
- add the owner/backreference column there
- no helper table

Important current rule:

- the implicit default `one_to_many` behavior is only allowed for real `App` root model collections
- non-App shallow type roots must not overuse this default

That rule is important for avoiding collapse of legitimate helper tables.

### `collection_table`

Meaning:

- the relation/value collection needs its own helper table

Schema effect:

- create/reuse a dedicated helper table
- add owner column
- add either:
  - ref column for collected model targets
  - scalar value column for scalar collections
- optionally add type column

Important distinction:

- this does not replace the target type table
- it exists in addition to it when collected items are models

Examples:

- scalar collections
- legacy helper-table model collections
- explicit collection storage

### `join_table`

Meaning:

- canonical many-to-many relation table

Schema effect:

- create/reuse one shared relation table
- add left/right relation columns
- optionally add type column

Important rule:

- many-to-many creates a relation table in addition to the target type tables
- reverse sides must reuse the same relation identity

## How The Planner Decides

In practical terms, the planner currently decides using this order of ideas:

1. Is the property stored at all?
2. Is it scalar, singular ref, singular sub, list of scalars, or list of models?
3. Is there explicit collection/relation metadata?
4. Is there explicit `manyToMany`?
5. Is there explicit `oneToMany`?
6. Is this one of the legacy helper-table collection cases?
7. Is this an App-root default collection that should behave as `one_to_many`?
8. Does the route need a polymorphic type column?

This is all encoded in the legacy-import/materialization path in:

- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:1254)

## Polymorphic Type Columns

The current verified rules are:

### Property-level `$_type`

Add a property type column when:

- the property targets models
- and either:
  - the route has multiple concrete target types
  - or the declared target type is abstract

Example:

- `Orders_Items.$Config$_type`

This is a property-level rule.

### Table-entry `$_type`

Add a root/table-level `$_type` column when:

- multiple concrete classes share the same storage table

Examples:

- `$Users.$_type`
- `Reverse_APIs.$_type`

This is a table-entry rule, not the same as property-level polymorphism.

## Owner-Column Rules

The schema builder must not derive owner columns only from target type names.

The current verified rules are:

1. App-owned synthetic owner columns use the actual `App` property name
   - example:
     - `Favorite_Order_Email.$$App$Favorite_Order_Emails`
   - not:
     - `Favorite_Order_Email.$$App$Favorite_Order_Email`

2. Nested `one_to_many` branches use the immediate parent primary table when that is the real owner source

3. Boolean `oneToMany = true` is a relation flag, not a literal owner-column name
   - this avoids invalid outputs like:
     - `Rate_Plans.$1`

4. Singular model refs with `oneToMany` metadata may still be owner-table ref columns
   - example:
     - `$Users.$Mail_Sender`
     - `Companies.$Mail_Sender`

So the final owner/ref column shape depends on:

- route mode
- root-vs-nested context
- immediate owner table
- actual property name from the path

Not only on the target type/table.

## Identity Reuse Rules

The schema builder keeps shared registries for:

- primary tables by path
- suppressed synthetic helper tables
- relation identities

This is what allows:

- all-types pass
- then `App` pass
- into one shared in-memory schema

without recreating parallel schema objects.

Important verified rules:

1. canonical reused type tables must not be renamed into `parent_child` path tables
2. synthetic root helper suppression must not block a real class table of the same name
3. relation identities must be reused across reverse/shared relation paths

These rules are implemented mainly in:

- [base/db/structure_builder.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/structure_builder.phs:1)

## Legacy-Specific Rules We Keep

The current new ORM still intentionally preserves some legacy-specific behavior because it is necessary for schema parity:

- helper-table model collections
- scalar collections always getting a helper table
- abstract-target shared storage with `$_type`
- App-root default `one_to_many` collection behavior
- legacy owner/backref naming conventions

These are compatibility rules.

They should be documented explicitly rather than hidden in ad hoc code paths.

## What The DB Builder Actually Creates

The current builder creates in-memory:

- `db_database`
- `db_table`
- `db_column`
- `db_index`

It does not talk directly to MySQL during this phase.

So “build DB structure” currently means:

- create and merge schema objects in memory

not:

- emit SQL
- sync a live database

That work happens from:

- [base/db/structure_builder.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/structure_builder.phs:1)

## Verified Current Result

With the current filtered comparison scope:

- missing in-scope tables: `0`
- extra in-scope tables: accepted/out-of-scope only
- missing in-scope columns: `0`
- extra in-scope columns: `0`
- in-scope type mismatches: `0`

Reference status note:

- [new_orm_vs_legacy_schema_diff_2026_05_19.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/new_orm_vs_legacy_schema_diff_2026_05_19.md:1)

## What Still Belongs Elsewhere

This document intentionally does not try to fully specify:

- query planning
- hydration/reverse mapping contracts
- CRUD merge rules
- DB sync/apply

Those should stay in separate focused documents.

## Recommended Reading

For the closely related relation-specific rules:

- [openm3_relation_rule_sheet.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/openm3_relation_rule_sheet.md:1)

For the current parity/result snapshot:

- [new_orm_vs_legacy_schema_diff_2026_05_19.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/new_orm_vs_legacy_schema_diff_2026_05_19.md:1)
