# Open M3 ORM Writer Direction

Status: planning draft

Purpose: define the first practical direction for the new ORM write layer.

This note is about:

- write input shape
- selector-bounded traversal
- level-ordered bucket traversal
- mixed and dynamic input handling
- writer-stage responsibilities

This note is not about:

- API-layer save orchestration
- model-side lifecycle hooks
- SQL dialect rendering details
- read/query planning

## Writer Ownership

The ORM writer must have its own dedicated class and code file.

It should not be treated as:

- a loose helper collection
- a model-attached behavior
- an ad-hoc extension of query or schema code

The writer is its own subsystem and should be implemented as such.

## Why This Note Exists

The legacy write path is tightly coupled to model instances, model state flags, and container-driven recursion.

That is not the right starting point for the new writer.

The new writer must be able to accept:

- model objects
- plain dynamic objects
- mixed nested arrays/maps
- partially typed or untyped values

So the new writer cannot assume that the input object already has:

- a bound model class
- model metadata methods
- internal transform flags
- model-owned traversal behavior

The writer must treat input data and model/storage meaning as separate things.

## Core Direction

The new writer is selector-driven and planner-driven.

It should:

1. accept external input data
2. normalize that input into a writer-facing traversal shape
3. use a selector to define the allowed write surface
4. use cached model/ORM/storage metadata to interpret each selected path
5. produce an explicit write plan
6. execute that plan

The writer should not discover meaning by trusting the runtime class of the input alone.

Another core direction is traversal shape:

- the writer should not do a recursive depth-first walk over the input graph
- it should traverse selector levels using computed buckets of input elements

Another core direction is implementation discipline:

- for the ORM writer internal use and helpers, create structures
- do not use `hash`, `mixed`, or `dynamic` where the structure is known

Performance and memory matter, so internal writer state should use explicit typed structures whenever practical.

## Main Rule

The writer input is not the schema.

The schema meaning comes from:

- destination/root context
- selector
- cached model metadata
- cached ORM/materialization metadata

The input only provides values.

## Input Contract

The first writer slice should accept input in at least these forms:

1. model object input
2. plain object input
3. associative array / map input
4. nested mixed input composed from the forms above

The first writer slice must assume:

- dynamic keys may exist
- runtime value types may be mixed
- child values may be absent, null, scalar, object, array, or list
- the runtime container type is not enough to infer storage meaning

So the writer needs an explicit normalization boundary before traversal logic starts.

## Destination Contract

Because the input may be model-less, the writer needs a separate destination contract.

At minimum, the writer entry point must know:

- the root type or root path being written
- the selector
- the starting point
- the intended write mode

The exact public API can stay open for now, but conceptually the writer must not rely on:

- `get_class($input)`
- input-attached model property metadata
- model-owned recursion methods

It needs an external root interpretation context.

## Starting Point Contract

The writer input is interpreted relative to a `starting_point`.

The expected main inputs are:

- `$data`
- `$selector`
- `$starting_point`
- anchor identity object

### `$data`

`$data` is usually dynamic input, for example coming from decoded JSON.

The writer should not assume `$data` is already a model object graph.

Current direction:

- keep `$data` dynamic

### `$selector`

`$selector` may be provided as:

- string
- parsed selector tree

The legacy `qParseEntity(...)` behavior is still relevant as the conceptual starting point for selector parsing.

With Open M3, selector should become its own named concept and its own class.

So the current direction is:

- define a dedicated selector class
- keep it as a named writer/query structure

For the first slice, the selector internals may still be represented using typed hash/tree structures such as:

- `hash<hash>`

not:

- mixed
- dynamic

The important point is that it is no longer “just some mixed parsed array”.

It is a named selector structure.

Current preferred conceptual shape is recursive and uniform:

```text
"Id, Name, Items.{Something}"
=> ["Id" => [], "Name" => [], "Items" => ["Something" => []]]
```

So the current intended selector rule is:

- each selector value is always another selector/hash node
- leaf selectors use an empty selector node
- the structure is recursive and uniform

If Simple C++ can support it cleanly, the intended direction is close to:

```cpp
struct selector {
    typedef hash<selector, string> _elements;
}
```

The exact final language form may depend on what integrates best into Simple C++, but the design intent is:

