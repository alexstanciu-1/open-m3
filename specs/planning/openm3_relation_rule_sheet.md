# OpenM3 Relation Rule Sheet

Status: planning draft

Purpose: define the concrete relation materialization rules for OpenM3 so path-aware ORM traversal does not create redundant schema objects.

## Core Principle

A relation path does not create schema objects by itself.

A relation path must first resolve to:

- a `type identity`
- optionally a `relation identity`
- a `storage role`

Only the storage-owning side may create schema objects.

Reverse sides must reuse existing identities.

## Identity Types

- `type identity`: where target object rows live
- `relation identity`: where the relation itself lives, when it cannot live on the target type table
- `path identity`: semantic traversal identity only; not storage identity by default

## Storage Roles

- `owner`: allowed to create schema objects for that identity
- `reverse_view`: reuses an existing identity, creates nothing
- `inline`: materializes into parent table
- `none`: no schema materialization

## General Builder Rules

1. Resolve identity before deciding whether to create anything.
2. Check the registry for that identity.
3. If present, reuse it.
4. If absent and role is `owner`, create it.
5. If absent and role is `reverse_view`, do not create a parallel structure; this is a configuration/design error unless an owner path exists or can be inferred.
6. Path-specific storage must be explicit.

## One-to-Many Forward

Shape:

- parent has collection of child models
- child belongs to one parent

Resolved storage:

- `type identity`: child type table
- `relation identity`: none separate by default
- `storage role`: `owner`

Schema effect:

- child rows live in child type table
- relation lives on child table via owner/backreference column
- no collection table

Allowed creation:

- child type table, if not already present
- owner/backreference column on child type table, if not already present

Not allowed:

- synthetic helper/collection table just because the path is a collection

## One-to-Many Reverse

Shape:

- child exposes link back to parent
- or parent-facing reverse path exists semantically

Resolved storage:

- `type identity`: same child type table
- `relation identity`: none separate
- `storage role`: `reverse_view`

Schema effect:

- reuses existing child type table and owner/backreference column

Allowed creation:

- none by default

Not allowed:

- second table
- duplicate owner column
- mirrored helper structure

## Many-to-Many Forward

Shape:

- both sides have multiple related rows

Resolved storage:

- `type identity`: left/right target type tables
- `relation identity`: canonical shared relation table
- `storage role`: `owner`

Schema effect:

- target rows live in their own type tables
- relation rows live in one shared relation table

Allowed creation:

- relation table, if not already present
- its left/right reference columns
- optional discriminator/metadata columns if explicitly required

Not allowed:

- a second relation table for the same semantic relation from the same default identity

## Many-to-Many Reverse

Shape:

- reverse property/path for same many-to-many relation

Resolved storage:

- `type identity`: same target type tables
- `relation identity`: same canonical shared relation table
- `storage role`: `reverse_view`

Schema effect:

- reuses existing relation table

Allowed creation:

- none by default

Not allowed:

- second relation table from reverse direction
- duplicate mirrored schema

## Singular `struct.ref`

Shape:

- one object references another

Resolved storage:

- `type identity`: target type table exists independently
- `relation identity`: none separate
- `storage role`: `owner` for the parent-side reference column

Schema effect:

- parent table gets ref column
- target table is reused as target object storage

Allowed creation:

- parent ref column
- target type table only if not already present for object storage

Not allowed:

- collection/helper table

## Singular `struct.sub` Default

Shape:

- owned sub-structure, object-like

Resolved storage:

- `type identity`: target type table by default
- `relation identity`: none separate unless relation shape requires it
- `storage role`: `owner`

Schema effect:

- reuse/create target type table
- attach owner relationship there when needed

Allowed creation:

- target type table if not already present
- owner/reference columns needed to connect it

Not allowed:

- path-specific table unless explicit
- collection/helper table unless relation shape truly requires it

## Singular `struct.sub` Inline

Shape:

- explicit inline materialization

Resolved storage:

- `type identity`: none separate
- `relation identity`: none
- `storage role`: `inline`

Schema effect:

- child fields flatten into parent table

Allowed creation:

- parent columns only

