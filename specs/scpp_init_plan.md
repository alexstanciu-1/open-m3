# Open M3 `scpp init` Plan

Status: draft

Purpose: describe how Open M3 should use `scpp init` while the project grows from the first Simple C++ tool into reusable base and ORM code.

## Goal

Use `scpp init` in a simple staged way:

- first for small isolated tools
- then for `base/`
- then for `modules/orm/`

The main objective is to keep each Simple C++ unit small, understandable, and independently runnable while the architecture settles.

Important constraint:

- Open M3 is intended to live in strict mode with its own library surface
- therefore `scpp init` usage here should be treated as toolchain/project scaffolding support, not as a decision that Open M3 authored code must follow the default Simple C++ compatibility-first frontend conventions

## Guiding Idea

We should not start with one giant Simple C++ project.

Instead, we should use `scpp init` to create small focused units:

- tools
- base runtime
- orm runtime

Each unit should have a clear entrypoint and clear dependencies.

## Stages

### Stage 1: Tool Projects

Use `scpp init` for small focused tools, like:

- `tools/h2b_types_to_om3`

This is already proven useful because it:

- tests the compiler/runtime in real conditions
- helps us discover missing features
- produces outputs we can validate

Rule:

- one tool folder
- one local `prism.json`
- one explicit entrypoint
- small number of included files

### Stage 2: Base Project

Create a separate Simple C++ project for:

- `base/`

Purpose:

- hold the foundational descriptive definition classes
- validate multi-file runtime code outside ad hoc tool logic

Expected first files:

- `base/model.php`
- `base/model_property.php`
- `base/storage.php`
- `base/storage_property.php`

Expected namespace:

- `om3::base`

At this stage, `scpp init` should create a minimal project around `base/`, not around the whole repository.

### Stage 3: ORM Project

Create a separate Simple C++ project for:

- `modules/orm/`

Purpose:

- hold ORM assembly structures
- hold SQL-lowered structures
- later expose reusable compiled ORM behavior

Expected namespace:

- `om3::orm`

Expected early areas:

- assembled model/storage structures
- SQL database/table/column/index structures
- later SQL generation and sync logic

## Preferred Project Boundaries

| Area | Recommendation |
| --- | --- |
| tools | Each important tool gets its own Simple C++ project. |
| base | `base/` should become its own Simple C++ project. |
| orm | `modules/orm/` should become its own Simple C++ project. |
| repo root | Do not make the whole repo one single `scpp init` project yet. |

## Why This Is Better

| Reason | Meaning |
| --- | --- |
| smaller compile units | Easier to debug and evolve |
| clearer dependencies | `orm` can depend on `base` without everything depending on everything |
| easier first-use testing | Problems are isolated faster |
| cleaner runtime packaging | Shared modules can be built more deliberately later |

## Early Dependency Direction

The intended dependency direction should be:

- tools may depend on `base`
- tools may later depend on `orm`
- `orm` may depend on `base`
- `base` must not depend on `orm`

## Current Working Plan

1. keep using `scpp init` for small tools when needed
2. create a dedicated `base/` Simple C++ project next
3. create a dedicated `modules/orm/` Simple C++ project after that
4. only later decide whether a higher-level workspace build is needed

## Important Constraint

At this stage, `scpp init` should help us keep boundaries clear.

It should not push us into a monolithic repository-wide project too early.

It also should not quietly lock Open M3 into whichever frontend naming or extension convention the default Simple C++ surface currently prefers.
