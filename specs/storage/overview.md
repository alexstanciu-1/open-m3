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
| Keep indexing unified | Uniqueness should be expressed through index configuration, such as `index: unique`, rather than a separate unique attribute. |
| Let the ORM plan relationships | Relation type should be chosen by the ORM from the model shape by default, while explicit relation metadata may refine oneToOne, oneToMany, or manyToMany naming details when needed. |
| Default collection planning carefully | Collection properties should default to many-to-many, except on the root model where the common default should be one-to-many. |
| Move UI hints out | View/editor/popup/layout hints encoded in legacy storage metadata should move to view metadata in Open M3. |
| Move semantic structure up | Structure currently inferred from storage conventions should become explicit in model metadata in Open M3. |