Not allowed:

- child type table for that inline path
- relation table

## Path-Specific Dedicated Table

Shape:

- explicit new OpenM3 feature

Resolved storage:

- `type identity`: path-specific dedicated table
- `relation identity`: optional, depending on relation shape
- `storage role`: `owner`

Schema effect:

- path gets its own table because metadata explicitly asked for it

Allowed creation:

- dedicated path table
- required owner/reference columns

Not allowed:

- implicit inference from path alone

## Path-Specific Collection Table

Shape:

- explicit path-specific many-to-many or collection override

Resolved storage:

- `relation identity`: path-specific collection table
- `storage role`: `owner`

Schema effect:

- dedicated relation table for that path only because explicitly requested

Allowed creation:

- that explicit relation table

Not allowed:

- creating it by default just because the path is many-to-many

## Simpler Many-to-Many Declaration Direction

Purpose:

- avoid forcing authors to spell explicit collection table names in ordinary many-to-many declarations
- keep reverse-direction reuse clear and deterministic
- preserve explicit table naming as a lower-level override when needed

### Current Legacy Pattern

Legacy often uses:

- `manyToMany`
- plus explicit `collection`

Example shape:

- `@storage.manyToMany`
- `@storage.collection Properties_Store_Locations,Property,Store_Location`

Important meaning:

- `storage.collection` does not only say "use a collection table"
- it also provides the canonical shared relation identity
- the reverse side binds to that same identity so it does not create a second schema structure

### Proposed OpenM3 Direction

For ordinary many-to-many declarations, prefer a semantic reverse-property declaration instead of an explicit table string.

Example direction:

- `@storage.manyToMany Store_Locations`

Meaning:

- this property participates in a many-to-many relation
- the reverse property is `Store_Locations`
- the ORM must derive one canonical shared relation identity from the paired declarations

This should be treated as a higher-level authoring form than explicit `storage.collection`.

### Explicit `storage.collection` Remains Valid

`storage.collection` should remain available for:

- legacy compatibility
- explicit schema preservation
- custom relation table names
- custom relation column names

So the intended layering is:

- semantic declaration first
- explicit collection identity as override/fallback

### Canonical Identity Rule

For semantic many-to-many declarations:

- both sides must resolve to the same canonical relation identity
- that identity must not depend on traversal or processing order
- the builder must derive it before schema creation

This means OpenM3 must not rely on:

- "first processed side creates the table"
- "second processed side discovers and reuses it"

Instead it must:

1. identify the two paired relation properties
2. normalize the pair into one canonical relation identity
3. derive one canonical relation table name and relation columns
4. bind both sides to that same identity

### Validation Rules

For semantic many-to-many declarations:

- if both sides exist and agree, derive canonical relation identity automatically
- if only one side exists, do not silently invent an ambiguous reverse pairing
- if both sides exist but disagree, raise a planning/validation error

### Authoring Model

Recommended meaning:

- `storage.oneToMany X`
  - relation is owned through the child type table
  - `X` identifies the reverse/owner-side relation property meaning

- `storage.manyToMany X`
  - relation is owned through one canonical relation table
  - `X` identifies the reverse-side property meaning
  - table and column identity should be derived automatically unless explicitly overridden

- `storage.collection ...`
  - explicit storage identity override
  - use when exact table/column naming must be preserved or customized

### Planner Implication

The planner should treat:

- semantic reverse-property declarations
- and explicit collection identity declarations

as separate layers.

The intended priority is:

1. explicit storage override
2. semantic paired-declaration canonicalization
3. fallback derived naming

### Main Goal

Keep many-to-many authoring semantic and concise by default, while ensuring:

- reverse-direction reuse
- deterministic schema generation
- no duplicate relation tables
- no dependency on processing order

## Collection of Scalars

Shape:

- parent has many scalar values

Resolved storage:

- `type identity`: none
- `relation identity`: collection/value table
- `storage role`: `owner`

Schema effect:

- scalar values live in collection table with parent backreference

Allowed creation:

- collection table

Not allowed:

- pretending a scalar collection is a reusable type table

## Non-Stored / Query-Only

