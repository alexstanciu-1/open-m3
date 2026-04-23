# Process `v0.1` Scope

Status: draft

## Goal

The first goal is to make the process layer work in a minimal and honest way with the rest of Open M3.

## Included In `v0.1`

- process-level metadata
- named process definitions
- declared process input/data/return areas
- explicit steps
- hierarchical step structure
- explicit waits
- explicit triggers
- resumable process instances
- path-based resume
- optional step guards
- optional explicit next-step movement
- optional finish/finalization behavior
- conceptual support for composed or included step definitions
- small runtime support
- generator-owned lowering

## Intentionally Excluded From `v0.1`

- process-driven universal code generation
- using MVVM concepts outside their natural UI role
- generalized reactive semantics across all layers
- full workflow product features
- advanced orchestration patterns
- full realization of every legacy execution policy flag

## Integration Expectation

For `v0.1`, the process layer should integrate minimally with:

- model: process steps can refer to domain concepts
- data: process instances can store explicit process/state data
- security: triggers and process actions can be checked
- api: processes can be started or resumed through explicit endpoints
- ui: the UI can present and trigger process actions

At this stage, integration should remain simple.
The process layer should use the other layers, but should not yet try to subsume them.

## Success Criteria

`v0.1` process support is successful if:

1. a process can be defined explicitly
2. a process can start and run a step
3. a process can enter a wait state
4. a trigger can resume the waiting process
5. a process can resume from an explicit structural path
6. process-level state remains understandable across resume
7. the runtime remains small and understandable

## Guiding Rule

Prefer a small completed process system over a more ambitious but unclear one.
