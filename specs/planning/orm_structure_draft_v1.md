## ORM Structure Draft V1

### Status

Draft, with partial implementation updates reflected below.

This document captures the current agreed direction for the strict ORM planning structure.

The intent is:

- strict typed classes
- close to the visible model path
- reusable for query planning
- hopefully reusable for DB schema creation too

This draft intentionally keeps `orm_materialization` open for a later focused discussion.


### Design Direction

The structure should stay close to what is visible in the model path.

Example:

```text
app.hotels.address.city
```

At this level, what is visible is just:

- `app`
- `hotels`
- `address`
- `city`

So the ORM structure should be node-centric and property-visible:

- one node per visible path context
- the node exposes visible `properties`
- stepping through a property may lead to one or more child nodes


### Core Classes

The current agreed classes are:

- `orm_node_base`
- `orm_root`
- `orm_node`
- `orm_error`
- `orm_mat`

The original draft intentionally left `orm_materialization` open.

The current implementation is now more concrete than that:

- [base/orm/mat.phs](/home/alexv/__AI/open_m3/open_m3_01/base/orm/mat.phs) exists
- `orm_node` now carries `mat[]`
- `orm_node` also carries `mat_by_type`
- the older `materialization_probe` is still kept as a transitional audit summary


## orm_node_base

Purpose:

- one visible path context in the resolved ORM structure
- shared base for `orm_root` and `orm_node`

| Field | Type | Description |
|---|---|---|
| `path` | `string` | Full canonical path for this node, like `app`, `app.hotels`, `app.hotels.address`. |
| `parent` | `orm_node_base?` weakref | Parent node, or `null` for root. |
| `name` | `string?` | Property name used to reach this node from the parent, like `hotels` or `address`. For root this is the root name. |
| `children` | `orm_node[]` | Child visible nodes that can be reached by stepping into properties from this node. |
| `properties` | `hash<model_property>` | Effective visible properties at this path, keyed by property name. |
| `is_root` | `bool` | True only for the root node. |
| `is_scalar` | `bool` | True if this node represents a scalar type context rather than a model/object context. Computed from properties/type resolution. |
| `is_list` | `bool` | True if this node is list-shaped at this path. |
| `type` | `string` | Common resolved type for this node. Can be a scalar type or model type. Mixing unrelated types is not allowed. |
| `type_models` | `model[]` | All resolved model candidates represented by this node. Empty for pure scalar nodes. Computed from properties/type resolution. |


## orm_root

Purpose:

- one root ORM structure entry

Extends:

- `orm_node_base`

| Field | Type | Description |
|---|---|---|
| `nodes` | `orm_node[]` | All non-root nodes discovered under this root. |
| `errors` | `orm_error[]` | Non-fatal issues collected while building this structure. |
| `max_depth` | `int` | Effective traversal depth limit used to build the graph. |

Note:

- `root_type_name` was removed
- root identity is represented through the inherited `name` and `type`


## orm_node

Purpose:

- one non-root visible path context below the root

Extends:

- `orm_node_base`

| Field | Type | Description |
|---|---|---|
| `branch_kind` | `string` | How this node was reached from its parent. Current candidate values: `scalar`, `ref`, `weakref`, `sub`, `collection_scalar`, `collection_ref`, `collection_sub`. |
| `mat` | `orm_mat[]` | Concrete materialization routes for this visible node. The common case is one entry. |
| `mat_by_type` | `hash<int>` | Fast lookup/index into `mat[]` for polymorphic cases. The exact final keying contract may still evolve. |
| `materialization` | `orm_materialization_probe?` | Transitional audit/probe summary retained while the new `mat[]` path settles. |

Important note:

- it is now confirmed that one node/step may need more than one materialization route
- `mat[]` is the first implementation of that idea
- the final stable contract is still under refinement


## orm_error

Purpose:

- non-fatal issue collected during ORM structure setup

| Field | Type | Description |
|---|---|---|
| `code` | `string` | Stable machine-readable issue code. |
| `path` | `string` | Path where the issue occurred. |
| `message` | `string` | Human-readable explanation. |


### Important Simplifications Already Agreed

These decisions are already reflected in this draft:

1. `property_name_from_parent` was renamed to `name`

2. `property_from_parent` was removed
- parent property can be resolved through:
  - `$this->parent->properties`

3. `storage` was removed from the node for now
- we need a clearer materialization discussion first

