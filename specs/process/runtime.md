# Process Runtime

Status: draft

## Purpose

This document defines what the runtime must do for process support in Open M3 `v0.1`.

## Runtime Philosophy

The runtime should stay small.

The runtime exists to execute dynamic behavior that cannot be fully lowered away by generators.

For the process layer, that means the runtime should support:

- process start
- step execution
- hierarchical step traversal
- persistence of process instance state
- wait registration
- trigger-based resume
- finish/fail transitions
- process-definition composition support as needed by the lowered form

## Minimum Responsibilities

The `v0.1` process runtime should be responsible for:

1. creating a process instance
2. loading a process definition
3. executing the current step
4. moving through the explicit process structure
5. persisting current state after meaningful transitions
6. registering waits in a resumable form
7. resuming a process from a trigger
8. resolving linked or included process fragments after lowering when needed

At a high level, the legacy process runtime traversed a structured process tree and used the current step path as a resumable location.
That should be preserved conceptually in `v0.1` even if the internal representation changes.

## Generator Boundary

The runtime should not own most process semantics.

The generator should define:

- the structure of the process
- the step graph
- the transition shape
- the names and identities of waits/triggers
- any split or linked process fragments that belong to the same process definition
- process-level state sections and their lowered representation

The runtime should execute those results.

## Persistence

For `v0.1`, persistence may be simple.

The process runtime only needs a stable way to store:

- process instance id
- definition id
- current path or step id
- waiting point id
- process data
- step-local state as needed
- current status

The legacy code also suggests two practical runtime needs:

- the runtime must be able to restore a persisted instance and reconnect it to the current process definition
- the runtime must be able to resolve nested steps from a saved path

The authored sample also suggests a third practical need:

- the runtime must preserve enough process-level state to continue meaningful work across waits and resumes

## Resume Contract

A resume operation should be explicit.

The runtime should be able to answer:

- which process instance is being resumed
- which wait point is being satisfied
- what input accompanies the trigger

It should also be able to answer:

- which concrete step path becomes active after resume

## Error Handling

For `v0.1`, process runtime error handling should be conservative and inspectable.

Recommended behavior:

- invalid trigger -> reject clearly
- missing process instance -> reject clearly
- missing resume point -> reject clearly
- step exception -> mark failed unless explicitly handled

For `v0.1`, concurrency and locking may stay minimal, but the runtime should acknowledge them as future concerns rather than silently assuming single-threaded safety.

The authored sample also raises policy questions such as:

- repeatable waits
- mandatory vs optional steps
- asynchronous step execution

For `v0.1`, the runtime does not need to fully realize all of these, but the architecture should leave room for them without forcing a redesign.

## Non-Goals

The runtime should not yet try to provide:

- general distributed job scheduling
- hidden retries
- workflow analytics
- automatic process inference from arbitrary code
