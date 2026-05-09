## Legacy H2B Query Notes

### Purpose

This note captures the practical shape of legacy H2B `QQuery(...)` usage and the main responsibilities of `QModelQuery.php`.

The goal is not to preserve the old implementation structure.
The goal is to understand:

- how legacy queries look
- what the parser/planner really needs
- what should be precomputed into a cached structure before parsing


### Main Files

Legacy query parsing and planning starts from:

- `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/query/model/QModelQuery.php`

Legacy cached relational/type metadata is built in:

- `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/query/sql/QSqlModelInfoType.php`


### High-Level Legacy Flow

The legacy flow is:

1. `QQuery(...)` / `QModelQuery::Query(...)`
2. tokenize query text with `Parse(...)`
3. build parser/query structures with `QueryToStructInner(...)`
4. walk tokens and resolve identifiers with `BuildQuery(...)`
5. use cached SQL/type metadata from `GetTypesCache(...)`
6. produce SQL parser/query objects that are ready to execute

Important design takeaway:

- the parser does not want to discover the full model/storage meaning from scratch every time
- it expects type/property SQL meaning to already be available in cacheable form


### What `QModelQuery.php` Really Does

At a practical level, `QModelQuery.php` does four jobs:

1. Tokenization
- split the textual query into strings, numbers, identifiers, operators, keywords, functions, punctuation

2. Structural parsing
- understand root selectors like `Orders.{...}`
- understand nested paths like `Orders.Items.Product.Name`
- understand nested select blocks like `Address.{City.{Name}}`

3. Zone management
- track `SELECT`
- track `WHERE`
- track `GROUP BY`
- track `HAVING`
- track `ORDER BY`
- track `LIMIT`

4. Identifier resolution
- turn a path/property token into relational meaning using cached type metadata
- decide whether a step is scalar, reference, collection, multi-type, etc.

This also reveals the main architectural issue in the legacy implementation:

- syntax parsing and relational planning are tightly interwoven

That works, but it makes the code harder to reason about and harder to simplify.

The Open M3 direction should keep the language shape while separating the phases more clearly:

1. parse query shape
2. bind parsed nodes to cached query/model/storage metadata
3. build query plan
4. generate SQL


### Practical Query Shape

The legacy query language is selector-oriented.

The common base form is:

```text
RootCollection.{ selector [, selector ...] [WHERE ...] [GROUP BY ...] [HAVING ...] [ORDER BY ...] [LIMIT ...] }
```

Examples:

```text
Users.{Username, Type}
Orders.{Status WHERE Id=?}
Projects.{* ORDER BY Name}
```


### Common Selector Forms

#### 1. Simple properties

```text
Properties.{Name}
Users.{Username, Email}
Countries.{Code,Name}
```

#### 2. Wildcard selection

```text
Offers.*
Properties.{* WHERE 1 GROUP BY Id}
Properties.{*,Address.{*,City.*,County.*,Country.*}}
```

#### 3. Nested property traversal

```text
Properties.{Address.{Latitude, Longitude}}
Properties.{Name, Address.{City.Name}, Owner.{Name, VAT_No}}
Orders.{Id, Owner.{Id, Accessible_By.{Name, Has_Access_To.Name}} WHERE Id=?}
```

#### 4. Nested collections

```text
Companies.{Name, Users.{Person.{Name, Firstname}, Email, Phone}}
Orders.{Items.{Config.{Room_Name, Rate_Plan_Name, Room.Name, Rate_Plan.Name}}}
Properties.{Rooms.{Index,Rates_Indexes.{Rate_Plan,Index}},Store_Locations WHERE Id=?}
```

#### 5. Predicates

```text
Users.{Api_Key WHERE Api_Key=? LIMIT 1}
Cities.{Id,Name,County.Name WHERE Id IN (?) ORDER BY Name}
Orders.{Status, Date WHERE Status='Submitted' AND (Change_Status_Email_Sent=0 OR Change_Status_Email_Sent IS NULL)}
```

#### 6. Grouping, ordering, limiting

```text
Properties.{* WHERE 1 GROUP BY Id}
Invoices_Collected.{Number ORDER BY Number DESC LIMIT 1}
Users.{Id,Username,Active WHERE Username=? ORDER BY Id LIMIT 1}
```

#### 7. Expressions and aliases

```text
Cities.{GROUP_CONCAT(DISTINCT Addresses.Properties.Id) AS Properties_Ids_ ...}
Store_Locations.{COALESCE(Addresses.City.TFH_Search_City.Id, 0) AS TFH_Search_City_Id_ ...}
Favorite_Orders.{Id, MAX(Offer_Number) AS MAX_Offer_Id}
```

#### 8. Subqueries

```text
Countries.{Code,Name WHERE Id IN (SELECT DISTINCT Properties.Address.Country.Id)}
Companies.{Id WHERE Id IN (SELECT Properties.{Owner.Id WHERE Id IN (?)}) AND Is_Property_Owner=1}
Offers.{Code,Name WHERE Owner.Id=(SELECT Properties.{Owner.Id WHERE Id=?})}
```

#### 9. Dynamic selectors

These are very common in H2B and matter for parser design:

```text
"Orders.{".$selector."}"
"Properties.{{$filter_out_selector} WHERE Id IN (?)}"
"{$app_property}.{Id WHERE Remote_Id=? AND {$owner_path}=? LIMIT 1}"
```

This means:

- the parser must accept final query text after interpolation
- but documentation should acknowledge that selectors are often assembled dynamically


### Observed Legacy Keywords and Features

