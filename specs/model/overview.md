# Open M3 Model

Status: draft

Purpose: define the high-level direction and restrictions for the Open M3 model layer.

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
- what rules and constraints apply

The model layer may drive storage and view.

Storage and view must not define core model meaning.

Within an explicit model definition context, model-native attributes should be written without the `model.` prefix.

Root/default data-class selection should live in the top-level data definition rather than on the model itself.

## Naming And Resolution

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
| No abstract storage identity | An abstract model must not define storage of its own. |
| No model interfaces | Interfaces are out of scope for the model layer. Empty abstract models may be used instead. |

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
| Root-bound strong reference | `struct.ref` is a string naming the expected root entry, such as `Cities` or `Countries`. |

## Structural Direction

| Concept | Meaning |
| --- | --- |
| `struct.ref` | Strong reference to another model object, bound to an expected root entry such as `Cities` or `Countries`. |
| `struct.weakref` | Weak or non-owning reference to another model object. |
| `struct.sub` | Contained sub-structure rather than external reference. |
| scalar | Scalar properties do not use `struct.*` attributes. |

These structural concepts should be expressed at model level, not inferred later from storage or view metadata.

## Sub-Structure Refinement

For `struct.sub`, the effective model may depend on the full path from the root model.

Examples:

- `Hotels.Address`
- `Customers.Address`

These may share the same base model while still needing different local refinements.

This path-sensitive refinement applies to `struct.sub`.

The refinement reuses the same `properties` shape as a normal type definition, but in that case it acts as a local specialization block rather than the primary type definition block.

It does not apply in the same way to `struct.ref` or `struct.weakref`, which should keep stable target meaning.

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
| System-computed internals | The system may compute internal abstract/extends relationships automatically for refined submodels. |

## Practical Direction

| Topic | Direction |
| --- | --- |
| Simplicity | Prefer local structural refinement over explicit manual inheritance trees. |
| Reuse | Keep reusable base models stable. |
| Local control | Allow `struct.sub` usages to refine a base model in place. |
| Safety | Limit refinement to add/disable operations so projects do not become structurally inconsistent. |

## Recommended Direction

| Recommendation | Description |
| --- | --- |
| Model first | Model attributes should drive storage and view attributes, not the other way around. |
| One semantic source | Core meaning should be authored once in the model layer. |
| Folder-based resolution | Namespace and type lookup should follow folder structure and relative file-like paths by default. |
| Derived projections | Storage and view should derive from model semantics and only add layer-specific details. |
| Shared polymorphic materialization | If a property references an abstract model, it is recommended that concrete derived types materialize together for performance. |
