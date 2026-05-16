# SimpleC++ / PHP++ Pain Points For Open M3

Status: working discussion note

Date: 2026-05-16

Purpose: capture the concrete SimpleC++ / PHP++ issues and slow-downs observed during Open M3 work, so they can be discussed one by one and separated into:

- upstream toolchain bugs
- repo-side workaround debt
- normal strict-language tradeoffs

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
