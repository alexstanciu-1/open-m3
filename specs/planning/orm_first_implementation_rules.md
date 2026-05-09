# Open M3 ORM First Implementation Rules

Status: planning draft

Purpose: define the smallest useful rule set for the first Open M3 ORM implementation.

This is intentionally narrower than the full legacy rule extraction.

It is meant to be simple enough to implement directly on top of:

- loaded models
- assembled path-specific models
- iterative root traversal

## Rule 1: Traverse From Root

The ORM starts from the root model and traverses the assembled model graph.

Traversal is:

- iterative
- path-aware
- based on effective assembled models

The traversal is the backbone of ORM planning.

## Rule 2: Ignore Non-Stored Properties

A property that is explicitly marked as non-stored does not participate in ORM materialization.

This includes query-only or storage-none style properties.

## Rule 3: Root Materialization Creates Root Tables

A concrete model that is intended to be materialized as a root entity gets a root table identity.

The exact naming rules are still open, but the ORM must be able to answer:

- does this root model materialize
- if yes, what is its table identity

## Rule 4: Scalar Properties Become Value Columns

A scalar property materializes as a value column in the current materialization target.

For the first implementation:

- one scalar property -> one value column

Advanced scalar features such as dimension-expanded columns are out of scope for the first slice.

## Rule 5: `struct.ref` Becomes A Reference Column

A `struct.ref` property materializes as a reference column by default.

It does not inline the target structure.

The referenced target keeps its own materialization identity.

## Rule 6: `struct.sub` Is Owned And Path-Sensitive

A `struct.sub` property is owned by the parent path.

Its effective structure may vary by path.

Its storage materialization may also vary by path.

This is a first-class rule in Open M3.

The current direction is:

- inline in parent table must be explicit
- dedicated custom child table must be explicit
- otherwise `struct.sub` uses the sub-type default table

## Rule 7: The Same Base Model May Materialize Differently By Path

The same reusable semantic model may materialize into different tables depending on root-relative path.

Example direction:

- `app.properties.address`
- `app.companies.address`

The exact final table names are still open.

The important rule is:

- materialization identity is not only type-based
- it may be path-based when explicitly requested
- otherwise reused sub-types should fall back to their default table identity

## Rule 8: Build In-Memory Schema Objects Before SQL

The ORM planner must first build an in-memory relational schema model.

Minimum useful objects:

- table
- column
- index

SQL emission or DB synchronization happens only after this model exists.

## Rule 9: Keep SQL Sync Separate

Planning schema structure and syncing schema structure are separate responsibilities.

The first ORM slice should preserve this separation.

## Rule 10: Treat Materialization As Bidirectional

The ORM must not think about materialization only in the forward direction.

It must eventually support:

- type/property -> table/column
- table/column -> type/property

The forward direction is needed for:

- schema building
- query planning
- SQL generation

The reverse direction is needed for:

- placing queried DB data back into the visible model result shape
- deciding which visible branch/type a row fragment belongs to

This rule does not force the final class layout yet, but it should shape the design of `orm_materialization`.

## Rule 11: One Visible Step May Need More Than One Materialization Branch

The first implementation should not assume too early that one visible node/path step always has exactly one materialization.

Real legacy cases show that one visible property purpose may expand into several concrete relational branches, especially for:

- non-strict inheritance expansion
- explicit mixed visible types
- collection/join-table patterns

The most important real case to preserve is:

- non-strict inheritance expansion

This is different from ordinary parent/join/target table structure.

The implementation should therefore stay open to:

- one visible `orm_node`
- having one or more materialization branches

even if the temporary implementation still uses a looser probe object while the real cases are being audited.

## First Concrete Scope

The first implementation should focus on:

- root table creation
- scalar column creation
- reference column creation
- path-sensitive `struct.sub` materialization

The first concrete proving case should be a reusable submodel such as `address`, used in at least two different root-relative paths.

That case should cover:

- default table reuse, such as `address -> addresses`
- explicit path-specific table override
- explicit inline materialization

## Explicitly Out Of Scope For First Slice

These should stay out of the first implementation unless a concrete use case forces them:

- multi-type discriminator columns
- dimension-expanded scalar columns
- advanced inheritance/table-sharing strategies
- complex collection planning
- advanced foreign-key orchestration

## Main Goal

The first ORM slice should be:

- traversal-driven
- path-aware
- simple enough to reason about
- strong enough to prove path-sensitive materialization
