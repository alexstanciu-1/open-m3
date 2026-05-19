# Open M3 ORM Overview

Status: current working overview

Purpose: give a short readable picture of how the new ORM turns model definitions into DB structure, without requiring the reader to start from the lower-level implementation notes.

## One-Sentence Summary

The new ORM reads model semantics first, plans materialization path by path, then builds in-memory schema objects from those planned routes.

## The Main Idea

The ORM is split into three practical layers:

1. metadata loading
2. ORM/materialization planning
3. DB structure building

That means OpenM3 does not jump directly from models to SQL tables in one opaque step.

It first decides:

- what each visible path means
- where it should live
- whether it creates a value column, ref column, type table, helper table, or join table

Only after that does it create DB structure objects.

## The Current Flow

### 1. Load metadata

`json_loader` reads raw model/storage metadata into typed OpenM3 structures.

### 2. Build ORM routes

`model_assembler` walks the model graph and builds:

- `orm_root`
- `orm_node`
- `orm_mat`

This is the stage where the ORM decides:

- scalar vs ref vs sub vs collection
- one-to-many vs helper table vs join table
- whether a type column is needed
- which identity is the real owner of storage

### 3. Build DB structure

`structure_builder` reads those `orm_mat` routes and builds:

- `db_database`
- `db_table`
- `db_column`
- `db_index`

At this stage, the ORM is no longer deciding model semantics.

It is realizing already-planned storage routes.

## The Core Rule

A path does not create schema just because it exists.

It must first resolve to:

- a type identity
- optionally a relation/helper identity
- a storage mode
- an ownership role

That is why:

- a target type table is different from a relation/helper table
- reverse sides should reuse existing identities
- path identity alone is not storage identity by default

## The Main Materialization Modes

The current important modes are:

- `value_column`
- `ref_column`
- `type_table`
- `one_to_many`
- `collection_table`
- `join_table`

Very short reading:

- `value_column`: scalar stored on an existing table
- `ref_column`: singular ref stored on an existing table
- `type_table`: use the target model’s own table
- `one_to_many`: relation lives on the child table
- `collection_table`: dedicated helper table
- `join_table`: canonical many-to-many relation table

## Why This Matters

This separation makes a few important things possible:

- better reasoning about legacy parity
- path-aware materialization without inventing random tables
- clearer relation ownership
- cleaner future query/hydration work

## Current Verified Result

For the current filtered legacy-vs-new ORM comparison:

- in-scope table parity is clean
- in-scope column parity is clean
- in-scope type mismatches are clean

Reference:

- [new_orm_vs_legacy_schema_diff_2026_05_19.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/new_orm_vs_legacy_schema_diff_2026_05_19.md:1)

## Read Next

For the detailed current implementation logic:

- [orm_materialization_direction.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/orm_materialization_direction.md:1)

For relation-specific rules:

- [openm3_relation_rule_sheet.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/openm3_relation_rule_sheet.md:1)
