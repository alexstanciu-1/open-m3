# Open M3 Storage Attributes

Status: draft

Purpose: define the proposed Open M3 storage attribute surface in a structured table format.

These are proposed new attributes, not a legacy inventory.

Storage mirrors model structure by level:

- type-level storage attributes are for model type attributes
- property-level storage attributes are for model property attributes

Storage must not cross levels or redefine structural ownership.

## Type Attributes

| Attribute | Scope | Data Type | Purpose |
| --- | --- | --- | --- |
| table | type | string | Declares the primary table or equivalent materialization for a concrete model. |
| engine | type | string | Declares the storage engine or backing persistence family. |
| database | type | string | Declares the target database or logical storage namespace. |
| primary_key | type | string or string[] | Declares the primary key materialization. |
| type_column | type | string | Declares the discriminator/type column when polymorphic materialization is used. |
| indexes | type | index_list | Declares index definitions for the concrete model. |

## Property Attributes

| Attribute | Scope | Data Type | Purpose |
| --- | --- | --- | --- |
| kind | property | storage_kind | Declares how the property is materialized, such as column, foreign key, join, embedded, or none. |
| column | property | string | Declares the column or field name for the property. |
| sql_type | property | string | Declares the scalar storage type for a column materialization. |
| nullable | property | bool | Declares storage-level nullability. |
| default | property | scalar or null or storage_expr | Declares storage-level default value generation. |
| index | property | bool or index_mode | Declares whether the property should be indexed and optionally how, such as unique. |
| relation.type | property | relation_mode | Declares relation materialization mode, such as oneToOne, oneToMany, or manyToMany. |
| relation.table | property | string | Declares the relation table name when collection materialization needs an explicit table. |
| relation.this_column | property | string | Declares the column that points back to the owning side of the relation. |
| relation.target_column | property | string | Declares the column that points to the target side of the relation. |

## Type Notes

| Name | Meaning |
| --- | --- |
| index_list | A structured list of storage index definitions. |

## Property Notes

| Name | Meaning |
| --- | --- |
| storage_kind | One of the allowed materialization kinds, such as column, embedded, or none. |
| index_mode | An index mode such as unique. |
| relation_mode | A relation mode such as oneToOne, oneToMany, or manyToMany. |
| scalar | A scalar literal value for storage defaults where applicable. |
| storage_expr | A storage-level generated/default expression. |

## Core Rules

| Rule Area | Rule |
| --- | --- |
| dependency direction | Storage cannot materialize without a model. |
| dependency direction | Storage is derived from model semantics. |
| dependency direction | Storage must not invent model meaning. |
| abstract types | Abstract models must not define their own storage identity. |
| property semantics | Storage must not decide whether a property is scalar, reference, weak reference, sub-structure, or collection. |
| shape integrity | Storage must not allow singular/collection ambiguity. |
| shape integrity | Storage must not allow scalar/reference ambiguity. |
| relationship planning | Relation planning should be derived by the ORM by default. Explicit relation metadata exists only to guide naming and materialization details when needed. |
| collection defaults | Collection properties should default to `manyToMany`, except on the root model where the common default should be `oneToMany`. |
| none materialization | A non-persisted property should be expressed as `kind: none`, not a separate skip flag. |
| indexing | Uniqueness should be expressed through `index: unique`, not a separate unique attribute. |

## Current ORM Rule Clarifications

These clarify how the current ORM interprets the storage layer when building DB structure.

| Area | Rule |
| --- | --- |
| scalar properties | Scalar properties materialize as `value_column` on an owner table. |
| singular refs | Singular model references materialize as `ref_column` on an owner table by default. |
| target type reuse | A singular ref does not replace the target type table; it only decides where the reference column lives. |
| one-to-many | `one_to_many` means the relation lives on the child/target table via an owner/backreference column. |
| no synthetic collection for one-to-many | A one-to-many collection must not create a helper table just because the property is a collection. |
| helper collections | A `collection_table` means the collection itself owns a helper/relation table. |
| model collections | A model collection may require both a target type table and a separate helper/relation table. |
| many-to-many | `join_table` means one canonical shared relation table, in addition to the target type tables. |
| reverse identity reuse | Reverse relation paths must reuse the existing relation identity instead of creating mirrored parallel schema. |
| path identity | Path identity is not storage identity by default. |
| type identity | Type identity decides where model rows live. |
| relation identity | Relation identity decides where relation/helper rows live when they do not live on the type table. |
| polymorphic property refs | If a property targets an abstract model or multiple concrete target types, the ORM may need a property-level `$_type` column. |
| shared polymorphic tables | If multiple concrete classes share one storage table, that table may need a table-entry `$_type` column. |

## Notes

| Topic | Note |
| --- | --- |
| naming | Inside an explicit storage definition context, storage-native attributes do not use the storage. prefix. |
| concrete only | Storage identity belongs only to concrete models. |
| materialization | Storage describes how an already-known model shape is materialized, not a second model definition. |
| relations | `relation.type` is the current explicit form. A future compact parsable relation syntax may still be added later. |
| view separation | View/editor/popup/layout hints should not live in storage metadata. |
| inherited properties | Abstract models may contribute inherited properties, but not their own root storage identity. |
| polymorphism | When a property targets an abstract model, derived concrete types should preferably share one materialization family for performance. |