- recursive selector structure
- typed
- named
- not mixed

### `$starting_point`

`$starting_point` defines the semantic anchor path for the input data.

This is what tells the writer:

- what node/path the input starts from
- how the selector should be interpreted
- what shape the top-level `$data` is expected to have
- how the explicit anchor identity should be applied

## Default Starting Point

If no `starting_point` is specified, the default entry point is:

- `App`

That means the writer starts from the root `App` context and expects the input data to be shaped from `App`.

Example:

Selector:

```text
Version, Orders.{...}
```

Expected data:

```php
[
    "Version" => 10,
    "Orders" => ...
]
```

## Relative Data Shape

If the entry point is moved deeper, then the input data is expected to start from that deeper path.

Example:

- `starting_point = App.Orders`

Then:

- the selector is interpreted relative to `App.Orders`
- the input data is expected to contain orders
- the outer `App` wrapper is no longer expected in `$data`

So the logical rule is:

- `starting_point` defines the root write context
- `$selector` is evaluated relative to that root write context
- `$data` is expected to match the shape under that root write context

## Starting Point Resolution Rule

If the requested `starting_point` is deeper than root, the writer should first resolve and position itself onto that starting point.

Current direction:

- if we start from a deeper path, the relevant IDs along that path must already be known

- non-root starting points should use an explicit anchor identity object alongside the request

So the writer should have an initial positioning phase that:

- resolves the requested starting point
- verifies the needed identities are present
- establishes the effective root write context for the normal traversal

After that initial positioning phase, the rest of the algorithm should be starting-point agnostic.

## Why Starting Point Matters

This is important because the writer should not force every write request into one global root payload shape.

The starting point allows:

- full-root writes from `App`
- subtree writes such as `App.Orders`
- future narrower write anchors if needed

without changing the core traversal model.

## Internal Structure Rule

The writer may accept dynamic external input.

But internally, once the shape is known, it should switch to explicit structures.

That means:

- use dedicated writer classes/structs for known internal shapes
- avoid `hash`, `mixed`, and `dynamic` for stable internal planning objects
- keep dynamic handling at the normalization boundary, not throughout the full writer pipeline

This matters for:

- performance
- memory footprint
- clearer planner logic
- safer future maintenance

Examples of places that should become explicit structures:

- writer request
- parsed selector node
- bucket entry
- row plan
- column assignment
- grouped write batch
- deferred link operation

Important current exception:

- diff/snapshot payload content cannot be fully fixed in shape because selector and data are both dynamic

So for diff-like payload content, using `dynamic_t` is acceptable where the payload shape is inherently selector-dependent.

For the first pass, this dynamic internal helper payload may be attached under one reserved internal key such as:

- `$$`

This keeps dynamic helper state contained to one predictable slot instead of spreading temporary fields across the normal payload shape.

Example conceptual shape:

```php
[
    "Id" => 123,
    "Name" => "Test",
    "$$" => [
        "read" => ...,
        "decision" => ...,
        "links" => ...,
    ],
]
```

Rules for `$$`:

- `$$` is reserved for writer internal use
- it must never be treated as authored/business data
- it must never be persisted as a normal property
- it may carry temporary read/query/decision/link metadata in the first implementation

## Selector Contract

The writer always works with a selector.

Allowed forms:

- explicit selector tree
- selector string that can be parsed into that tree
- implicit `*` selector when the caller does not provide one

Disallowed form:

- `$selector === true`

If `$selector === true`, the writer must throw an error.

Reason:

- unbounded recursive write traversal is not acceptable in the new writer
- it makes mixed input interpretation too implicit
- it makes safety and predictability much worse

So a missing selector does not mean “no selector”.

It means:

- use implicit `*`

## Default Traversal Rule

If no selector is provided, the writer uses implicit `*`.

Instead it uses a strict fallback:

- traverse only one level through direct properties
- do not traverse collections

The current meaning of implicit `*` is:

- all direct properties except collections

That means the implicit fallback may touch only:

- direct scalar properties
- direct singular reference/sub properties as shallow values

but not:

- nested recursive branches
- collection contents
- arbitrary deep graph expansion

This gives the writer a safe default mode while still allowing narrow writes.

The old legacy-style meaning of:

- `$selector === true`

would be:

