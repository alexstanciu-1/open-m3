# Open M3 Roadmap

Status: draft

Purpose: capture the current major objectives for Open M3 in a short practical form.

## Major Objective

Open M3 must be able to co-work with legacy projects.

This is a major architectural objective, not just a migration convenience.

The system should be useful while legacy projects still exist and operate.

## First Major Objective

The first major objective is to have the ORM up and running for this co-working mode.

Open M3 should be able to:

- define strict Open M3 models
- derive default storage from those models
- override storage details where legacy schemas require it
- read and write against legacy databases
- safely co-work with legacy projects through the same DB

## Why This Comes First

| Reason | Meaning |
| --- | --- |
| Shared contract | The database is the most practical shared contract with legacy projects. |
| Early proof | If Open M3 can operate correctly on the same DB, it proves the model and storage design under real conditions. |
| Gradual adoption | This allows Open M3 to be introduced next to legacy systems instead of requiring a full rewrite. |
| Real usefulness | This makes Open M3 useful before the full platform is complete. |

## Practical Consequences

| Area | Direction |
| --- | --- |
| model | Model definitions must stay strict and language-agnostic. |
| storage | Storage must default from model shape, but allow explicit legacy-compatible overrides. |
| orm | The ORM must be capable enough to co-work with existing schemas and relation patterns. |
| compatibility | Compatibility with real legacy databases matters more than theoretical elegance alone. |

## Toolchain Direction

Open M3 should be treated as a strict-mode project.

That means:

- Open M3 authored semantics must be defined by the Open M3 strict library surface
- Open M3 must not silently inherit loose or compatibility-first frontend conventions from the default Simple C++ surface
- Simple C++ release updates are important for compiler, generator, and runtime correctness, but they do not by themselves define Open M3 language shape

Practical implication:

- use newer Simple C++ runtime/generator fixes when they help Open M3
- keep Open M3 strict-mode decisions explicit inside Open M3 specs and library design

## Current Working Success Condition

Open M3 can define a model, materialize it through the ORM, and correctly read and write against a legacy project database while co-existing with the legacy application.

## Current ORM Reading Order

For the current ORM direction and implementation notes, read in this order:

1. [ORM overview note](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/orm_overview_note.md:1)
2. [ORM materialization direction](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/orm_materialization_direction.md:1)
3. [Storage overview](/home/alexv/__AI/open_m3/open_m3_01/specs/storage/overview.md:1)
4. [Relation rule sheet](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/openm3_relation_rule_sheet.md:1)
