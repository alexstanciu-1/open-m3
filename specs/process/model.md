# Process Model

Status: draft

## Purpose

This document describes the conceptual model of a process in Open M3 `v0.1`.

## Process

A process is a named definition that describes a unit of evolving work.

A process has:

- an identity
- an entry point
- a set of steps
- transition rules
- terminal outcomes

At a high level, a process may also declare process-level sections for:

- input
- working data
- return data
- error state

For `v0.1`, these should be treated as semantic roles rather than fixed field names.

In `v0.1`, steps should be allowed to form a hierarchy rather than only a flat list.
This reflects the legacy process model more accurately and keeps process structure aligned with how people describe work:

- a process may contain steps
- a step may contain child steps
- execution may move downward into child structure and later return upward

## Step

A step is the smallest explicit unit of process execution in `v0.1`.

A step may:

- decide whether it should run
- run immediately
- produce data
- decide a next step
- enter a waiting state
- complete child work
- perform finish logic
- finish
- fail

A step may also carry execution policy information.
The legacy authored sample suggests at least these concepts are relevant:

- whether a step is mandatory
- whether a step may repeat
- whether a step is synchronous or asynchronous relative to the enclosing flow

For `v0.1`, these should be recognized as process semantics, even if only a subset is implemented initially.

At a high level, the legacy process model suggests a step can have at least these conceptual roles:

- `test`-like behavior: decide if the step is applicable
- `run`-like behavior: do the main work
- `wait`-like behavior: suspend until resumed
- `goto`-like behavior: move explicitly to another step
- `finish`-like behavior: finalize after child execution or successful completion

## Wait

A wait is an explicit suspension point.

A wait must be described, not implied.

A wait has:

- a stable identity within the process instance
- an expected trigger or trigger family
- optional input requirements for resume

The legacy code suggests a wait is naturally attached to a concrete step path.
That is a good `v0.1` design principle:

- waits belong to an explicit place in the process structure
- resume should target that place directly

The authored sample also suggests that waits may expose a named resume surface or channel.
For `v0.1`, the spec should preserve the idea that a wait may be described through:

- where in the process it belongs
- how it is resumed
- what input is expected when resumed

## Trigger

A trigger is an external or internal signal that resumes a waiting process step.

For `v0.1`, a trigger should be treated as explicit input to a known waiting point.

## Process Instance

A process definition is static.
A process instance is a runtime execution of that definition.

A process instance has:

- instance identity
- current step or wait point
- current path within the process structure
- step-local data
- process-level data
- execution status

The legacy process work also suggests a useful distinction between:

- process definition identity
- process instance identity

For `v0.1`, a process instance identity may be derived either:

- externally
- or from process input through process-defined rules

This should remain a semantic capability, even if the first implementation is simple.

## Status

At minimum, a process instance should support statuses equivalent to:

- created
- running
- waiting
- finished
- failed

## Data Ownership

For `v0.1`, process data should be simple and explicit.

Recommended split:

- process data: longer-lived shared state across the process
- step input: data supplied to a step execution
- step output: data emitted by a step

The legacy process model also used per-step local data and return slots.
For `v0.1`, we do not need to formalize those deeply yet, but we should preserve the idea that:

- a step may have its own local working state
- parent and child steps may exchange structured data deliberately

The authored sample also suggests that process definitions may declare the expected shape of:

- process input
- process working state
- process return state

For `v0.1`, those declarations may remain descriptive and lightweight, but they should be considered part of the process model rather than an afterthought.

## Composition

The authored sample confirms that a step may delegate or include behavior from an external descriptive unit.

For `v0.1`, process composition should therefore be part of the conceptual model:

- a step may be defined locally
- or a step may be completed by an external referenced definition

This capability should be preserved independently from the concrete include mechanism.

## Non-Goals For `v0.1`

The process model does not yet need:

- distributed orchestration
- advanced compensation logic
- speculative execution
- generalized event-sourcing
- automatic derivation from UI binding semantics
