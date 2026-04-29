# Open M3 Base Structure

Status: draft

Purpose: define the first runtime structure for authored model and storage definitions under the `om3` root namespace.

## Naming Rule

Open M3 runtime code should use lowercase snake style consistently.

Examples:

- `model`
- `model_property`
- `storage`
- `storage_property`

This project is written in Simple C++, so the naming should follow the project style rather than normal C++ class-style conventions.

## Root Namespace

The current root namespace should be:

- `om3`

The first foundational namespace split should be:

- `om3::base`
- `om3::orm`

`om3::base` holds the descriptive foundation.

Inside it, structure definitions should live under:

- `om3::base::schema`

`om3::orm` will later hold assembled ORM structures and SQL-lowered structures.

## File And Path Rule

File paths should mirror the namespace structure, except the first namespace part `om3`, which should be omitted from the filesystem path.

Examples:

- `om3::base::schema::model`
  - `base/schema/model.php`
- `om3::base::schema::model_property`
  - `base/schema/model_property.php`
- `om3::base::schema::storage`
  - `base/schema/storage.php`
- `om3::base::schema::storage_property`
  - `base/schema/storage_property.php`
- `om3::orm::sql_table`
  - `modules/orm/sql/sql_table.php`

Modules still stay physically under `modules/`.

For Open M3, schema/structure should stay separate from later service/process code.

So for the base layer we should prefer:

- `base/schema/...`

rather than mixing pure structure classes with later behavior-oriented areas.

## Layering

The runtime structure should be built in this order:

1. model definition classes
2. storage definition classes
3. assembled ORM classes
4. SQL runtime/schema classes

This document covers only the first two.

## Base Namespace

The first definition classes should live under:

- `om3::base::schema`

## Model Definition Classes

### `om3::base::schema::model`

Represents one authored model definition.

| Property | Meaning |
| --- | --- |
| `name` | The local model name. |
| `extends` | The parent model name when one exists. |
| `abstract` | Whether the model is abstract. |
| `properties` | The list or map of model properties owned by the model. |
| `attached_storage` | The attached storage definition for this model, when one exists. |

Notes:

- `name` is the authored model identity within its resolved namespace/path context.
- `attached_storage` is attached here so the authored definition layer can already express the intended `model -> storage` link.

### `om3::base::schema::model_property`

Represents one authored model property definition.

| Property | Meaning |
| --- | --- |
| `name` | The property name. |
| `type_name` | The target scalar or model type name. |
| `type_list` | Whether the property is a list of the declared type. |
| `required` | Whether the property is required at model level. |
| `default` | The model-level default value when one exists. |
| `struct_ref` | The root reference target when the property is a reference. |
| `struct_sub` | Whether the property is a sub-structure. |
| `struct_weakref` | Whether the property is a weak reference. |
| `attached_storage` | The attached storage definition for this property, when one exists. |

Notes:

- Scalars must not use `struct_*`.
- Non-scalars must resolve to one structural mode after defaulting.
- `attached_storage` is attached here so the authored property definition can already express the intended `property -> storage` link.

## Storage Definition Classes

### `om3::base::schema::storage`

Represents one authored storage definition attached to a model.

| Property | Meaning |
| --- | --- |
| `table` | The primary table or equivalent storage materialization. |
| `engine` | The storage engine when explicitly defined. |
| `database` | The target database or logical storage namespace when explicitly defined. |
| `primary_key` | The declared primary key shape when explicitly defined. |
| `type_column` | The discriminator/type column when explicitly defined. |
| `indexes` | Type-level index definitions when explicitly defined. |
| `owner_model` | Weak-reference back to the owning model definition. |
| `properties` | The list or map of property-level storage definitions. |

Notes:

- `storage` mirrors the model at type level.
- `owner_model` provides the reverse link to the owning model definition without creating a strong ownership cycle.

### `om3::base::schema::storage_property`

Represents one authored storage definition attached to a model property.

| Property | Meaning |
| --- | --- |
| `kind` | The storage materialization kind. |
| `column` | The concrete column name when applicable. |
| `sql_type` | The concrete SQL scalar type when applicable. |
| `is_nullable` | The storage-level nullability flag. |
| `default` | The storage-level default value or expression. |
| `index` | The property-level index mode. |
| `relation_type` | The relation materialization mode. |
| `relation_table` | The relation table name when needed. |
| `relation_this_column` | The relation column pointing back to the owning side. |
| `relation_target_column` | The relation column pointing to the target side. |
| `owner_property` | Weak-reference back to the owning model property definition. |

Notes:

- `storage_property` mirrors the model at property level.
- `owner_property` provides the reverse link to the owning model property definition without creating a strong ownership cycle.

## Relationship Rules

| Rule | Meaning |
| --- | --- |
| model owns storage | A `model` may hold one attached `storage` through `attached_storage`. |
| property owns storage | A `model_property` may hold one attached `storage_property` through `attached_storage`. |
| storage points back | `storage` may point back weakly to its owning `model` through `owner_model`. |
| property storage points back | `storage_property` may point back weakly to its owning `model_property` through `owner_property`. |
| model stays semantic | `model` and `model_property` remain the semantic source of truth. |
| storage stays materialized | `storage` and `storage_property` describe materialization only. |

## Practical Intention

These classes are not the final ORM classes.

They are the first runtime structures that hold the authored definitions in usable form.

Later:

- `om3::orm` will assemble and resolve these definitions
- SQL-specific classes will then be lowered from that assembled ORM view

That separation is intentional and should be preserved.
