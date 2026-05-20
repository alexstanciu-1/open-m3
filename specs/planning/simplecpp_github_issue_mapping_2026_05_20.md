# SimpleC++ GitHub Issue Mapping

Status: active mapping note

Date: 2026-05-20

Purpose: map the current Open M3 SimpleC++ triage shortlist to the upstream GitHub issue tracker for `alexstanciu-1/simplecpp`.

Related notes:

- [SimpleC++ GitHub triage shortlist](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_github_triage_shortlist_2026_05_20.md:1)
- [SimpleC++ review verification](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_review_verification_2026_05_20.md:1)

Tracker checked:

- `alexstanciu-1/simplecpp`

Verification baseline:

- `scpp 0.1.56`
- repro set: `/tmp/simplecpp-review-HRBsG1`

## Mapping Summary

| Local triage item | Upstream mapping | Current upstream state | Local recommendation |
| --- | --- | --- | --- |
| compact nullable short-circuit still dereferences through null | existing issue `#110` | `open` | use existing issue, do not file duplicate |
| docs/guidance for preferred nullable guard style | existing issue `#113` | `closed` | no new issue needed |
| vector `unset()` unsupported | existing issue `#120` | `closed` | no new issue needed |
| lowered `unset(...)` emits `nodiscard` warning | no match found | `none found` | candidate for new low-priority issue if we decide it matters |

## 1. Compact Nullable Short-Circuit Guard

Local item:

- compact guard over nullable object members still fails at runtime on `0.1.56`

Upstream issue:

- [#110](https://github.com/alexstanciu-1/simplecpp/issues/110)

Current upstream state:

- `open`
- `state_reason`: `reopened`

Important issue-thread context:

- the original native crash/segfault was reduced to a controlled runtime error in newer versions
- there was discussion about whether the current intended v1 style is to prefer `isset(...)`-based probing instead
- the latest issue thread already includes a `0.1.56` recheck confirming the compact source form still does not behave like a safe guard

Local recommendation:

- do not file a duplicate
- treat `#110` as the active upstream home for this concern
- if we add more information later, post it there

## 2. Nullable Guard Docs / Guidance

Local item:

- strict docs should explicitly guide preferred nullable object-guard style

Upstream issue:

- [#113](https://github.com/alexstanciu-1/simplecpp/issues/113)

Current upstream state:

- `closed`
- `state_reason`: `completed`

Meaning:

- the docs/guidance question already has an upstream issue and was treated as resolved
- current upstream comments and strict docs now explicitly lean toward `isset(...)` / `!isset(...)` as the preferred current safe nullable-path probe form

Local recommendation:

- no new issue needed
- use this as current authoring guidance when evaluating Open M3 cleanup

## 3. Vector `unset()` Support

Local item:

- indexed `unset($items[$index])` on typed `vector<>`

Upstream issue:

- [#120](https://github.com/alexstanciu-1/simplecpp/issues/120)

Current upstream state:

- `closed`
- `state_reason`: `completed`

Important issue-thread context:

- upstream marked the feature fixed in `v0.1.46`
- the issue comments already note the `0.1.56` downstream retest:
  - builds successfully
  - runs successfully
  - only remaining nuance is the internal `nodiscard` warning from lowered `remove(...)`

Local recommendation:

- do not file a duplicate about the original unsupported-feature problem
- treat the user-facing feature as fixed

## 4. `nodiscard` Warning On Lowered `unset(...)`

Local item:

- build warns because lowered `unset(...)` ignores the return value of internal `remove(...)`

Search result:

- no direct matching issue found in the upstream tracker during this pass

Checked search themes:

- `nodiscard remove warning generated code unset`
- `generated code warning remove return value`

Current status:

- no existing issue found from the current search pass
- this is a smaller generated-code-quality concern, not a feature blocker

Local recommendation:

- keep this as a possible new issue only if we decide the warning noise matters enough
- if filed, scope it narrowly as:
  - generated-code warning hygiene
  - not as a regression in `unset(...)` functionality

## Practical Next Step

Current best tracker posture:

1. active live behavior issue stays on `#110`
2. docs/guidance concern is already covered by `#113`
3. vector `unset()` support concern is already covered and fixed by `#120`
4. only genuinely new candidate from this pass is the lower-priority `nodiscard` warning cleanup