- full traversal of whatever input was provided

That mode is not allowed in the new writer.

## Traversal Modes

The new writer should support only these traversal modes:

1. explicit selector traversal
2. shallow one-level fallback traversal

It should not support:

- open recursive traversal
- selector-free collection traversal
- selector-free graph expansion

## Traversal Strategy

The new writer should not use recursive descent as its main traversal engine.

Instead it should use:

- level-ordered traversal
- computed buckets
- selector-aligned processing

That means the writer processes one selector level at a time across many input items together.

This is important because the writer goal is not only correctness.

It is also:

- grouping
- batching
- stable planning
- better SQL execution opportunities

## Bucket Traversal Model

The core traversal shape is:

- one bucket of current data elements
- one parallel bucket of selector nodes
- process both in lockstep
- compute the next level buckets from the current level

Conceptually:

1. start with root input bucket
2. start with root selector bucket
3. process every selected property across the current bucket
4. collect child input values for sub-selectors into the next bucket
5. repeat until no more bucket entries remain

This is breadth-by-level traversal, not recursive path descent.

## Why Bucket Traversal Matters

This direction gives the writer a better foundation for:

- grouping similar writes by path/materialization
- bulk identity lookup
- bulk insert/update planning
- reduced repeated metadata switching
- clearer separation between current level work and next level work

It should be easier to batch work such as:

- all `orders.code`
- all `orders.date`
- all `orders.items`
- all `payments.logs.text`

rather than discovering those one object at a time through recursive calls.

## Performance Note

Performance and memory use are first-class concerns for the writer.

This is an ORM write engine, so it must not be designed around one-row-at-a-time execution as the default mental model.

The writer architecture should assume from the start that high-throughput bulk write patterns are required.

One important practical observation from MariaDB/MySQL is:

- very high write throughput is possible when many compatible row mutations are grouped into bulk statements such as `INSERT INTO ... ON DUPLICATE KEY UPDATE`

The exact observed throughput is workload-dependent, but the architectural lesson is clear:

- grouping is not an optimization detail
- grouping is a core writer requirement

Another practical observation from current testing is:

- bind-heavy execution was not the fastest path in the tested MariaDB/MySQL workloads
- sending larger grouped SQL statements helped more
- especially when many compatible rows could be emitted in one statement with multi-row `VALUES (...) , (...)`

So the current writer direction is:

- favor grouped SQL string materialization for bulk write execution

not:

- assume prepared/bound execution is automatically the fastest path for this ORM writer

## Grouping Is Mandatory

Different DB engines may require different SQL forms for efficient bulk writes.

Examples:

- MariaDB/MySQL:
  - `INSERT INTO ... ON DUPLICATE KEY UPDATE`
- engines with `MERGE` support:
  - `MERGE`
- other engines:
  - engine-specific upsert or staged update/insert patterns

So the SQL text may differ by engine.

But one thing is required across engines:

- the writer must group compatible operations before execution

That means grouping is part of the logical writer design, not only part of the SQL emitter.

## Current SQL Materialization Direction

For now, the writer should plan toward SQL string materialization for grouped bulk writes.

In practical terms this means:

- build grouped write batches
- materialize those groups into SQL strings
- prefer multi-row `VALUES` forms where the engine benefits from them

This is the current intended direction for execution.

It does not mean every future engine path must avoid binds in all cases.

It means the current writer architecture should not be centered on a prepared-statement-per-row model.

## Current Execution Preference

For the current writer direction, prefer:

- fewer larger grouped SQL statements
- string-materialized bulk `INSERT` / `UPSERT` / `MERGE` forms
- engine-aware batching strategies

over:

- many small bound executions
- row-by-row prepared statement loops

## Performance Rule

The writer should separate:

1. semantic write planning
2. grouping of compatible operations
3. engine-specific SQL materialization/execution

The grouping stage is what allows one logical write plan to be emitted differently for:

- MariaDB/MySQL
- PostgreSQL
- SQL Server
- SQLite
- future engines

without losing the performance benefits of bulk execution.

## Memory Rule

Because performance and memory both matter, grouping should not imply building arbitrary huge temporary structures without bounds.

The writer should be designed so it can:

- process level buckets incrementally
- group compatible operations efficiently
- optionally flush grouped write batches in chunks
- materialize grouped SQL strings in bounded chunks