4. `root_type_name` was removed
- the base fields are enough for now


### How To Read The Structure

Example path:

```text
app.hotels.address.city
```

Possible node chain:

- root node: `app`
- child node: `app.hotels`
- child node: `app.hotels.address`
- child node: `app.hotels.address.city`

At each node:

- `properties` contains the effective visible properties at that point
- `children` contains the traversable continuations
- `type` tells us the resolved common type for that node
- `type_models` tells us which model candidates participate in that node


### Current Open Point

The main unresolved part is:

- the final stable materialization contract

We still need to decide:

- how much reverse/hydration information belongs directly in `orm_mat`
- whether `mat_by_type` should key by concrete type or grouped route identity
- when the transitional probe object can be removed completely

So the next discussion should focus specifically on:

- how `orm_mat[]` becomes the final planner contract
- and which fields are still missing for full legacy parity

The current implementation direction is now:

- one visible `orm_node`
- zero or more concrete `orm_mat` routes
- optional fast lookup through `mat_by_type`
- optional temporary audit summary through `materialization`


### Legacy Strict vs Non-Strict Type Expansion

One important legacy rule has now been confirmed and must inform the new ORM design.

In the legacy ORM, model-reference properties do not always behave the same way when a base class is declared.

There are two distinct cases:

1. strict property
- only the visible declared type is used
- descendants are not expanded

2. non-strict property
- the declared type is treated as a base/abstract visible type
- instantiable descendants are expanded and considered too

This behavior is implemented in:

- `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/model/type/QModelProperty.php`

Important methods:

- `isMultiType()`
- `getAllReferenceTypes()`
- `getAllInstantiableReferenceTypes()`
- `GetAllInstantiableTypesFor(...)`

The key rule in those methods is:

- if `strict` is true, keep only the declared visible type
- if `strict` is false, use `QAutoload::GetClassExtendedBy(...)` to expand descendants


### Confirmed Travelfuse Examples

From the exported legacy metadata:

- `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/travelfuse/public_html/code/temp/types_json/Omi-App.json`

`MerchItems` is non-strict:

```json
"MerchItems": {
  "name": "MerchItems",
  "types": {
    "type": "QModelArray",
    "options": {
      "\\Omi\\Comm\\Merch\\Merch": "Omi\\Comm\\Merch\\Merch"
    }
  }
}
```

`Offers` is strict:

```json
"Offers": {
  "name": "Offers",
  "strict": true,
  "types": {
    "type": "QModelArray",
    "options": {
      "\\Omi\\Comm\\Offer\\Offer": "Omi\\Comm\\Offer\\Offer"
    },
    "strict": true
  }
}
```

So the practical legacy behavior is:

- `Omi\\Comm\\Merch\\Merch[]`
  - may expand to descendants
  - may therefore hit multiple concrete target tables for the same semantic purpose

- `Omi\\Comm\\Offer\\Offer[]`
  - stays on the visible declared type when marked strict
  - does not automatically expand descendants


### Why This Matters For orm_materialization

This clarifies an important distinction for the audit:

- ordinary parent/join/target table combinations are not the interesting problem
- the important harder case is when one visible semantic property step expands to multiple concrete target tables because of non-strict inheritance expansion

So when we discuss whether one `orm_node` may need one or more materializations, the first high-value cases to reason about are:

- non-strict inheritance-expanded properties
- not ordinary many-to-many or collection-table patterns

### Verified Current Rule Notes

The recent H2B implementation and audit work established a few practical rules that should now be treated as current project knowledge:

1. Legacy import now preserves case.
- Type names, property names, and legacy table/column names are no longer forced to lowercase during legacy import.

2. Root model collections default to `one_to_many`.
- If a root-level collection targets model types and there is no explicit `collection`, `manyToMany`, or `oneToMany` override, the importer now classifies it as `one_to_many`.

3. `one_to_many` should not create collection-purpose-only tables.
- The intended shape is target-table reuse plus a backreference on the target rows.
- Any extra helper table that exists only to represent the collection is a bug or parity failure.

4. The current H2B verifier proves that direct root nodes such as:
- `Omi/App.Addresses`
- `Omi/App.Users`
- `Omi/App.Properties`
- `Omi/App.Offers`

already carry `mat[0].mode = one_to_many`.

So the remaining parity gap for synthetic `$App_*` tables is not in importer classification.
It is downstream in schema generation.
