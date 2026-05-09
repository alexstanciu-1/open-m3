# Open M3 ORM Rule Extraction V1

Status: planning draft

Purpose: extract a smaller set of useful ORM rules from the legacy H2B ORM without carrying over the whole legacy implementation shape.

This note is intentionally narrower than the legacy notes.

It tries to answer:

- which rules still look structurally useful
- which rules should likely remain in the new ORM
- which areas are still open

## Reading Principle

Each rule below should be treated as one of:

- keep
- keep but simplify
- revisit

The aim is not to preserve the old implementation.

The aim is to preserve the useful decisions in a simpler traversal-driven design.

## 1. Root Traversal Rule

Rule:

- start from the root model
- traverse reachable persisted properties
- derive all materialization from that root traversal

Assessment:

- keep

Why:

- this is still the right foundation
- it matches the assembler/traversal direction we already built
- it keeps the ORM driven by model reachability rather than by disconnected registration

## 2. Ignore Non-Stored Properties Rule

Rule:

- properties marked as query-only or non-stored do not materialize

Legacy shape:

- skip `storage["query"]`
- skip `storage["none"]`

Assessment:

- keep

Why:

- this is a clear storage concern
- it simplifies traversal output for the ORM planner

## 3. Type-To-Table Identity Rule

Rule:

- a concrete model type may materialize into one root table

Legacy shape:

- type table comes from storage metadata such as `storage["table"]`

Assessment:

- keep but simplify

Why:

- the ORM still needs a clear root materialization identity
- but the rule should become more explicit in Open M3 and less dependent on scattered metadata lookup

## 4. Path-Specific Materialization Rule

Rule:

- the same semantic base model may materialize differently at different root-relative paths

Examples:

- `app.properties.address`
- `app.companies.address`

Assessment:

- keep

Why:

- this is one of the most important new-direction requirements
- it is the natural consequence of path-based assembly plus attached storage interpretation

This is one of the main places where Open M3 should become clearer than the legacy ORM.

## 5. Scalar Property Rule

Rule:

- a scalar property materializes as one or more value columns

Legacy shape:

- choose SQL type from supported scalar types
- allow storage override for exact SQL type
- allow dimensions to expand into multiple columns

Assessment:

- keep but simplify

Why:

- scalar -> column is fundamental
- exact type forcing should probably remain possible
- dimensional expansion may need a fresh decision later

Proposed simplified direction:

- default scalar property -> one value column
- optional explicit storage override may refine the SQL type
- dimensional expansion should be treated as an advanced storage feature, not a base ORM assumption

## 6. Reference Property Rule

Rule:

- a property that points to another materialized model becomes a reference column unless another materialization rule explicitly applies

Legacy shape:

- integer reference column

Assessment:

- keep

Why:

- this is the natural default relational shape for `struct.ref`

Proposed simplified direction:

- `struct.ref` -> reference column by default
- the referenced target keeps its own semantic identity
- reference storage should not silently behave like owned inline sub-structure storage

## 7. Sub-Structure Materialization Rule

Rule:

- a `struct.sub` property is owned by its parent path and may materialize differently depending on path

Assessment:

- keep and make first-class

Why:

- this is central to the new assembler design
- the legacy ORM had this idea implicitly in several places, but not as cleanly as we want now

Open M3 direction:

- `struct.sub` is owned and path-sensitive
- the planner should decide whether it stays in the parent table, uses the sub-type default table, or gets an explicit custom table
- inline materialization must be explicit
- dedicated custom table materialization must be explicit
- if no explicit override exists, `struct.sub` should use the sub-type default table

## 8. Collection Rule

Rule:

- collection properties need a distinct materialization rule from singular properties

Legacy shape:

- one-to-many often reuses the child target table
- many-to-many / non-one-to-many often gets a dedicated collection table

Assessment:

- keep but simplify

Why:

- collections are inherently different
- but the old rule set is mixed with inheritance and table-name inference

Proposed simplified direction:

- collections should be planned only after singular path materialization is solid
- keep two main categories:
  - one-to-many
  - collection-table / join-table

## 9. Multi-Type Discriminator Rule

Rule:

- when one stored slot can hold more than one target type, a type discriminator may be needed

Legacy shape:

- smallint type column

Assessment:

- revisit

Why:

- this is a real requirement in some systems
- but it adds complexity quickly
- it should not be treated as part of the minimal first ORM slice

Proposed v1 direction:

- leave multi-type support out of the first implementation unless a concrete use case forces it

## 10. Table Metadata Rule

Rule:

- table materialization may carry table-level attributes such as engine, charset, collation, comment

Assessment:

- keep

Why:

- these are legitimate storage attributes
- they belong in schema materialization, not in model semantics

## 11. Column Metadata Rule

Rule:

- columns may carry SQL-specific attributes such as nullability, default, unsigned, compression, and comments

Assessment:

- keep

Why:

- these are clear storage-level concerns
- they are appropriate as attached storage attributes

## 12. Index Rule

Rule:

- indexes are derived from storage intent on top of materialized columns

Legacy shape:

- primary
- unique
- normal
- fulltext

Assessment:

- keep but separate more clearly from column construction

Why:

- the legacy code creates indexes during column setup
- that is practical, but it couples two concerns too tightly

Open M3 direction:

- the planner may still decide indexing at the same time
- but schema materialization should conceptually treat indexes as their own objects

## 13. In-Memory Schema Object Rule

Rule:

- ORM planning should build an in-memory relational schema model before emitting SQL

Assessment:

- keep

Why:

- this is one of the strongest legacy ideas
- it keeps SQL sync separate from model traversal
- it also makes other backends possible later

Minimum useful objects:

- table
- column
- index
- foreign key or reference

## 14. SQL Sync Separation Rule

Rule:

- database synchronization should be a separate step after planning

Assessment:

- keep

Why:

- planning and syncing are different responsibilities
- this makes dry-run, diffing, and future backends easier

## 15. Abstract-Type Materialization Rule

Rule:

- abstract types should not automatically receive their own concrete root table

Assessment:

- keep

Why:

- this fits our current storage direction already
- concrete materialization identity should belong to concrete usable paths/types

## 16. Ownership Rule

Rule:

- the planner must know whether a property is owned inline, owned in a child table, or only referenced

Assessment:

- keep and elevate

Why:

- this is critical not only for DB structure, but also for query planning and CRUD merge later

This should become one of the first-class outputs of the new planner.

## Suggested Minimal Rule Set For First New ORM Slice

The smallest useful first rule set looks like this:

1. traverse from root
2. ignore non-stored properties
3. create root tables for concrete root materialized models
4. materialize scalar properties as value columns
5. materialize `struct.ref` as reference columns
6. materialize `struct.sub` as path-sensitive owned structures
7. allow path-sensitive table identity for `struct.sub`
8. build in-memory table/column/index objects
9. keep SQL sync as a separate step

## Suggested Areas To Delay

These areas likely do not belong in the first slice:

- multi-type discriminators
- dimension-expanded columns
- complex inheritance/table-sharing behavior
- advanced collection strategies beyond one simple case

## Main Conclusion

The legacy ORM contains many useful rules, but the new Open M3 ORM does not need to copy the old graph shape.

The durable core appears to be:

- root traversal
- path-aware materialization decisions
- owned vs referenced distinction
- in-memory schema objects
- separate SQL sync

That is small enough to implement clearly and still strong enough to cover the important first cases.