From `Parse(...)` and `BuildQuery(...)`, practical supported syntax includes:

- `SELECT`
- `UPDATE`
- `DELETE`
- `INSERT`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `LIMIT`
- `AS`
- `DISTINCT`
- `CASE ... THEN ... ELSE ... END`
- `IS NULL`
- `IS NOT NULL`
- `BETWEEN`
- `LIKE`
- `IN`
- `IS_A`
- SQL functions like `MAX(...)`, `COALESCE(...)`, `GROUP_CONCAT(...)`

Special note on `IS_A`:

- legacy logic translates `Property IS_A SomeType`
- into a type-id filter such as `IN (...)`
- using storage type ids for the target class and descendants


### The Important Legacy Design Insight

The parser is not fundamentally driven by raw model properties.

It is driven by already-prepared relational/type meaning per property, such as:

- scalar value column
- reference column
- collection table
- collection forward/back-reference columns
- possible referenced model types
- join tables per type

This is why the new implementation should aim for:

- logic first
- cached structure second
- parser third

The parser should assume the data is ready.

Another important insight from `QModelQuery.php` is that the useful unit is not just the authored property.

The useful unit is closer to a virtual property branch:

- one property occurrence at one exact path
- under one query context
- with one resolved type/materialization meaning


### Legacy Strict vs Non-Strict Expansion

Another important legacy rule sits below `QModelQuery.php`, in type/property metadata:

- `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/model/type/QModelProperty.php`

The legacy query/ORM stack distinguishes:

1. strict reference properties
- only the visible declared type is used
- descendants are not expanded

2. non-strict reference properties
- the declared type acts as a visible base type
- descendants are expanded through `QAutoload::GetClassExtendedBy(...)`

This behavior is visible in methods such as:

- `isMultiType()`
- `getAllReferenceTypes()`
- `getAllInstantiableReferenceTypes()`
- `GetAllInstantiableTypesFor(...)`

This matters because some “multiple table” legacy cases are not ordinary relation structure.
They are the result of non-strict inheritance expansion for one visible property purpose.

Practical Travelfuse example:

- `App.MerchItems`
  - declared as `Omi\\Comm\\Merch\\Merch[]`
  - exported metadata does not mark it strict
  - legacy logic may therefore expand descendant merch types

Counter-example:

- `App.Offers`
  - exported metadata is marked `strict: true`
  - legacy logic should keep only the visible `Omi\\Comm\\Offer\\Offer[]` type

This distinction should be preserved in Open M3 planning notes because it affects whether one visible path step may legitimately need:

- one target type/table
- or several concrete target types/tables for the same semantic role

This is the unit that the legacy implementation effectively works with while resolving identifiers.


### Legacy Cached Structure Clues

`QSqlModelInfoType::CacheSqlData(...)` prepares a compact per-type structure.

Important root-level keys include:

- `#%tables`
- `#%table`
- `#%id`
- `#%misc`

Per-property keys include:

- `vc`
  scalar value column

- `rc`
  reference column

- `o2m`
  one-to-many marker

- `cid`
  collection row id

- `refs`
  possible referenced model types

- `j`
  join tables grouped by type

- `cb`
  collection back-reference column

- `cf`
  collection forward-reference column

- `cv`
  collection value column

- `ct`
  collection table

This is not the final shape Open M3 must copy.
But it is very strong evidence for what the query planner wants precomputed.


### What The New Cached Structure Should Probably Answer

Before query parsing begins, the new cached structure should ideally answer:

1. Root type info
- root collection/type name
- default table
- id column
- type discriminator info if relevant

2. Property branch info
- property name
- property path
- allowed type branches
- scalar vs ref vs weakref vs sub vs collection

3. Relational materialization info
- value column
- ref column
- join table if any
- collection table if any
- backref/forward columns
- inline vs separate table vs default type table

4. Query traversal info
- which path steps are legal
- what next model/type a path step reaches
- whether the step expands into multiple type branches


### Recommended New Traversal Unit

For query planning, one callback per raw property is not enough.

The useful unit is one virtual property branch:

- one exact path
- one effective property occurrence
- one resolved type branch
- one materialization interpretation

Examples:

- `app.properties.address` as owned substructure using table `addresses`
- `orders.items` as collection through its collection table
- `owner` as reference through `owner_id`

This matches the old parser’s actual needs much better than raw property traversal.

It also matches what `handleIdentifier(...)` is effectively doing today:

- take current query/model context
- resolve one property step
- determine whether it is scalar/ref/collection/multi-type
- determine what query context comes next
- determine what relational materialization path comes next


### Proposed Direction For Open M3 Query Work

1. Document the practical query shape
- root selector
- nested selectors
- filters/grouping/order/limit
- expressions/aliases
- subqueries

2. Build a cached query structure
- prepared from model assembly plus DB materialization info
- no heavy logic inside the parser

3. Make parser consume cached structure
- resolve path steps quickly
- expand type branches predictably
- avoid rebuilding ORM/storage meaning during parse


### Suggested First Documentation Scope For The New Query Spec

The first Open M3 query spec should probably define:

- root selector syntax
- nested selector syntax
- filter/order/group/limit placement
- aliases
- wildcard behavior
- path semantics
- multi-type branch semantics
- what query-time data must already be cached


### Working Conclusion

The old query layer is complicated mainly because parsing and relational interpretation are tightly interwoven.

The new direction should be:

- keep the practical query shape
- simplify the parser’s responsibilities
- move model/storage interpretation into a reusable cached structure

That will help all consumers, but it is especially important for query planning, which is the hardest consumer of traversal.