Resolved storage:

- `storage role`: `none`

Schema effect:

- none

Allowed creation:

- none

## Canonical Identity Guards

For one-to-many:

- canonical storage is usually the child type table plus owner column
- reverse paths must bind to that identity

For many-to-many:

- canonical storage is one shared relation-table identity
- reverse paths must bind to that identity

For path-aware OpenM3:

- path may refine storage identity only when explicit metadata says so
- otherwise path must bind to canonical reusable identities

## Practical "Do I Create Something?" Rule

When builder hits a relation node:

1. Resolve `type identity`
2. Resolve `relation identity` if relation needs one
3. Resolve `storage role`
4. If role is `reverse_view`, create nothing
5. If role is `inline`, create only parent columns
6. If role is `owner`, create only missing schema objects for the resolved identities
7. Never invent a path-owned table unless explicitly requested

## What This Prevents

Examples like:

- `$App_Addresses`
- `$App_Users`
- `$App_Properties`
- `$App_Offers`

should not appear when:

- the real storage already fits in the target type table
- and the relation can be represented by owner/backreference columns there

Those paths are semantic paths, not automatic storage identities.

## Implementation Checklist

Purpose: reduce the rule sheet into the smallest practical checklist for the current OpenM3 implementation.

Primary code paths:

- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs)
- [base/db/structure_builder.phs](/home/alexv/__AI/open_m3/open_m3_01/base/db/structure_builder.phs)

### A. Materialization Classification In `model_assembler`

Checklist:

- ensure path identity is not treated as storage identity by default
- ensure each relation node resolves:
  - `type identity`
  - optional `relation identity`
  - `storage role`
- ensure reverse relation paths are classified as `reverse_view`, not as schema-owning materializations
- ensure one-to-many collections default to target type table reuse
- ensure many-to-many collections resolve one canonical relation-table identity
- ensure path-specific table identities appear only from explicit storage metadata
- ensure inline materialization appears only from explicit storage metadata

Current hotspots:

- `populate_mat_list(...)`
- `populate_legacy_mat_list(...)`
- `build_temp_materialization(...)`

Expected result:

- `orm_mat` should describe reusable storage identities
- not just immediate path-local table guesses

### B. Schema Creation In `structure_builder`

Checklist:

- before creating any table, resolve its canonical identity
- check registry/hash map first
- create table only if identity is missing
- if materialization role is `reverse_view`, create nothing
- if materialization role is `inline`, create only parent columns
- for one-to-many, add owner/backreference columns on the child type table
- do not create helper/collection tables for ordinary one-to-many model collections
- for many-to-many, create exactly one canonical relation table
- ensure reverse many-to-many paths reuse the same relation identity
- remove special-case suppression logic once canonical identity resolution makes it unnecessary

Current hotspots:

- `build_from_orm_root(...)`
- `apply_orm_node_materialization(...)`
- `resolve_node_primary_table_name(...)`
- `reserve_redundant_root_helper_tables(...)`

Expected result:

- no redundant helper tables like `$App_Addresses`
- no mirrored reverse many-to-many tables
- no duplicate owner columns from reverse paths

### C. Minimum Behavior Checks

Checklist:

- `App.Addresses` reuses `Addresses`
- `App.Users` reuses `$Users` when that is the canonical target table
- `App.Properties` reuses `Properties`
- `App.Offers` reuses `Offers`
- owner/backreference columns are added on reused target tables where needed
- no synthetic root helper tables are produced for those cases

### D. Explicit Override Checks

Checklist:

- explicit path-specific table override creates a dedicated path table
- explicit path-specific collection override creates a dedicated relation table
- explicit inline override prevents child table creation for that path
- absence of explicit override falls back to reusable type/relation identities

### E. Refactor Goal

Short-term goal:

- keep current `orm_mat` shape if needed
- but make its values obey canonical identity rules

Preferred next step:

- add explicit internal concepts for:
  - `type identity`
  - `relation identity`
  - `storage role`

Completion signal:

- redundant-table suppression hacks are no longer carrying correctness
- they become removable cleanup rather than active parity logic
