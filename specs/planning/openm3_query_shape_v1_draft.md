## Open M3 Query Shape V1 Draft

### Status

Draft.

This document defines the first practical Open M3 query shape.
It is intentionally narrower than the legacy H2B query surface.

The purpose of this draft is:

- keep the useful selector model from legacy H2B
- simplify parser responsibilities
- assume model/storage/query metadata is already cached
- provide a stable base for ORM query planning


### Design Direction

The query parser should not rediscover model meaning while parsing.

The parser should assume that a cached query structure already exists and can answer:

- what root types are queryable
- what properties are queryable
- what each property branch means
- what relational/materialization shape each branch has
- what path continuations are legal

So the query language is only responsible for:

- selector shape
- filtering shape
- grouping/order/limit shape
- expression placement
- alias placement

Not for resolving deep ORM behavior from scratch.


### Query Result Model

A query starts from a root type or root collection and selects a tree of fields.

The result shape is tree-shaped even when SQL execution may require joins, collection tables, or multiple queries.

At the semantic level:

- a query selects root items
- each selected property may be:
  - scalar
  - reference
  - sub-structure
  - collection
- nested selection is allowed for non-scalar properties


### Root Form

The canonical root form is:

```text
root_type.{ selectors }
```

Examples:

```text
users.{username,email}
properties.{name,address.{city.{name}}}
orders.{status WHERE id=?}
```

Rules:

- `root_type` is the query entry point
- root type names are lowercase canonical Open M3 names
- selector block is required for the v1 root form


### Selector Block

A selector block is:

```text
{ selector [, selector ...] [WHERE ...] [GROUP BY ...] [HAVING ...] [ORDER BY ...] [LIMIT ...] }
```

A selector is one of:

- property selector
- wildcard selector
- expression selector


### Property Selectors

#### Scalar property

```text
users.{username}
properties.{name,stars}
```

#### Nested property

```text
properties.{address.{city.{name}}}
orders.{owner.{name,email}}
```

#### Dot shorthand

The legacy syntax often uses:

```text
address.city.name
```

For Open M3 v1, both of these may be accepted as equivalent:

```text
properties.{address.city.name}
properties.{address.{city.{name}}}
```

Implementation recommendation:

- normalize dot shorthand into nested selector form during parsing


### Wildcard Selector

Wildcard selects all queryable properties of the current node.

```text
properties.{*}
users.{*,owner.{name}}
```

Rules:

- `*` means all queryable properties at the current node
- `*` does not automatically expand recursively
- nested properties still require explicit nested selection unless the nested node itself uses `*`

Example:

```text
properties.{*,address.{*}}
```


### Expressions And Aliases

Expressions are allowed in the select zone.

Examples:

```text
favorite_orders.{max(offer_number) AS max_offer_number}
cities.{group_concat(DISTINCT addresses.properties.id) AS property_ids}
```

V1 rules:

- expression support is allowed conceptually
- parser may treat expression bodies as expression tokens rather than model paths
- aliases use `AS`

Example:

```text
items.{coalesce(name,'') AS display_name}
```


### Filter / Order / Group / Limit Zones

The v1 shape keeps the legacy placement style inside the selector block.

Examples:

```text
users.{id,username WHERE username=?}
properties.{* WHERE active=1 ORDER BY name}
invoices_collected.{number ORDER BY number DESC LIMIT 1}
```

Allowed zone order:

1. `WHERE`
2. `GROUP BY`
3. `HAVING`
4. `ORDER BY`
5. `LIMIT`

Rules:

- zones apply to the current selector block
- nested selector blocks may have their own zones
- parser should preserve zone structure distinctly


### Nested Block Semantics

Each nested block is scoped to the property it follows.

Example:

```text
companies.{name,users.{email,person.{name} WHERE active=1}}
```

Meaning:

- root query is `companies`
- nested query context under `users`
- nested `WHERE active=1` applies to `users`, not to `companies`

This matches the legacy mental model and should remain in Open M3.

Important:

- a nested block is not just a formatting convenience
- it creates a real scoped query context under a property path
- that scoped context has its own:
  - selector set
  - `WHERE`
  - `GROUP BY`
  - `HAVING`
  - `ORDER BY`
  - `LIMIT`

This is one of the most important semantics inherited from legacy H2B.
The planner must preserve it explicitly.


### Collections

Collections are selected the same way as any other non-scalar property:

```text
orders.{items.{quantity,product.{name}}}
companies.{users.{email}}
```

The query shape itself does not expose whether the collection is implemented by:

- child table
- join table
- one-to-many backreference
- many-to-many relation table

That is planner/cache information, not parser syntax.


### References Vs Sub-Structures

The query syntax does not need separate surface syntax for:

- `struct.ref`
- `struct.weakref`
- `struct.sub`

All three are selected through path traversal:

```text
properties.{owner.{name}}
properties.{address.{city.{name}}}
```

Their relational meaning comes from cached structure, not query text.


### Default Join Semantics

By default, path traversal should behave as if joins are `LEFT OUTER JOIN`.

Meaning:

- selecting or traversing a related property does not, by itself, remove the parent row from the result
- missing related data should normally produce `null`-shaped nested values rather than filter out the root item

This is important for selector semantics, especially with nested blocks.

Example:

