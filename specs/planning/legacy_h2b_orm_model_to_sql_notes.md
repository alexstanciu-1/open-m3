# Legacy H2B ORM Model-To-SQL Notes

Status: planning notes

Purpose: capture how the legacy H2B ORM converts model metadata into tables, columns, indexes, and SQL sync operations.

This is not a normative spec.

It is a reference note to help simplify the new Open M3 ORM.

## Main Entry Point

The legacy flow starts from application bootstrap.

In [QApp.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/controller/QApp.php), the data setup path eventually triggers:

- `QSqlModelInfoType::ResyncDataStructure(null, $do_auto_structure_sync)`

That is the main “recompute schema from model metadata” entry point.

## High-Level Flow

The legacy ORM does not directly emit SQL from model classes.

It follows this sequence:

1. determine the root data class
2. refresh model-to-table mapping caches
3. build an in-memory traversal/planning graph
4. build in-memory SQL schema objects
5. sync those schema objects to the actual database

This means the key intermediate layer is not SQL text.

It is an in-memory relational model.

## Core Classes

The main classes involved are:

- [QSqlModelInfoType.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/query/sql/QSqlModelInfoType.php)
- [QSqlModelInfoProperty.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/query/sql/QSqlModelInfoProperty.php)
- [QSqlTable.class.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/query/sql/QSqlTable.class.php)
- [QStorageTable.class.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/storage/table/QStorageTable.class.php)
- [QSqlTableColumn.class.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/storage/sql/QSqlTableColumn.class.php)
- [QSqlTableIndex.class.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/storage/sql/QSqlTableIndex.class.php)
- [QSqlForeignKey.class.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/storage/sql/QSqlForeignKey.class.php)
- [QMySqlStorage.class.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/query/sql/QMySqlStorage.class.php)

## Stage 1: Refresh Table Mapping Caches

`QSqlModelInfoType::RefreshTypeTableList(...)` builds the key caches used later by setup.

The main caches are:

- `TableTypeList`
- `TablePropertyList`
- `TablePropertyTypesList`
- `PropertiesWithTypes`
- `PropertiesWithRefs`

### Type -> Table

`TableTypeList` maps one model type to one SQL table name.

The mapping is driven by:

- type storage metadata such as `storage["table"]`
- property-level forced table metadata such as `storage["table"]` or `storage["table:Type"]`
- inheritance / extended-by traversal

Important observation:

- a type does not automatically get a table
- if no table is explicitly specified, the code often skips table creation for that type

### Collection Property -> Table

`TablePropertyList` maps a collection property to its collection table.

For one-to-many:

- the code expects the collection target types to land in one compatible target table
- the collection property reuses that target table

For non-one-to-many collections:

- the collection table is either explicitly specified by storage metadata
- or defaults to `parent_table . "_" . property_name`

This is one of the main legacy sources for dedicated collection tables.

## Stage 2: Build The Traversal/Planning Graph

`QSqlModelInfoType::CreateRoot(...)` creates a root planning node from the data class.

From there:

- `setEntityProperty(...)` attaches model properties
- `setEntityType_under(...)` attaches referenced model types
- `setAcceptedType(...)` attaches collection accepted types

This builds a mixed graph of:

- type nodes
- property nodes
- collection accepted-type nodes

The graph is used both for traversal and for relational planning.

## Stage 3: Setup Tables

`QSqlModelInfoType::setup(...)` is the main traversal/setup method.

For each type node it first calls:

- `setupTable(...)`

### What `setupTable(...)` Does

`setupTable(...)` decides where a type or collection usage lives and ensures a `QSqlTable` exists.

It:

- resolves table name for a plain type with `GetTableNameForType(...)`
- resolves collection table name with `GetTableNameForCollectionProperty(...)`
- resolves the database name if the table name is in `db.table` format
- loads an existing table from storage or creates a new `QSqlTable`
- ensures table metadata:
  - charset
  - collation
  - comment
  - engine
- ensures base columns:
  - row id / id
  - type discriminator column for multi-type tables
  - collection backreference column for collection tables

### Base Table Metadata

Every created table tends to be normalized to:

- engine `InnoDB`
- charset `utf8`
- collation `utf8_unicode_ci`
- descriptive table comments

