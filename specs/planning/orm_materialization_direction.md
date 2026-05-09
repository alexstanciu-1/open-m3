# Open M3 ORM Materialization Direction

Status: planning draft

Purpose: capture the current direction for turning assembled model information into database structure, with an emphasis on keeping the traversal simple and allowing the same reusable model to materialize differently at different root-relative paths.

## Why This Note Exists

The legacy H2B ORM still contains useful ideas, but it mixes several concerns:

- model traversal
- storage/materialization decisions
- SQL schema object creation
- database synchronization

That makes the flow harder to reason about today.

The current Open M3 direction is to simplify this by keeping traversal as the backbone and moving storage decisions into a thinner planning layer.

The aim is not to reduce traversal.

The aim is to make traversal simpler, more explicit, and easier to reuse.

## Main Assessment

The new ORM should be able to rely primarily on:

- loaded raw models
- assembled path-specific models
- iterative traversal from the root model

This should be enough to discover what must be materialized.

What still needs an ORM-specific layer is not traversal itself, but the interpretation of each path:

- does this path materialize in the parent table
- does it materialize in its own table
- does it materialize in a path-specific table
- does it become a reference column
- does it become a collection table
- is it ignored for storage

So the simplification opportunity is:

- keep one generic traversal
- attach a smaller storage-materialization planner to the traversal output

## Important Requirement: Same Model, Multiple Materializations

The new ORM must support the same reusable model being materialized differently depending on path.

Example direction:

- `app.properties.address` -> `properties_addresses`
- `app.companies.address` -> `companies_addresses`

The exact final table names may differ, but the requirement is clear:

- base `address` stays one reusable semantic model
- assembled `app.properties.address` is one effective usage
- assembled `app.companies.address` is another effective usage
- those two usages may materialize into different tables

This means storage materialization identity cannot depend only on base type.

It must be able to depend on:

- full root-relative path
- effective assembled node
- explicit storage overrides, when present

Path-based tables should not be invented by default.

The current direction is:

- explicit inline materialization may flatten a `struct.sub` into the parent table
- explicit custom table materialization may place a `struct.sub` into a path-specific table
- otherwise a `struct.sub` should use its sub-type default table identity

Example direction:

- base `address` default table -> `addresses`
- `app.properties.address` -> `addresses` unless explicitly overridden
- `app.properties.address` -> `properties_addresses` only when explicitly requested
- `app.properties.address` -> inline only when explicitly requested

## Proposed Simplified Flow

### 1. Traverse

Start from the root model and walk the assembled model graph iteratively.

At each visited node/property, the traversal should know:

- current full path
- current effective model
- current property
- parent path
- whether the property is scalar / `struct.sub` / `struct.ref` / `struct.weakref` / collection
- whether the current usage has local customization

Traversal should stay generic and reusable.

It should not directly create SQL.

### 2. Classify Materialization

For each visited property, the ORM planner should decide one storage role.

Examples:

- scalar column in parent table
- reference column in parent table
- embedded sub-structure in parent table
- owned sub-structure in dedicated table
- collection table
- join table
- ignored / non-stored

For `struct.sub`, the planner should also decide one materialization mode:

- inline in parent table
- dedicated explicit table
- default table of the sub-type

This is the main ORM-specific decision point.

### 3. Build Schema Objects

Once a path is classified, the ORM should build internal schema objects such as:

- table definitions
- column definitions
- indexes
- foreign keys

These should be built from the traversal + classification result, not by re-traversing the model in a second ad hoc way.

### 4. Sync To Database

Only after the in-memory schema definition exists should the DB sync layer compare and apply changes.

## Why Path-Based Assembly Helps

The new assembled model cache already gives us a better foundation than the legacy ORM had.

Instead of inventing a large secondary traversal graph just for SQL setup, we can use:

- raw model cache by type
- assembled model cache by path

This is especially helpful for `struct.sub`, because:

