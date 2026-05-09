# Open M3 Model Authoring

Status: draft

Purpose: define the authoritative authored meaning of the Open M3 model layer, without describing runtime assembly strategy.

## Role

The model layer defines semantic structure.

It answers:

- what a type is
- what a type is called
- where a type lives
- what properties a type contains
- what a property is
- what a property is called
- whether a property is scalar, reference, sub-structure, or collection
- what model-level and storage-level attributes apply
- what rules and constraints apply

The model layer may drive storage and view.

Storage and view must not define core model meaning.

Within an explicit model definition context, model-native attributes should be written without the `model.` prefix.

## Core Concepts

The authored model system uses these main concepts:

- `model`: one authored type definition
- `model_property`: one authored property definition inside a model
- `storage`: an attached storage attribute set for a model
- `storage_property`: an attached storage attribute set for a model property

`storage` and `storage_property` are not separate semantic types.

They are attached attributes over semantic model definitions.

This means:

- `model` answers what the type means
- `storage` answers how that type is materialized
- `model_property` answers what the property means
- `storage_property` answers how that property is materialized

## Type Identity And Resolution

Model namespace should come from folder structure by default.

Examples:

- `TF/Merch/Hotel`
- `Common/Address`

This means a model keeps a local `name`, while its effective full identity is derived from its folder path plus that local name.

Type references should use file-like paths.

Examples:

- `Hotel`
- `TF/Merch/Hotel`
- `../../Hotel`

Relative type references should resolve from the current model location by default.

## Type Rules

| Rule | Description |
| --- | --- |
| Explicit model name | Every model must have one explicit name. |
| Folder-derived namespace | Model namespace should be derived from folder structure by default. |
| Local model name | The `name` attribute is the local model name within the current folder-derived namespace. |
| Properties belong to the type | A model/type definition owns its `properties` block as part of its core structure. |
| File-like type references | Type references should use file-like paths such as `Hotel`, `TF/Merch/Hotel`, or `../../Hotel`. |
| Concrete extends abstract only | A concrete model may only extend an abstract model. |
| No concrete-to-concrete inheritance | One concrete model must not extend another concrete model. |
| No abstract on root | An abstract model must not appear on the root model / app root. |
| No model interfaces | Interfaces are out of scope for the model layer. Empty abstract models may be used instead. |

## Property Semantics

Every property belongs to one containing model.

Property names are local to that containing model.

Properties are semantic first.

Their storage behavior may be attached, but storage does not decide whether a property is scalar, reference, sub-structure, or collection.

## Property Rules

| Rule | Description |
| --- | --- |
| Explicit property name | Every property must have one explicit name within its containing model. |
| Property names are local | Property names are resolved within their containing model rather than globally. |
| Unique within model | Property names must be unique within the same model. |
| Strict type only | A property type must be strict. Loose multi-shape property definitions are not allowed. |
| Type plus collection | A property means one value of its declared `type` or a collection of values of that declared `type`. |
| List defaults to false | `type.list` defaults to false and should normally be omitted unless the property is actually a list. |
| One scalar type | Only one scalar type is allowed per property. |
| No scalar/reference mixing | A property must not mix scalar and reference semantics. |
| One reference target | Only one reference target type is allowed per property. |
| Abstract target allowed | A reference target may be abstract. |
| Default structural mode for non-scalars | If a non-scalar property does not explicitly declare a `struct.*`, it defaults to `struct.sub`. |
| Exactly one structural mode for non-scalars | Every non-scalar property must resolve to exactly one structural mode through `struct.ref`, `struct.weakref`, or `struct.sub`. |
| No structural mode for scalars | Scalar properties must not declare `struct.*` attributes. |
| No mixed structural modes | A property must not declare more than one `struct.*` attribute. |
| Root-bound strong reference | `struct.ref` is a string naming the expected root entry such as `Cities` or `Countries`. |

## Structural Modes

| Concept | Meaning |
| --- | --- |
| `struct.ref` | Strong reference to another model object, bound to an expected root entry such as `Cities` or `Countries`. |
| `struct.weakref` | Weak or non-owning reference to another model object. |
| `struct.sub` | Contained sub-structure rather than external reference. |
| scalar | Scalar properties do not use `struct.*` attributes. |

These structural concepts should be expressed at model level, not inferred later from storage or view metadata.

