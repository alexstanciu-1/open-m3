# Process Overview

Status: draft

## Intent

In Open M3, a process is a descriptive definition of how work can proceed.

A process does not primarily describe low-level control flow.
It describes:

- what states or steps exist
- what inputs a step expects
- when a process must wait
- what can resume it
- what outcomes are possible

## Role In Open M3

The process layer sits above:

- model
- data
- security
- api
- ui

This means the process layer defines the evolution of work, while the lower layers provide the meaning, data, permissions, exposure, and presentation needed by that work.

## Design Direction For `v0.1`

For `v0.1`, processes should be:

- explicit
- inspectable
- resumable
- small in scope

For `v0.1`, processes should not rely on:

- hidden framework magic
- implicit runtime inference
- generalized reactive execution

## Core Idea

A process definition should be able to say, in a direct way:

1. this process starts here
2. this step runs with these inputs
3. this step may wait
4. this trigger resumes that waiting point
5. this path finishes successfully or fails

At a high level, the legacy process work suggests that a process is best understood as a tree of explicit steps with controlled movement through that tree.
A process should be able to:

- start from a root definition
- enter named child steps
- move to a sibling or other explicit next step
- resume from a previously-known path
- finish a step and return to its parent flow

This means the process layer is not just a flat state machine.
It is closer to structured executable flow with explicit nesting.

## High-Level Execution Shape

For `v0.1`, a process definition should support a small number of high-level concepts:

- process metadata
- optional identity derivation for a process instance
- explicit process-level state areas
- optional step guard or eligibility check before a step runs
- step execution logic
- optional waiting behavior
- explicit next-step movement
- optional completion/finalization logic

The important point is not the concrete syntax.
The important point is that these concepts are first-class in the process description.

The authored legacy sample also suggests that a process definition should be able to describe itself at a high level through top-level sections such as:

- process identity and compatibility metadata
- declared input shape
- declared working data
- declared return or outcome shape
- declared error surface

Open M3 `v0.1` should preserve those semantic roles even if the final syntax changes.

## Legacy Know-How To Preserve

From `descriptivejs`:

- structured step definitions
- waits and triggers
- resumability
- process as explicit structure

From `omi-frame`:

- disciplined runtime orchestration
- practical separation between immediate response and deferred work

## Architectural Posture

In Open M3, most process semantics should be owned by:

- the process description
- the process generator

Only the minimum dynamic behavior should be owned by the runtime.

One practical lesson from the legacy process code is that process definitions may be assembled from multiple descriptive units.
For `v0.1`, that should be treated as an architectural possibility:

- a process may be defined in one place
- or may reference sub-definitions that are loaded or lowered separately

The spec should preserve that capability at the conceptual level without committing early to a concrete import format.
