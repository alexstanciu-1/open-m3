# Process Specs

Status: draft

Purpose: define the `v0.1` process layer for Open M3.

The process layer is the highest-priority semantic layer in Open M3.
It describes how work evolves over time:

- steps
- transitions
- waits
- triggers
- completion
- failure

For `v0.1`, the process layer is intentionally small.
It should remain in charted territory and focus on:

- explicit process definitions
- explicit step execution
- wait/resume behavior
- small runtime support
- generator-owned lowering where possible

It should not yet try to become:

- a universal execution model for every layer
- a full workflow engine product
- a generalized MVVM/runtime abstraction

Documents in this folder:

- `overview.md`
- `model.md`
- `runtime.md`
- `v0_1_scope.md`
