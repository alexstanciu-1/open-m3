# SimpleC++ / PHP++ Pain Points For Open M3

Status: working discussion note

Date: 2026-05-16

Purpose: capture the concrete SimpleC++ / PHP++ issues and slow-downs observed during Open M3 work, so they can be discussed one by one and separated into:

- upstream toolchain bugs
- repo-side workaround debt
- normal strict-language tradeoffs

## Verification Update: `scpp 0.1.45`

This file was re-checked point by point on `scpp 0.1.45` with isolated repros where possible.

### Verified current status of issues

1. `undefined symbol: main`

- current status: not reproduced
- note: this historical `0.1.36` problem does not appear to be a current live issue in the isolated checks

2. Missing `__deps/.../*.o` dependency artifacts

- current status: not reproduced in the old direct form
- note: current `scpp` reuse mode does still surface stale dependency artifacts and asks for `--build-dependencies`, but it is no longer the same confusing missing-object failure shape from the older workspace state

3. Strict-mode source shape changed under us

- current status: still true
- verified:
  - plain `<?php` in `.phs` still fails
  - `declare(strict_types=1);` is still explicitly unsupported
- nuance:
  - `declare(strict_types=1);` now gets a clear friendly message
  - plain `<?php` still reports an internal parser-style error
- new issue:
  - [#123](https://github.com/alexstanciu-1/simplecpp/issues/123) for the `<?php` diagnostic quality problem

4. Mixed JSON boundary casts / extra normalization

- current status: partially historical, partially still real
- verified:
  - typed `hash<>` / ordinary foreach flows are working well in the isolated probes
  - dynamic object iteration from literal `(object)` and `json_decode(...)` also works in the current foreach repro
- conclusion:
  - the broad “foreach is fragile” worry is too strong now
  - the remaining friction is mostly about mixed-boundary authoring clarity and normalization style, not about the basic foreach mechanics in the tested shapes

5. Top-level `const` generator crash

- current status: not reproduced
- verified:
  - isolated top-level `const` repro builds and runs successfully on `0.1.45`

6. Direct `ninja` debugging was misleading

- current status: largely improved
- verified:
  - `scpp explain-build ninja-target` now reports:
    - the direct Ninja target
    - a direct Ninja debug command
    - a warning that `.prism/build/main` is not itself a Ninja target
- conclusion:
  - the old pain point has been materially addressed

7. Compact null-check runtime fragility

- current status: still reproduced
- verified:
  - compact chained repro still fails at runtime on `0.1.45`
  - nested version runs correctly
- exact current behavior:
  - no longer segfaults
  - still violates expected short-circuit semantics and throws:
    - `scpp::shared_p runtime error: operator->() requires a present shared pointer value.`
- note:
  - this is already covered by the earlier GitHub issue thread and remains live despite the newer reply claiming the fix

8. `unset()` on indexed `vector<>`

- current status: still reproduced
- verified with isolated repro
- new issue:
  - [#120](https://github.com/alexstanciu-1/simplecpp/issues/120)

9. `string|null` ternary failure

- current status: still reproduced
- verified with isolated repro
- new issue:
  - [#121](https://github.com/alexstanciu-1/simplecpp/issues/121)

### Newly observed / newly filed issues beyond the original list

1. Unqualified helper names in strict mode no longer resolve naturally

- verified:
  - isolated repro using `trim`, `strtolower`, `substr`, and `explode` fails to compile unless explicit helper namespaces are used
- new issue:
  - [#122](https://github.com/alexstanciu-1/simplecpp/issues/122)
- note:
  - this may be an intentional rule, but it needs explicit strict-mode guidance if so

### Verified current status of friction items

1. Build workflow ambiguity

- current status: still partly real
- note:
  - after the upgrade to `0.1.45`, stale projects needed `--build-runtime` to refresh runtime artifacts
  - stale dependency artifacts still push some builds toward `--build-dependencies`

2. Mixed-data work is slower than it should be

- current status: still true as repo-side friction
- note:
  - this was not disproven by the current repros
  - the friction is now more about authoring clarity than core foreach failure

3. Toolchain failures often look like source failures

- current status: still partly true
- note:
  - runtime-artifact and stale-dependency states still show up as build friction before the real source failure is visible

4. Direct inspection of generated Ninja/build artifacts is costly and often not trustworthy

- current status: reduced
- note:
  - `scpp explain-build` improvements make this less painful than before

5. Cyclic ORM repros are expensive to reason about

- current status: still true
- note:
  - this remains repo/workload friction, not an isolated compiler bug

6. Environment/layout sensitivity

- current status: still true
- note:
  - rebuilding shared runtime artifacts still writes outside the OpenM3 workspace, which matters in sandboxed environments

7. Raw compile time is not the main complaint

- current status: still true

8. Long-running verifier/repro jobs are awkward

- current status: still true
- note:
  - the large two-phase schema verifier remains a real workflow cost even when the compiler itself is behaving

## 1. Issues Encountered

1. `base` entrypoint sometimes built but failed to link with `undefined symbol: main`.

Source:
- [specs/planning/simplecpp_0_1_36_regression_notes_2026_05_11.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_0_1_36_regression_notes_2026_05_11.md:48)

2. Projects depending on `base` sometimes failed with missing `__deps/.../*.o` artifacts, which looked like a project error but was really dependency/build-materialization fallout.

Source:
- [specs/planning/simplecpp_0_1_36_regression_notes_2026_05_11.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_0_1_36_regression_notes_2026_05_11.md:126)

3. Strict-mode source shape changed under us:

- `.phs` should no longer start with `<?php`
- no `declare(strict_types=1);`

That forced a compatibility pass across the repo.

Source:
- [specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md:25)

4. Earlier strict validation/generation required extra explicit parameter types and casts at mixed JSON boundaries, even when the intended shape felt obvious.

Source:
- [specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md:39)

5. Top-level `const` declarations previously hit a generator crash, which forced workaround patterns instead of natural source.

Source:
- [specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md:174)

6. Direct `ninja` debugging was misleading because the generated build graph could look broken when driven outside `scpp`.

Source:
- [specs/planning/scpp_0_1_16_incremental_build_report_2026_05_08.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/scpp_0_1_16_incremental_build_report_2026_05_08.md:79)

7. During the recent `relation.reverse` work, compact null-check style in strict code showed runtime fragility. Rewriting a few `x === null || x->field === ...` checks into nested checks stabilized the focused repro.

Reference:
- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:675)

Note:
- treat this as an observed strict/runtime sensitivity worth watching, not yet a fully proven upstream bug

8. `unset()` on indexed `vector<>` elements is still not supported in current strict lowering/runtime patterns.

Observed during:
- legacy descendant-expansion helper work in [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:1748)

Failure shape:
- `unset() on vector_t indexed elements is not supported yet`

Practical effect:
- normal queue/stack-style code has to be rewritten into cursor-based loops even when the original intent is simple and safe

9. Conditional expressions that mix `string` and `null` still trigger generator/type-resolution failures in strict code.

Observed during:
- legacy scalar SQL-type propagation in [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:1350)

Failure shape:
- `invalid use of incomplete type 'condition_ternary_result<string_t, null_t>'`

Practical effect:
- ordinary `condition ? string_value : null` expressions have to be manually rewritten as explicit `if` assignments
- this makes strict code more verbose and less refactor-friendly than it should be

## 2. Slow-Downs / Friction

1. Build workflow ambiguity:

- `scpp build` vs `scpp build --build-dependencies` materially changed outcomes
- this slows debugging because the first question becomes whether the failure is code or invocation shape

Source:
- [specs/simple_cpp_php_strict_quick_learn.md](/home/alexv/__AI/open_m3/open_m3_01/specs/simple_cpp_php_strict_quick_learn.md:27)

2. Mixed-data work is slower than it should be.

- JSON / legacy maps often need repetitive normalization and explicit casts
- this adds noise around ordinary model-loader logic

Source:
- [specs/planning/simplecpp_lang_surface_report_2026_05_11.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_lang_surface_report_2026_05_11.md:78)

3. Toolchain failures often look like source failures.

- missing dep state
- runtime-cache writes
- depfile issues
- dependency-object issues

These can masquerade as application bugs.

Source:
- [specs/planning/simplecpp_usability_feedback_2026_05_08_details.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_usability_feedback_2026_05_08_details.md:29)

4. Direct inspection of generated Ninja/build artifacts is costly and often not trustworthy enough to speed things up.

Source:
- [specs/planning/simplecpp_usability_feedback_2026_05_08_details.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_usability_feedback_2026_05_08_details.md:70)

5. Cyclic ORM repros can be expensive to reason about because the root builder keeps traversing until depth limit unless the sample shape is explicitly constrained.

Reference:
- [tools/relation_reverse_m2m_repro/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/relation_reverse_m2m_repro/main.phs:1)

6. Environment/layout sensitivity is a drag.

- local symlink expectations
- slow WSL `/mnt/...` trees

Sources:
- [specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md:125)
- [specs/codex_wsl_handoff_2026-04-27.md](/home/alexv/__AI/open_m3/open_m3_01/specs/codex_wsl_handoff_2026-04-27.md:370)

7. Raw compile time is not the main complaint in this repo state.

The bigger slow-down has been failed or ambiguous builds, not compile throughput itself. Incremental rebuilds can be fine once the build graph is healthy.

8. Long-running verifier/repro jobs are awkward to work with when iteration speed matters.

Observed during:
- the two-phase legacy schema verifier path in [tools/verify_model_loader/orm_audit_sample.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/verify_model_loader/orm_audit_sample.phs:1)

Practical effect:
- once the generated graph is large, end-to-end validation can take several minutes
- this makes it harder to separate "compile friction" from "runtime verification cost"

Note:
- this is not necessarily a compiler bug, but it is still real workflow friction for OpenM3