This matters because:

- bulk execution improves throughput
- but unbounded accumulation can hurt memory usage and latency

So the design goal is:

- aggressive grouping
- controlled memory growth

not:

- eager row-by-row execution
- or unbounded collect-everything-first behavior

## Example Shape

Given input:

- `$data` is a list of `Orders`

and selector:

```text
Code,
Date,
Items.{Offer.{Code}, Quantity, Price},
Payments.{Date, Logs.{Date, Text}}
```

the traversal should behave conceptually like:

- current bucket contains the order list
- current selector contains the root order selector
- processing `Items` gathers all selected item values for the next level
- processing `Payments` gathers all selected payment values for the next level
- the next loop processes item-level and payment-level buckets in parallel
- deeper nested buckets such as `Offer` and `Logs` are computed only from the selected child paths

## Computed Bucket Rule

Each bucket element should be computed, not implied by recursion.

A bucket element should carry enough context to say:

- what normalized input elements are being processed
- what selector node applies
- what root/type/path context applies
- what parent write context produced this bucket

The exact class shape is still open, but the idea is:

- current work is explicit data
- next work is explicitly materialized into new bucket entries

not:

- hidden in recursive call frames

For the current direction, the traversable fields are provided by the selector.

So bucket traversal should not rediscover field lists from raw input.

It should use the selected fields already declared by the selector node.

## Selector-Driven Expansion Rule

Only sub-selectors create next-level bucket entries.

If a selected property has no nested selector:

- it is processed at the current level
- it does not produce a next-level bucket

If a selected property has a nested selector:

- child values are collected
- empty child groups do not create next-level bucket entries

So traversal expansion is governed entirely by selector structure.

## Shallow Fallback Under Bucket Traversal

The shallow fallback rule still applies.

If no selector is provided:

- build one synthetic one-level selector
- process only direct non-collection properties
- do not compute child buckets for nested descent

So the fallback still uses the same traversal engine, just with a constrained selector.

## Collection Rule

Collections are never traversed implicitly.

A collection may be written only when the selector explicitly includes that collection path.

If the writer is in the shallow fallback mode:

- collections are skipped
- or rejected if the caller attempts to pass collection payload for traversal

The exact skip-vs-error policy can still be decided, but the important rule is:

- no implicit collection descent

## Mixed-Type Rule

The new writer must assume that runtime values may not match the ideal authored type shape.

Examples:

- scalar where model-like object was expected
- plain object where typed model object was expected
- mixed list elements with different runtime forms
- null at any nested point

So the writer must separate:

1. runtime value inspection
2. path semantic interpretation
3. write action planning

It should not collapse those into one recursive method.

## Normalization Boundary

Before semantic traversal starts, the writer should normalize external input into a writer-facing node/value shape.

The purpose of normalization is not to fully type the data.

The purpose is to provide a stable traversal surface such as:

- is value missing vs present
- scalar vs object-like vs list-like
- stable key iteration
- stable child access
- stable null handling

This normalization layer should avoid attaching fake model behavior to raw data.

It should remain a thin adapter over mixed input.

The normalized shape should also be suitable for bucket traversal:

- stable iteration over current-level elements
- stable extraction of child values for next-level buckets
- stable distinction between singular child and collection child payload

## Semantic Interpretation Rule

After normalization, the writer interprets each path using metadata, not runtime guesswork.

For each selected path it should answer:

- is this path writable
- is it scalar, singular ref, singular sub, or collection
- what materialization route owns this path
- what table/column/relation identity is affected
- what child interpretation context applies

This means the writer should depend on the ORM planner output, or an equivalent cached write-facing contract, rather than inventing SQL meaning directly from the raw selector.

## Read Before Write Rule

When IDs are present, the writer should read existing data first before deciding what to write.

Reason:

- if a record would not actually change, the writer should not emit or append a write query for it

This pre-planning step saves execution time and reduces unnecessary write traffic.

So the writer should support:

1. identify rows with known IDs
2. bulk-read the existing DB state for those rows
3. compare planned values against existing values
4. prune no-op row writes where possible

Current implementation direction refinement:

- first pass may perform writes directly where there is no existing data to read yet
- then read existing state where IDs are available and where comparison is meaningful