- `address` is reusable
- `company.address` may refine it
- `app.companies.address` may refine it again
- the final storage decision may also differ at each path

So the same semantic base model can produce multiple effective storage targets cleanly.

## What Traversal Must Be Able To Emit

The traversal should eventually provide enough context for a planner record such as:

- path
- assembled model key
- base model key
- parent table candidate
- materialization kind
- target table identity
- target column identity
- ownership mode
- reference target, if any
- collection details, if any

The exact runtime data structures are still open, but this is the shape of information the planner needs.

## Materialization Must Be Two-Way

One important conclusion from the recent legacy audit is that `orm_materialization` is not only a forward storage-planning note.

It needs to support two directions:

1. type/property -> table/column
- used to build schema
- used to plan queries
- used to generate joins and SQL column selections

2. table/column -> type/property
- used to hydrate queried DB data back into the visible model path
- used to understand which branch/type a row fragment belongs to
- likely useful later for CRUD merge and sync logic too

This means `orm_materialization` is really a bidirectional correspondence layer between:

- visible ORM path/type/property semantics
- relational table/column shape

This should be documented early because it strongly affects structure design.

If we only model the forward direction, schema setup may work but query result reconstruction will stay ad hoc.


## One Visible Step May Need More Than One Materialization Branch

The legacy audit also suggests that one visible node/property step may not always be representable by exactly one flat materialization object.

This is most relevant in cases such as:

- non-strict inheritance expansion
- explicit mixed visible types
- collection/join-table branches

The important distinction is:

- ordinary parent/join/target structure is not the interesting problem
- inheritance-expanded visible properties are the higher-value case

Example from legacy Travelfuse:

- `App.MerchItems`
  - visible declared type: `Omi\\Comm\\Merch\\Merch[]`
  - non-strict
  - legacy ORM may expand descendants and therefore consider multiple concrete target materializations for the same semantic purpose

Counter-example:

- `App.Offers`
  - visible declared type: `Omi\\Comm\\Offer\\Offer[]`
  - strict in exported metadata
  - legacy ORM stays on the visible declared type

So the likely direction is:

- one visible `orm_node`
- with one or more materialization branches
- each branch carrying both:
  - forward mapping
  - reverse mapping

This does not force the final class layout yet, but it is the correct conceptual model for the next design step.


## Better Audit Lens

The recent audit also showed that:

- `multi_table`
- `multi_column`
- `collection_table`

are often secondary symptoms, not primary categories.

The more useful primary question is:

- why did this visible property/path branch at all?

The main branch causes observed so far are:

1. ordinary relation structure
- parent table + target table
- sometimes join/collection table too

2. inheritance expansion
- one visible base type
- several concrete descendants

3. explicit mixed visible types
- one property declares multiple visible model targets

4. collection-table semantics
- one property crosses a collection/join table

This is useful because it suggests `orm_materialization` should be organized around branches and their cause, rather than only around final table/column counts.

## Suggested Direction For v1

Start with the simpler cases first:

- scalar properties
- `struct.ref` as reference column
- `struct.sub` as path-sensitive owned structure
- collections only after the singular path is solid

This would let us prove the design on a meaningful case such as `address`.

## First Concrete Materialization Case

The first concrete case to implement should be:

- one reusable base model: `address`
- at least two usage paths:
  - `app.properties.address`
  - `app.companies.address`
- both paths assemble correctly
- both paths can materialize independently

This will prove:

- path-sensitive assembly
- path-sensitive storage identity
- simpler traversal-driven planning

It should also prove:

- default sub-type table reuse works
- explicit path-specific table override works
- explicit inline materialization works

## Deliberate Non-Goals For This Note

This note does not yet define:

- final table naming rules
- exact storage override syntax
- exact one-to-many vs many-to-many defaults
- exact SQL sync algorithm
- exact planner class layout

Those should follow after the traversal-driven materialization approach is validated on the first real case.