## Path Semantics

The same base type may appear in more than one semantic path.

Examples:

- `App.Hotels.Address`
- `App.Customers.Address`

These paths may reuse the same base type while still meaning different effective sub-structure usages.

Path-sensitive meaning applies to `struct.sub`.

It does not apply in the same way to `struct.ref` or `struct.weakref`, which should keep stable target meaning.

## Sub-Structure Refinement

For `struct.sub`, the effective model may depend on the full path from the root model.

A sub-structure refinement starts from a declared base model such as `Address`.

The refinement reuses the same `properties` shape as a normal type definition, but in that case it acts as a local specialization block rather than the primary type definition block.

### Example

| Path | Meaning |
| --- | --- |
| `Address` | Base reusable model definition. |
| `Company.Address` | Local refinement of `Address` as used inside `Company`. |
| `App.Customers.Address` | Additional local refinement of the same base `Address` model from the root usage path. |

## Sub-Structure Refinement Rules

| Rule | Description |
| --- | --- |
| Path-sensitive | A `struct.sub` usage may be refined based on its full path from the root model. |
| Base model first | A sub-structure refinement starts from a declared base model such as `Address`. |
| Add only | A refinement may add properties. |
| Disable only | A refinement may disable inherited properties. |
| No arbitrary rewrite | A refinement must not arbitrarily rewrite the base model. |
| No type mutation | A refinement must not change existing property types. |
| No shape mutation | A refinement must not change scalar/reference/sub semantics. |
| No collection mutation | A refinement must not change collection-ness. |

## Storage Attachment Model

Storage is authored as attached attributes on semantic definitions.

This means:

- a `model` may have one attached `storage`
- a `model_property` may have one attached `storage_property`

Storage attachment does not create a second semantic type system.

It only describes materialization details for an already-authored semantic structure.

Examples of model-level storage attributes include:

- table
- database
- engine
- primary key
- indexes

Examples of property-level storage attributes include:

- column
- nullable
- default
- index
- relation mapping

## Storage Inheritance Direction

By default, attached storage attributes are inherited, not overwritten.

This means a reused base type should normally carry the same storage intent wherever it appears.

The default rule is conservative:

- if no explicit override is authored, the inherited storage meaning remains in force
- storage attributes must not silently drift based only on traversal context

## Explicit Storage Overrides

Some path-sensitive exceptions are allowed and must be explicit.

Example:

- `App.Hotels.Address` may materialize in one table
- `App.Customers.Address` may materialize in another table

This means the same semantic base model may be reused while storage materialization changes for a specific path.

Such exceptions must be authored explicitly.

They must not be inferred implicitly from usage alone.

## Storage Override Rules

| Rule | Description |
| --- | --- |
| Default no override | Attached storage attributes should remain inherited unless an explicit override is authored. |
| Explicit exception only | Path-sensitive storage changes are allowed only through explicit authored overrides. |
| Semantic first | A storage override must not change semantic property meaning. |
| No structural rewrite through storage | Storage must not convert a scalar into a ref, a ref into a sub-structure, or otherwise rewrite semantic structure. |
| Path-local materialization allowed | Explicit storage overrides may change how the same semantic model is materialized at a specific path. |
| Model-level and property-level scope | Explicit overrides may apply at attached `storage` or attached `storage_property` level. |

## Worked Example

Base meaning:

- `Address` defines common address fields

Semantic reuse:

- `Hotel.Address` uses `Address`
- `Company.Address` uses `Address`

Semantic local refinement:

- `Company.Address` may add `Premises`

Storage default:

- both paths inherit the same attached storage if no override is authored

Storage explicit exception:

- `App.Hotels.Address` may explicitly override the storage table
- `App.Customers.Address` may explicitly override the storage table differently

This does not change the semantic identity of `Address`.

It changes only the materialization of that semantic meaning for a specific path.

## Validation Direction

The authored model system should validate at least:

- unresolved type references
- duplicate property names in one model
- illegal structural mode combinations
- illegal refinement operations
- illegal storage overrides
- attempts to change semantic meaning through storage-only authoring

## Relationship To Assembly

This document defines authored meaning only.

It does not define:

- cache design
- traversal algorithm
- immutable assembled instances
- reuse versus cloning strategy
- callback timing

Those runtime concerns belong in the separate assembly specification.