## Identity Rule

For the first writer slice, row identity matching is based on `Id` only.

So the current rule is:

- if `Id` is present, try to match/read existing row state
- if `Id` is not matched, treat it as insert

No other identity matching rule is in scope yet for v1.

## No-Op Pruning Rule

If a row has no effective change, the writer should avoid emitting a write for that row.

One practical nuance still applies:

- a cell/column may still appear in the final grouped SQL shape even if not individually changed, when that is useful for batching compatible rows together

But the important rule is:

- the decision about whether a row needs writing should happen before final SQL materialization

not after the queries are already committed to string form.

At the end, if a write request makes no effective changes, there should be:

- no `INSERT`
- no `UPDATE`
- no `DELETE`

Only `SELECT` work should have happened.

## First Writer Pipeline

The first practical writer flow should likely be:

1. validate destination and selector
2. reject unsupported selector forms such as `true`
3. normalize raw input into writer input nodes
4. resolve root write context
5. build the initial traversal bucket
6. traverse the data/input via the selector using bucket-based level traversal
7. prepare internal row/cell/link planning structures during traversal
8. select/query existing DB data for elements with IDs
9. for collections, read existing collection-linked data only where IDs are available
10. diff and prune no-op writes
11. prepare grouped primary queries such as `INSERT` and `UPDATE`
12. execute primary queries
13. resolve IDs for inserted rows
14. based on the information collected during traversal/read, prepare link queries
15. execute link queries only where needed

This keeps interpretation separate from execution.

## Current Algorithm Shape

The main algorithm shape is currently:

1. traverse the data/input using the defined selector-driven bucket method
   - at this step the writer prepares internal data
2. select/query existing data for elements with IDs
   - for collections, select only where IDs are available
3. prepare primary queries
   - `INSERT`
   - `UPDATE`
   - `DELETE` can come later
4. execute primary queries
5. based on the information collected at steps 1 and 2, prepare and execute the link queries

This is the current intended execution flow.

## Level Processing Rule

Within one bucket-processing step, the writer should try to group work by computed path/materialization shape.

That means one level may first classify work into groups such as:

- same root type
- same property path
- same materialization route
- same target table
- same operation kind

Only after that should it emit concrete write-plan operations.

This gives the writer a path toward efficient batched SQL.

## First Grouping Rule

For the first writer slice, two write operations are group-compatible when:

- they come from the same selector path
- and target the same materialized table

So the first conceptual grouping key is:

```text
group_key = selector_path + materialized_table
```

Why this is a good v1:

- selector path keeps semantic intent together
- materialized table keeps relational destination together
- it avoids over-merging writes that only happen to land in similar shapes
- it is easy to compute during bucket traversal

One small practical extension still applies:

- operation kind should probably still split groups internally

For example:

- `insert` / `upsert`
- `delete-link`
- plain `update`

So the conceptual compatibility rule can stay:

- selector path + materialized table

and the execution planner can still subdivide by SQL operation type when needed.

For relation/link groups, the current grouping direction is:

- group by table
- and target column or target column set

## Write Plan Direction

The writer should produce a typed in-memory write plan before SQL execution.

That plan should be the place where we record decisions such as:

- insert vs update vs delete-link vs delete-row
- target table identity
- target row identity if known
- scalar column assignments
- reference assignments
- deferred backreference work
- collection helper-table work
- grouped bulk-upsert candidates

The write plan should preserve grouping information when possible.

The goal is not only to know what must be written.

It is also to know what can be written together.

The writer should keep data in explicit planning structures until the very last moment when SQL queries are materialized.

This is important because:

- read-before-write may remove planned writes
- grouping may reshape the final execution batches
- insert ID recovery affects later linking work
- second-pass reference/collection operations depend on resolved row identities

The exact class layout is still open, but the direction should match the new ORM philosophy:

- explicit internal structures first
- DB execution second

## SQL Materialization Timing Rule

The writer should not materialize final SQL too early.

It should keep internal write data in structured form until:

- read-before-write pruning is done
- grouping is finalized
- primary write batches are decided

Only then should it produce SQL strings for execution.

So the intended order is:

- plan first
- prune second
- group third
- materialize SQL last

## Insert ID Recovery Rule

