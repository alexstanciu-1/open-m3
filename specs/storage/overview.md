# Open M3 Storage

Status: draft

Purpose: define the high-level direction and restrictions for the Open M3 storage layer.

## Role

The storage layer defines persistence materialization.

It answers:

- how a model is persisted
- how a property is materialized
- how references and collections are stored
- what storage-specific constraints or optimizations apply

The storage layer cannot materialize without a model.

The storage layer is derived from model semantics.

Storage must not invent core domain meaning.

Within an explicit storage definition context, storage-native attributes should be written without the `storage.` prefix.

## Model Relationship

Storage mirrors model structure by level.

- storage type attributes are for model type attributes
- storage property attributes are for model property attributes

This means storage follows the same structural ownership as the model:

- type-level storage belongs to the model type as a whole
- property-level storage belongs to one model property

Storage must not cross levels or redefine ownership.

## Direction

| Rule | Description |
| --- | --- |
| No storage without model | Storage exists only as materialization of an already-known model shape. |
| Derived from model | Storage must follow model semantics instead of defining them. |
| No semantic backflow | Storage metadata must not become the source of truth for model structure. |
| Concrete only | Storage identity belongs to concrete models, not abstract ones. |
| Property materialization only | Property-level storage may refine how a property is stored, but must not change what the property is. |

## Type-Level Restrictions

| Rule | Description |
| --- | --- |
| No abstract root storage | An abstract model must not be materialized as a root storage entity. |
| No abstract-owned table | An abstract model must not define its own table or equivalent primary materialization. |
| Concrete storage identity | Storage identity such as table/materialization belongs to concrete models only. |

## Property-Level Restrictions

| Rule | Description |
| --- | --- |
| No shape invention | Storage must not decide whether a property is scalar, reference, weak reference, sub-structure, or collection. |
| No collection ambiguity | Storage must not allow a property to behave as both singular and collection. |
| No scalar/reference ambiguity | Storage must not allow a property to mix scalar and reference materialization. |
| One target materialization | A property should materialize one declared model target shape, even when the target is abstract. |

## Recommended Direction

| Recommendation | Description |
| --- | --- |
| Keep naming local | Inside explicit storage definition context, use `table`, `column`, `kind`, `none`, and similar local storage names without the `storage.` prefix. |
| Shared storage for abstract targets | When a property references an abstract model, derived concrete types should ideally materialize together for performance and simpler querying. |
| Keep storage-specific data local | Column names, join tables, indexes, and storage engine details should stay in storage metadata only. |
| Keep indexing unified | The current ORM intentionally does not emit `UNIQUE KEY`. If legacy metadata expresses `index: unique`, Open M3 currently keeps it only as compatibility input and materializes a plain non-unique index instead. Future uniqueness behavior should live at ORM policy level rather than direct SQL uniqueness by default. |
| Let DB defaults work | Engine, charset, and collation should only be emitted when explicitly authored. Otherwise the current ORM should leave them unset and let the target database defaults apply. |
| Let the ORM plan relationships | Relation type should be chosen by the ORM from the model shape by default, while explicit relation metadata may refine oneToOne, oneToMany, or manyToMany naming details when needed. |
| Default collection planning carefully | Collection properties should default to many-to-many, except on the root model where the common default should be one-to-many. |
| Keep object collections unique | Collections of objects should be unique by default. The same object should not appear twice in the same object collection. This matches the practical legacy ORM behavior, avoids duplicate relation rows, and is the most sensible default for relational linking. Scalar collection duplicate behavior should be reviewed separately before being treated as final. |
| Move UI hints out | View/editor/popup/layout hints encoded in legacy storage metadata should move to view metadata in Open M3. |
| Move semantic structure up | Structure currently inferred from storage conventions should become explicit in model metadata in Open M3. |

## Current Materialization Rules

The current OpenM3 ORM uses a small set of materialization outcomes when building DB structure:

- `value_column`
- `ref_column`
- `type_table`
- `one_to_many`
- `collection_table`
- `join_table`

These should be interpreted as follows.

### Scalar properties

A scalar property materializes as:

- `value_column`

Meaning:

- the scalar value lives on an existing owner table

### Singular model references

A singular model reference materializes as:

- `ref_column`

Meaning:

- the reference column lives on the owner table
- the target type still keeps its own type table identity

### Type tables

A concrete model type may materialize as:

- `type_table`

Meaning:

- rows for that concrete model live in that model’s own primary table

### One-to-many

A one-to-many relation materializes as:

- `one_to_many`

Meaning:

- the relation lives on the child/target table through an owner/backreference column
- no helper table should be created just because the property is a collection

### Collection/helper tables

A collection property may materialize as:

- `collection_table`

Meaning:

- the relation/value collection needs its own helper table

Important rule:

- a model collection may still require both:
  - a target type table for the collected model rows
  - a separate helper/relation table for the collection itself

### Many-to-many

A many-to-many relation materializes as:

- `join_table`

Meaning:

- the target types keep their own type tables
- the relation itself lives in one canonical shared relation table

## Identity Rules

Storage identity is not just “whatever path we traversed”.

The current rules are:

- a type identity answers where model rows live
- a relation identity answers where a relation/helper collection lives when it cannot live on the target type table
- path identity is semantic traversal identity only by default

So:

- path identity alone must not invent schema objects
- reverse paths should reuse existing identities
- a collection property may require both a type identity and a relation identity

## Polymorphic Materialization

The current verified rules are:

- if a property targets an abstract model, or expands to more than one concrete target type, the relation may need a property-level `$_type` column
- if multiple concrete classes share the same storage table, that table may need a table-entry `$_type` discriminator column

These are different cases and must not be collapsed into one generic rule.

## Read Next

For a short readable ORM summary:

- [ORM overview note](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/orm_overview_note.md:1)

For the current detailed implementation note:

- [ORM materialization direction](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/orm_materialization_direction.md:1)