```text
properties.{name,address.{city.{name}}}
```

If a property has no address or the address has no city, the property row should still remain queryable by default.

Practical rule:

- path traversal implies left-join semantics by default

Filtering may effectively force stricter join behavior.

Example:

```text
properties.{name,address.{city.{name}} WHERE address.city.id=?}
```

In cases like this, the predicate may force the planned SQL to behave like an inner join for that path.

So the intended semantics are:

1. default path traversal is left-outer
2. predicates may force a stricter effective join behavior
3. the parser does not need explicit join syntax for the common case

Open question for later:

- do we ever want explicit query-surface join modifiers, or should join strictness continue to be driven mainly by path filters and planner rules?


### Multi-Type Properties

Some properties may allow multiple model-type branches.

The parser should still allow normal path syntax:

```text
items.{target.{name}}
```

The planner/cached structure must decide:

- whether `target` has one possible branch
- or multiple possible branches
- or requires a type filter

V1 rule:

- query shape does not force type-branch syntax yet
- branch handling belongs to planning/cached metadata

Open question:

- do we want explicit surface syntax later for branch narrowing, beyond legacy `IS_A`?


### Type Filters

Legacy H2B supports:

```text
items.{target IS_A some_type}
```

For Open M3 v1:

- keep `IS_A` as a planned supported feature
- interpret it as type-branch filtering
- actual matching should be performed against cached branch/type info

Example:

```text
orders.{items WHERE product IS_A tfh/property_room}
```

Open question:

- should Open M3 keep `IS_A` exactly, or introduce a clearer type-filter syntax later?


### Subqueries

Legacy H2B uses subqueries inside predicates.

Examples:

```text
countries.{code,name WHERE id IN (SELECT DISTINCT properties.address.country.id)}
companies.{id WHERE id IN (SELECT properties.{owner.id WHERE id IN (?)})}
```

For Open M3 v1:

- subqueries are allowed as a planned feature
- full support may come after the first simpler parser/planner slice

Practical recommendation:

- parser should preserve subquery token structure cleanly
- semantic planning for subqueries can be phased


### Parameters

V1 supports positional bind placeholders:

```text
users.{id,username WHERE username=?}
properties.{id WHERE id IN (?)}
```

This matches legacy usage and is enough for a first slice.

Open question:

- do we also want named parameters in the Open M3 surface later?


### Casing

Open M3 model import is now normalized to lowercase names.

So query examples in the new spec should prefer lowercase:

```text
properties.{name,address.{city.{name}}}
companies.{users.{email}}
```

Even if legacy H2B examples use `Properties.{Name,...}`.


### Parser Output Shape

The parser should produce a logical query tree, not SQL directly.

At minimum, the parsed structure should preserve:

- root type
- selector tree
- zone contents by block
- expressions
- aliases
- path steps
- type filters

Then the planner should bind that structure against cached query metadata.


### Cached Query Structure Expectations

Before parsing/planning, the system should already know at least:

1. Root queryability
- root type name
- root default table or root SQL entry strategy

2. Property branch info
- property name
- path
- scalar/ref/sub/collection classification
- allowed next node types

3. Materialization info
- scalar column
- reference column
- collection table
- join table
- backref / forward ref columns
- inline vs separate table vs default type table

4. Multi-type info
- possible type branches
- branch narrowing rules
- type discriminator details when relevant


### Recommended Traversal Contract For Planning

The planner should work against virtual property branches, not raw authored properties.

One useful planning/traversal unit is:

- one exact path
- one effective property occurrence
- one resolved branch/type interpretation
- one materialization interpretation

This is the unit that query planning, ORM building, CRUD merge, and validation can all share.

For query planning specifically, this unit must also carry the scoped query-context meaning introduced by nested blocks.


### Included In V1

The following should be considered in scope for the first Open M3 query shape:

- root selector syntax
- nested selector syntax
- wildcard
- path traversal
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `LIMIT`
- expressions with aliases
- positional parameters
- parser output as a logical query tree


### Deferred Or Partially Deferred

The following may be parsed early but fully planned/executed later:

- complex subqueries
- explicit multi-type branch syntax beyond `IS_A`
- advanced function semantics
- non-select query forms


### First Working Examples

These are good candidate examples for the first supported surface:

```text
users.{username,email}
properties.{name,address.{city.{name}}}
orders.{status WHERE id=?}
companies.{name,users.{email,person.{name}}}
properties.{* WHERE active=1 ORDER BY name LIMIT 20}
favorite_orders.{max(offer_number) AS max_offer_number}
```


### Open Questions

These need confirmation before this becomes authoritative:

1. Should dot shorthand and nested-block shorthand both remain supported long-term?

2. Should `IS_A` remain the official type-filter syntax?

3. Do we want to support expression selectors fully in the first executable version, or only preserve them syntactically at first?

4. Should subqueries be in the first execution slice, or only in the later query-planning slice?

5. Do we keep only positional `?` parameters in v1, or add named parameters later?


### Working Conclusion

Open M3 should keep the selector-oriented query shape from legacy H2B, but simplify the architecture around it:

- parser reads query shape
- cached structure provides model/storage/query meaning
- planner binds parsed selectors to cached virtual-property branches
- SQL generation happens after that

This should keep the surface familiar while making the internal logic much simpler and more reusable.