The writer needs an explicit strategy for recovering inserted row IDs when multiple rows are inserted in one query.

This should be treated as a first-class planning concern, not as an afterthought.

One likely consequence is that the writer may need to distinguish between:

- pure inserts
- grouped writes that target already-existing rows
- mixed insert/update forms such as `INSERT ... ON DUPLICATE KEY UPDATE`

The current direction is that these may need to be split deliberately when ID recovery or later linking would otherwise become ambiguous.

For the first pass, keep the implementation simple:

- use the last insert id
- decrement for the earlier rows in the same grouped insert result

This should be treated as a temporary first-pass strategy only.

Add implementation note:

- this needs to be improved later
- do not let this delay the first writer implementation

## Sequence Direction

Current practical direction:

- start with sequence-based ID allocation

Reason:

- MySQL does not naturally return all inserted row identities for grouped multi-row writes in the way the writer needs
- relying on ordinary auto-increment behavior makes grouped identity recovery awkward

So the current intended direction is:

- do not center the writer on auto-increment identity recovery
- start with an explicit sequence mechanism

Example conceptual direction:

- allocate IDs from a sequence before grouped insert execution

The exact engine-specific implementation can evolve later, but sequence-first is the current starting point.

This sequence direction remains the preferred improvement path even if the first implementation temporarily uses the simpler last-insert-id fallback above.

## Insert/Upsert Split Direction

It may be necessary to split:

- pure `INSERT`
- `INSERT ... ON DUPLICATE KEY UPDATE`

in order to keep row identity handling clear.

One current working direction is:

- pure inserts handle rows that do not yet exist and need new IDs
- duplicate/update-style grouped writes handle rows that are already known in the DB

This keeps insert ID recovery more predictable and may simplify later link planning.

## Second-Pass Linking Rule

References and collections should be linked in a second pass after row IDs are known.

This applies especially to:

- singular references that depend on inserted targets
- one-to-many linking
- many-to-many/helper-table linking

So the writer should likely separate:

1. primary row writes
2. ID resolution / assignment
3. relation/link writes

This keeps relation work from racing ahead of identity resolution.

The legacy ORM concept remains valid here:

- anything that is linked via an ID should be handled in this second pass

Link queries should be executed only if needed.

So the writer should not automatically emit relation-link work just because a path was traversed.

It should emit link queries only where the prepared data actually requires link changes.

When existing relation data is read and link batches are prepared carefully, duplicates may already be avoided naturally.

Proper indexing may also help reject or neutralize accidental duplicates, but the writer should still plan link batches carefully rather than rely on the DB to clean everything up.

Important many-to-many caution:

- both directions of the relation must resolve to one canonical indexing/link identity

For example, avoid ending up with one direction planned as:

- `column_1, column_2`

and the reverse direction planned as:

- `column_2, column_1`

The writer and ORM relation planning must agree on one canonical ordering/identity for many-to-many link rows and indexes.

## What The Writer Should Not Assume

The new writer should not assume:

- every input is a `QIModel`
- every object has an id getter
- every changed field is tracked by `_wst`
- every collection has row-id helpers
- every value already knows its transform state
- recursion behavior lives on the data object itself
- recursive call-stack traversal is the natural execution model
- early SQL materialization is harmless
- dynamic/hash-based internal planner state is acceptable when the shape is known

Those are legacy conveniences, not valid writer foundations.

## Relationship To The New ORM

The writer should reuse the new ORM meaning wherever possible.

That means:

- model metadata defines visible writable paths
- ORM/materialization metadata defines storage meaning
- writer planning defines concrete write actions

A useful mental split is:

1. model layer
   - what the path means semantically

2. ORM/materialization layer
   - where that path lives relationally

3. writer layer
   - what mutations must happen for this input and selector

The writer layer should add one more explicit idea:

- level-ordered grouping

So it is not just:

- interpret one object
- recurse
- emit SQL

It is:

- interpret one selector level across many elements
- group compatible work
- plan bulk writes
- compute next-level buckets

## First-Slice Scope

The first writer slice should focus on:

- one root write context
- explicit selector tree input
- shallow fallback when selector is omitted
- bucket-based level traversal
- explicit internal writer structures
- read-before-write for known IDs
- no-op pruning before SQL materialization
- merge / insert / update / delete actions
- direct scalar writes
- direct singular reference writes
- explicit nested singular traversal