### Base Identity Columns

For non-collection types:

- a row id / id column is created as a primary integer auto-increment column

For collection tables:

- a collection row id column is created
- a backreference column to the owning parent is created

For multi-type usage:

- a smallint type column may be created

## Stage 4: Setup Properties

After table setup, `QSqlModelInfoType::setup(...)` iterates the model properties and calls:

- `QSqlModelInfoProperty::setup(...)`

Properties are skipped if:

- name is `id`
- `storage["query"]` is set
- `storage["none"]` is set

### Property Type Analysis

The property setup logic distinguishes:

- scalar/unstructured types
- model/reference types
- collection types
- multi-type properties
- interface/abstract model cases

This is one of the places where legacy complexity accumulates.

## Stage 5: Property -> Column Rules

The central conversion logic is in:

- `QSqlModelInfoProperty::setupPropertyTypes(...)`

### Reference-Like Properties

If a property includes model/reference types:

- it creates an integer reference column
- the reference column name comes from:
  - `getRefColumnName()` for normal properties
  - `getCollectionForwardColumn()` for collection context

This is the legacy `_id`-style relation path.

### Scalar-Like Properties

If a property includes scalar/unstructured types:

- it chooses one supported SQL type
- the value column name comes from:
  - `getColumnName()` for normal properties
  - `getCollectionValueColumn()` for collection context

Type choice comes from:

- the scalar type’s supported SQL data types
- optional storage override such as `storage["type"]`

### Multi-Type Properties

If a property can hold more than one target type:

- a smallint type discriminator column may be added
- the logic is handled by `setupMoreTypesColumn(...)`

This applies to both:

- regular properties
- collection tables

### Dimensional Scalar Properties

If a property has storage dimensions such as `storage["dims"]`:

- multiple columns may be created
- one for each dimension value

This is a legacy special case for localized / dimensioned values.

## Stage 6: Column Attributes

Column creation is centralized in:

- `QSqlModelInfoProperty::SetupSqlColumn(...)`

This method creates or updates a `QSqlTableColumn` and sets:

- type
- length
- enum/set values
- default
- charset
- collation
- unsigned
- nullability
- auto_increment
- comment
- compressed

It also creates or updates indexes for that column.

## Stage 7: Index Rules

Indexes are also managed in `SetupSqlColumn(...)`.

Possible index kinds are:

- primary
- unique
- normal
- fulltext

Index decisions come from:

- primary-key setup for row id columns
- storage metadata such as:
  - `unique`
  - `index`
  - `fulltext`
  - `noindex`

Important observation:

- the legacy ORM treats indexing as part of column setup, not as a fully separate planning pass

That makes it practical, but also tightly couples column definition and index planning.

## Stage 8: Schema Object Shapes

The in-memory schema objects are simple and useful:

### `QSqlTable`

Holds:

- table name
- parent database
- columns
- indexes
- references
- engine
- charset
- collation
- comment

### `QSqlTableColumn`

Holds:

- name
- type
- length
- values
- default
- charset
- collation
- unsigned
- null
- auto_increment
- compressed
- comment

### `QSqlTableIndex`

Holds:

- index name
- index type
- indexed columns
- owning table

### `QSqlForeignKey`

Holds:

- local index
- referenced index

Foreign keys exist as a concept in the schema model, although the legacy sync path appears to emphasize columns and indexes more directly than foreign-key emission.

## Stage 9: Sync To MySQL

After the planning/setup graph has populated the in-memory tables, `ResyncDataStructure(...)` loops all used databases and tables and calls:

- `$storage->syncTable($table, $do_auto_structure_sync)`

For MySQL, this lands in:

- [QMySqlStorage.class.php](/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/src/orm/query/sql/QMySqlStorage.class.php)

### What `syncTable(...)` Does

It compares the target `QSqlTable` transform state and emits either:

- `CREATE TABLE`
- `ALTER TABLE`
- `DROP TABLE`

For columns it emits:

- `ADD`
- `CHANGE`

For indexes it emits:

- `ADD INDEX`
- `ADD UNIQUE`
- `ADD FULLTEXT`
- `DROP INDEX`

