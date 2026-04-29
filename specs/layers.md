# Open M3 Layers

Status: draft

Purpose: record the current architectural layer stack for Open M3.

## Primary Layers

The current Open M3 layers, in order, are:

1. processes
2. model
3. data
4. storage
5. security
6. api
7. ui
8. crons

## Utility Layers

Open M3 also has these utility/support layers:

9. logs
10. debug

These are important architectural layers, but they are not primary semantic layers in the same sense as the first seven.

## Layer Meanings

- `processes`: describes how work evolves over time
- `model`: describes domain structure and semantic meaning
- `data`: describes runtime state and shaped data flow
- `storage`: describes persistence-oriented structure, ORM mapping, and storage mechanics
- `security`: describes who can see or do what
- `api`: describes exposed operations and contracts
- `ui`: describes presentation and interaction
- `crons`: describes time-based activation or resume needed for process continuity
- `logs`: records durable operational history and audit signal
- `debug`: supports inspection, tracing, diagnosis, and developer/operator visibility

## Important Note

`crons` appears late in the layer order, but it is still foundational for doing processes correctly.

Without time-based activation and resume, the process layer is incomplete.

## Metadata Categories

When reviewing legacy metadata, the current working categories are:

- `model`
- `storage`
- `view`
- `security`
- `api`

Within `view`, generated backend/admin configuration and template metadata should be treated as a `generator` sub-section rather than as a separate top-level category.