Later relation linking may still happen in a dedicated second pass.

## Transform State Rule

The writer needs transform state/action support.

The default action is:

- `merge`

But an element may explicitly request another action such as:

- `insert`
- `update`
- `delete`

This is the same general concept as the legacy ORM transform state and should remain in the new writer.

Example conceptual transport form:

```php
[
    "Orders" => [
        "&" => 2,
        "Id" => 8767,
    ]
]
```

Where:

- `&` carries the transform state/action
- for example `2 = delete`

The exact enum/constants should be formalized later, but the writer must support per-element explicit transform action.

Current direction:

- take the transform state constants from the legacy ORM `QModel*.php` files

## Internal Data ID Rule

When data is transported through JSON or other dynamic formats, object identity may be lost if DB IDs are not present.

So the writer also needs an internal transport-level data identity marker.

Current direction:

- support an internal data id such as `#`

Purpose:

- detect that two payload fragments refer to the same logical in-memory object
- avoid processing the same transported object twice
- preserve shared-reference semantics across dynamic payloads

Important rule:

- `#` is request-graph identity only
- it is not persistence identity
- it must never be used for DB row matching

Example:

```php
[
    "Cities" => [
        [
            "Name" => "Brasov",
            "Country" => [
                "Code" => "RO",
                "#" => 1,
            ],
        ],
        [
            "Name" => "Covasna",
            "Country" => [
                "Code" => "RO",
                "#" => 1,
            ],
        ],
    ],
]
```

In that case, both `Country` payloads should be understood as the same transported object identity.

So the writer should be able to:

- track internal transported-object ids
- deduplicate processing where appropriate
- preserve later linking behavior consistently

## Collection Uniqueness Rule

Collections of objects should remain unique by default.

That means:

- the same object should not be added twice in the same object collection

This is the current default direction and it keeps the writer aligned with the legacy ORM behavior.

Important scope note:

- this rule is for collections of objects
- scalar collections may need separate confirmation against legacy behavior

So for now the intended rule is:

- object collections are unique by default
- duplicate object links in the same collection should not be emitted as repeated relation entries

## Open Questions

These points still need a focused follow-up discussion:

1. What is the minimal public writer entry contract:
   - root type name
   - root path
   - destination object
   - or a dedicated write request object

2. In shallow fallback mode, should unsupported nested/collection payload be:
   - ignored
   - collected as issues
   - or rejected immediately

3. What is the first stable write-plan class set:
   - root plan
   - row plan
   - column assignment
   - relation op
   - deferred fixup

4. How much identity lookup should happen before plan building versus during execution

5. What is the minimal bucket entry structure:
   - values only
   - values plus path context
   - values plus parent row/write linkage

6. At what stage should grouping be frozen:
   - during bucket processing
   - after per-level classification
   - or only in the final execution planner

7. What is the exact ID recovery strategy for:
   - pure bulk inserts
   - mixed upsert-style execution

8. Which internal planning structures should exist in the first concrete implementation:
   - writer request
   - bucket entry
   - row snapshot
   - row diff
   - write batch
   - deferred relation batch

## Current Recommendation

For the next step, the writer discussion should stay narrow and define:

- the writer request object
- the normalized input node shape
- the selector validation rules
- the bucket entry shape
- the first write-plan object model
- the grouping contract for bulk write planning
- the read-before-write snapshot/diff structures
- the insert ID recovery strategy
- the second-pass linking structures

That is the smallest useful foundation before discussing SQL execution details.

## Bulk Write Direction

One of the main benefits of bucket traversal is better bulk-write planning.

If one level produces many compatible row mutations for the same relational target, the writer should try to keep them together as grouped operations.

Examples of useful grouped execution targets:

- multi-row `INSERT`
- `INSERT ... ON DUPLICATE KEY UPDATE`
- SQL `MERGE` where supported
- batched grouped `UPDATE`

The exact SQL form is database-specific and belongs to a later layer.

But the writer planner should preserve enough grouping information so the SQL executor can choose efficient bulk forms instead of degrading immediately into one-row-at-a-time execution.

For the current direction, that bulk form should be assumed to be string-materialized SQL first.
