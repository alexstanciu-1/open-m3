# H2B SQL-Relevant Checklist

Source reviewed:
- `D:\Work_2026\open_m3\_legacy_code\h2b\code\temp\types`
- `D:\Work_2026\open_m3\_legacy_code\h2b\code\temp\types_json`

Scope:
- only SQL-relevant metadata actually defined in H2B
- only whether that metadata is captured into current Open M3 `model` / `storage` output

## Type Storage

| Legacy Signal | Seen In H2B | Captured Now | Notes |
| --- | --- | --- | --- |
| `@storage.table` | Yes | Yes | Mapped to `storage.table`. |
| `@storage.database` | No sample | N/A | Kept in converter if it appears later. |
| `primary_key` | No sample | N/A | Not present in H2B exported type metadata. |
| `type_column` | No sample | N/A | Not present in H2B exported type metadata. |
| type-level `indexes` | No sample on domain types | N/A | Present only on framework storage classes, not on converted domain model types. |

## Property Storage

| Legacy Signal | Seen In H2B | Captured Now | Notes |
| --- | --- | --- | --- |
| `@storage.column` | Yes | Yes | `column: "none"` becomes `kind: none`; other values map to `column`. |
| `@storage.none` | Yes | Yes | Mapped to `kind: none`. |
| `@storage.type` | Yes | Yes | Mapped to `sql_type`. |
| `@storage.default` | Yes | Yes | Mapped to `default`. |
| `@storage.index = true` | Yes | Yes | Mapped to `index: true`. |
| `@storage.index = "unique"` | Yes | Yes | Mapped to `index: "unique"`. |
| `@storage.notnull` | Yes | Yes | Mapped to `nullable: false`. |
| `@storage.nonull` | Yes | Yes | Mapped to `nullable: false`. |
| `@storage.oneToMany` | Yes | Yes | Mapped to `relation.type = "oneToMany"` and `relation.target_column`. |
| `@storage.manyToMany` | Yes | Yes | Mapped to `relation.type = "manyToMany"`. |
| `@storage.collection` with explicit `manyToMany` | Yes | Yes | Mapped to `relation.table`, `relation.this_column`, `relation.target_column`. |
| `@storage.collection` without explicit `manyToMany` | Yes | Yes | Now treated as `manyToMany` when no `oneToMany` is present. |
| `@storage.oneToOne` | No sample | N/A | Not present in H2B exported type metadata. |

## Model Side That Affects SQL

| Legacy Signal | Seen In H2B | Captured Now | Notes |
| --- | --- | --- | --- |
| property `validation = "mandatory"` | Yes | Yes | Mapped to model `required: true`. |
| `@storage.optionsPool` | Yes | Yes | Mapped to model `struct.ref`. Important for relation semantics, not direct SQL shape. |
| `extends` via parent type | Yes | Yes | Captured when the parent is not a generated `_h2b_model_` helper. |
| `abstract` | No clear sample | N/A | Not inferred. |

## Explicitly Out Of Scope For SQL

These appear in H2B but are not part of the current SQL-focused capture:

- `dependency`
- `view_to_load`
- `display`
- `collection_type`
- `checkbox_coll_custq`
- `checkbox_coll_binds`
- `filter`
- `captions`
- `enum_display`
- `attrs`
- `compressed`
- `filePath`
- `views`
- `admin.readonly_IF`
- `admin.render_IF`
- `info`
- `mandatory` when it is a contextual JSON map instead of a simple required signal

## Current Read

The current converter captures the important SQL-shaping metadata that is actually defined in H2B domain type exports:

- type table name
- property column/none
- SQL type
- default
- nullability
- index, including unique
- one-to-many relations
- many-to-many relations, including collection-only relation naming

That is enough to proceed to the SQL-generation comparison step.