It also emits table-level changes for:

- engine
- charset
- collation
- comment

When cluster alter mode is enabled, it splits complex changes into several safer statements.

## Practical Rule Summary

The legacy ORM effectively follows these rules:

- model type with a declared table -> root SQL table candidate
- collection one-to-many -> usually target table reuse
- collection non-one-to-many -> dedicated collection table
- scalar property -> value column
- model/reference property -> integer reference column
- mixed/multi-type property -> value/ref column plus type column
- dimensioned property -> several physical columns
- row identity -> primary integer auto-increment column
- storage metadata may override SQL details such as column type, nullability, default, and indexes

## Recently Verified H2B Notes

The current Open M3 H2B work verified a few practical behaviors against fresh legacy metadata and should be kept in mind when reading the older legacy rules.

### Legacy Import Fidelity

The Open M3 legacy importer now preserves authored legacy case for:

- type names
- property names
- legacy materialization table names
- legacy materialization column names

This matters because the earlier lowercase-normalized import was hiding real legacy naming behavior.

### Root Collection Default

For root-level collections that target model types, the working assumption is now:

- default to `one_to_many`
- unless explicit legacy metadata says `collection`, `manyToMany`, or `oneToMany`

This is not just a legacy-compatibility hack.

It is the logical default inferred from real H2B behavior:

- there is usually no reason to create a collection-purpose-only helper table at the root
- the child/target table normally carries the owner backreference

### Important Invariant

For `one_to_many`, there should be:

- one real target table
- one owner backreference on that target table
- no extra collection-purpose-only table

Example intended shape:

- `Addresses` with `$$App$Addresses`
- not both `Addresses` and `$App_Addresses`

This invariant was validated at the ORM-materialization level in the current H2B importer.

### Current Verified Open M3 H2B State

The current verifier shows that direct root nodes such as:

- `Omi/App.Addresses`
- `Omi/App.Users`
- `Omi/App.Properties`
- `Omi/App.Offers`

already materialize as:

- `mat[0].mode = one_to_many`

with reused target tables:

- `Addresses`
- `$Users`
- `Properties`
- `Offers`

So if synthetic root helper tables like `$App_Addresses` still appear, that is no longer an importer classification issue.

It is a schema-generation/parity issue downstream.

### Fresh H2B Comparison Snapshot

With refreshed H2B metadata and the current ORM-driven schema path, the comparison state used in recent work is:

- legacy tables: `190`
- generated tables: `271`
- common table names: `182`

This means:

- name parity is already fairly strong
- the remaining gap is concentrated in helper-table over-generation, duplicate helper columns, and missing legacy reference columns

### Useful Concrete Example

The current generated schema already correctly contains target-table backreferences such as:

- `Addresses.$$App$Addresses`
- `$Users.$$App$$Users`
- `Properties.$$App$Properties`
- `Offers.$$App$Offers`

The unresolved problem is that redundant root helper tables still appear beside them:

- `$App_Addresses`
- `$App_Users`
- `$App_Properties`
- `$App_Offers`

That is precisely the kind of parity bug to treat as builder-side, not importer-side.

## Main Complexity Sources

The legacy design becomes hard to follow mainly because it combines:

- traversal
- inheritance expansion
- collection planning
- storage override handling
- column planning
- index planning
- sync emission

inside a relatively tight cluster of methods.

The core ideas are still workable, but the concerns are mixed.

## Main Takeaways For Open M3

The most useful things to preserve are:

- path-aware traversal from a root model
- a separate in-memory relational schema model
- explicit table/column/index objects before SQL emission
- support for path-dependent materialization

The clearest opportunities to simplify are:

- keep traversal generic
- move materialization decisions into a thinner planner layer
- keep schema-object building separate from traversal
- keep SQL sync separate from schema planning

## Open Questions For The New ORM

Questions still to decide in Open M3:

- when should a `struct.sub` property stay in the parent table versus get its own table
- how should path-based materialization names be derived
- how much storage metadata should be explicit versus inferred
- how multi-type support should look in the new model
- whether dimensioned fields should remain a storage concern or move elsewhere

These notes should be read together with:

- [orm_materialization_direction.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/orm_materialization_direction.md)
