# SimpleC++ Open Issues Report

Status: active triage note

Date: 2026-05-22

Purpose:

- summarize the remaining open GitHub issues after closing the clearly resolved items
- group the open set by likely next action
- keep a short Open M3-oriented prioritization record

Repository:

- `alexstanciu-1/simplecpp`

Open-issue snapshot reviewed:

- 2026-05-22
- after closing `#157`, `#159`, `#160`, and `#168`

## Remaining Open Issues

At the time of this report, the remaining open set is:

- `#171` strict lowering: typed vector literal assignment and foreach on const vector parameter fail in helper method
- `#166` nullable-boundary diagnostics should identify the failing path or source location more precisely
- `#165` hash lookups combined with nullable guards are still too sensitive in strict code
- `#164` strict nullable-boundary runtime failures are easy to trigger through indirect access shapes
- `#163` stale or partially refreshed rebuild state can lead to invalid object/link cache failures
- `#162` common strict project edits should not require shared runtime rebuilds outside scpp update flows
- `#158` strict mode still needs better mixed-data boundary ergonomics and explicit guidance for real JSON loaders
- `#110` compact chained null-guard lowering over nullable object members builds but crashes on scpp 0.1.42
- `#96` feature request: make Clang builds use generated app PCH correctly in scpp project builds
- `#90` feature request: strict runtime diagnostics should expose expression-level source context as a follow-up to original file/line remap

## Recommended Triage Groups

### Group A: active correctness / lowering issues

These are the most likely to block real downstream authoring and should stay near the top of the queue.

#### `#171`

Status:

- newly opened
- likely live on `0.1.60`

Why it matters:

- directly affects current Open M3 ORM writer helper code
- combines two author-facing strict issues:
  - typed vector literal reassignment
  - direct `foreach` over a typed vector parameter when the lowered path stays `const`

Suggested next action:

- keep open
- prioritize a focused upstream repro/test

#### `#110`

Status:

- rechecked today
- still live on `0.1.60`

Why it matters:

- runtime correctness issue
- natural compact nullable guard syntax still crashes at runtime

Suggested next action:

- keep open
- still one of the clearest strict correctness bugs from Open M3 usage

### Group B: nullable-boundary ergonomics / diagnostics cluster

These appear related and may eventually benefit from consolidation or a shared design pass, but they are not duplicates yet.

#### `#166`

Focus:

- better pinpointing for nullable-boundary diagnostics

Current take:

- good candidate to keep open as a diagnostics-quality issue
- complements, rather than duplicates, the runtime-behavior issues

Suggested next action:

- keep open
- good follow-up after core nullable-boundary behavior stabilizes

#### `#165`

Focus:

- hash lookup patterns combined with nullable guards remain too fragile

Current take:

- likely a real authoring pain point
- may overlap with `#164`, but it contributes a more specific collection-access angle

Suggested next action:

- keep open
- useful to preserve separately unless a later upstream fix clearly covers both

#### `#164`

Focus:

- indirect nullable-boundary access shapes are still easy to trip

Current take:

- broad but still plausible as a parent authoring-friction issue
- may become easier to judge once `#166` diagnostics and `#165` hash-specific cases are better understood

Suggested next action:

- keep open
- consider later whether it should remain broad or be split into sharper repro-driven child issues

#### `#90`

Focus:

- richer expression-level runtime diagnostic context

Current take:

- still looks like a legitimate feature request
- not contradicted by today’s retest work

Suggested next action:

- keep open
- lower urgency than core runtime correctness issues, but still valuable

### Group C: build / cache / incremental state issues

These are related to workflow predictability rather than source-language semantics.

#### `#162`

Status:

- rechecked today
- improved, but still not fully resolved

Current take:

- `scpp update --force` repairs the shared strict runtime matrix
- plain already-current `scpp update` did not repopulate the missing strict shared runtime artifact in today’s checkout before the forced refresh

Suggested next action:

- keep open
- add or keep a follow-up comment with the `0.1.60` retest nuance

#### `#163`

Focus:

- intermittent stale-object / invalid-link-cache behavior

Current take:

- not reverified today
- still plausible as a real cache invalidation issue
- adjacent to `#162`, but different enough to keep separate for now:
  - `#162` is about shared runtime rebuild expectations and reuse policy
  - `#163` is about invalid or stale object/cache state surfacing later as object/link failures

Suggested next action:

- keep open
- worth retesting only when the failure shape reproduces again

### Group D: ergonomics / authoring guidance

These matter to Open M3 author productivity, but they are less urgent than correctness failures.

#### `#158`

Focus:

- mixed-data boundary ergonomics and better real-loader guidance

Current take:

- still a valid ergonomics/doc request
- the simplest `json_decode(...)` typed-read case is improved, but larger loader patterns are still repetitive

Suggested next action:

- keep open
- lower priority than correctness issues, but still useful for long-term strict adoption

### Group E: toolchain feature requests

These are real requests, but they do not currently look like the top priority for Open M3 strict authoring flow.

#### `#96`

Focus:

- Clang PCH usage in generated app builds

Current take:

- still reasonable as a build-performance/toolchain feature request
- not connected to the current strict-language regressions

Suggested next action:

- keep open
- revisit when performance/toolchain work becomes active again

## Practical Priority Order

If we want one simple working order for follow-up, the current best queue looks like:

1. `#171`
2. `#110`
3. `#162`
4. `#166`
5. `#165`
6. `#164`
7. `#163`
8. `#158`
9. `#90`
10. `#96`

## Net Outcome

Today’s issue posture after the resolved closures is:

- closed as resolved:
  - `#157`
  - `#159`
  - `#160`
  - `#168`
- still clearly live:
  - `#171`
  - `#110`
  - `#162`
- still reasonable to keep open as follow-up requests:
  - `#166`
  - `#165`
  - `#164`
  - `#163`
  - `#158`
  - `#90`
  - `#96`
