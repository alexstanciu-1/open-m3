# Open M3 Model Assembly

Status: draft

Purpose: define how the runtime computes effective path-specific definitions from authored model and storage definitions.

## Scope

This document is downstream of the authored model specification.

It assumes the authored meaning from [authoring.md](/home/alexv/__AI/open_m3/open_m3_01/specs/model/authoring.md) and describes how the runtime resolves and assembles effective definitions for consumers such as:

- DB structure create/sync
- query planning and lowering
- CRUD merge transaction setup

## Assembly Role

The assembly layer answers questions such as:

- which authored model corresponds to a type reference
- what a model means at one exact root-relative path
- which semantic refinements apply at that path
- which attached storage refinements apply at that path
- which effective structure should downstream consumers receive

## Main Direction

The current intended direction is:

- load authored definitions once into canonical raw schema objects
- keep authored definitions immutable after load
- assemble effective path-specific definitions into an immutable assembled cache
- treat model semantics as primary and storage as attached materialization attributes

## Canonical Caches

The current preferred runtime shape is:

- raw model cache keyed by resolved type identity
- assembled model cache keyed by full root-relative path identity

This means:

- one canonical raw `Address`
- one assembled `App.Hotels.Address`
- one assembled `App.Customers.Address`

even when both assembled paths start from the same base type.

## Effective Assembly

Assembly should compute an effective path-specific definition bundle that includes:

- effective `model`
- effective `model_property` list
- effective attached `storage`
- effective attached `storage_property` values

The effective result should be stable and reusable by multiple consumers.

## Reuse And Cloning Direction

The current preferred direction is:

- reuse unchanged raw `model_property` objects by reference where safe
- create path-local cloned property objects when explicit semantic or storage overrides apply
- reuse unchanged attached storage objects by reference where safe
- create path-local cloned storage objects when explicit storage overrides apply

This allows path-sensitive assembled results without mutating canonical authored definitions.

## Structural Interpretation Direction

The current intended direction is:

- `struct.sub` is path-sensitive and may assemble differently per path
- `struct.ref` keeps stable target meaning and should not be treated as an inline local semantic rewrite
- `struct.weakref` also keeps stable target meaning, with weaker ownership/runtime semantics

## Storage Interpretation Direction

The current intended direction is:

- attached storage is inherited by default
- path-sensitive storage variation is allowed only through explicit authored overrides
- the assembly layer applies those explicit overrides while preserving semantic meaning

## Consumer View

Different consumers read different slices of the same assembled output:

- DB sync reads effective structure and materialization
- query compilation reads effective paths, edges, and storage mapping
- CRUD merge reads effective structure, ownership, and materialization rules

The assembler should therefore compute one stable effective graph rather than force each consumer to re-derive meaning independently.

## Deliberate Non-Goals For This Draft

This draft does not yet fully define:

- path key canonical format
- callback API
- cycle handling policy
- invalidation strategy
- exact refinement authoring syntax
- exact side metadata structures

Those should be added once the authored model and storage semantics are settled further.
