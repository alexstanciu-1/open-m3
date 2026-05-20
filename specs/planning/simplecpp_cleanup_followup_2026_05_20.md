# SimpleC++ Cleanup Follow-Up

Status: active cleanup note

Date: 2026-05-20

Purpose: record Open M3 code-cleanup opportunities that are now reasonable because current SimpleC++ behavior and docs have improved since earlier repo work.

Related notes:

- [SimpleC++ full review](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_full_review_2026_05_20.md:1)
- [SimpleC++ review verification](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_review_verification_2026_05_20.md:1)

Verified toolchain baseline for this note:

- `scpp 0.1.56`
- upstream repo root: `/home/alexv/__AI/simple_cpp/stable`

## Main Idea

Some current Open M3 source patterns were written defensively around older SimpleC++ limitations.

After verification on `scpp 0.1.56`, part of that defensive surface can now be revisited.

This note is not an instruction to rewrite code aggressively.

It is a shortlist of places where Open M3 can probably simplify, clarify, or modernize source because the upstream toolchain has improved.

## Cleanup Principles

Use these rules when applying cleanup:

1. prefer the smallest safe source simplification
2. do not remove explicitness that still improves readability
3. only remove workaround code when the underlying behavior was re-verified on current `scpp`
4. keep repo-local repro samples or notes when the history still matters for debugging
5. re-test affected projects after cleanup, especially shared `base/` code

## 1. Remove Historical Language Pain Points From Active Review Lists

These items should no longer be treated as active upstream blockers unless a narrower variant still fails.

### A. Nullable `string|null` ternary

Current status:

- verified working on `scpp 0.1.56`

Repro:

- `/tmp/simplecpp-review-HRBsG1/nullable_string_ternary`

Cleanup implication:

- remove this from active "current pain point" summaries
- if Open M3 still contains manual `if` assignments written only to avoid this old problem, those sites can be re-evaluated case by case

### B. Unqualified common strict string helpers

Current status:

- verified working on `scpp 0.1.56`
- documented upstream in the current strict quick-learn

Repro:

- `/tmp/simplecpp-review-HRBsG1/unqualified_helpers`

Cleanup implication:

- older notes suggesting these helpers do not resolve naturally should be updated or scoped to older versions only
- Open M3 can rely on current documented support for:
  - `trim`
  - `strtolower`
  - `substr`
  - `explode`

### C. `unset()` on `vector<>` as an unsupported surface

Current status:

- verified working on `scpp 0.1.56`

Repro:

- `/tmp/simplecpp-review-HRBsG1/vector_unset`

Cleanup implication:

- remove or downgrade older notes that describe indexed `vector<>` `unset()` as unsupported
- if Open M3 has cursor-based rewrites whose only purpose was avoiding the old failure, those can be reviewed for simplification

Nuance:

- current lowering still emits a `nodiscard` warning internally, so this is not fully "finished" upstream
- that warning does not block normal user-facing behavior

## 2. Keep Live Workarounds Where The Underlying Problem Still Exists

These should not be cleaned up away yet.

### A. Compact chained null-guard workarounds

Current status:

- still fails at runtime on `scpp 0.1.56`

Repro:

- `/tmp/simplecpp-review-HRBsG1/null_guard_compact`

Cleanup implication:

- do not collapse nested safe null guards back into compact chained forms yet
- keep existing expanded/null-safe patterns in Open M3 source
- treat these patterns as active compatibility code, not stale workaround noise

## 3. Documentation Cleanup Inside Open M3

Open M3 planning notes now span multiple SimpleC++ versions.

Cleanup opportunities:

1. mark older version-specific pain points as historical when they were re-verified as fixed
2. keep the historical note, but add a current-status line near the top
3. avoid carrying old limitations forward into current authoring advice unless re-confirmed

Best candidates:

- `specs/planning/simplecpp_usability_feedback_2026_05_08.md`
- `specs/planning/simplecpp_openm3_pain_points_2026_05_16.md`
- `specs/planning/simplecpp_lang_surface_report_2026_05_11.md`

## 4. Code Cleanup Candidates To Revisit Later

This section is intentionally cautious.

It does not claim these should all be changed immediately.

It records where to look once we decide to do a source cleanup pass.

### A. Manual ternary-expansion leftovers

Look for:

- places where a simple nullable ternary was expanded into longer `if` assignment only because of older lowering limits

Action:

- re-check whether the shorter explicit form is now correct and still readable

### B. Older helper-resolution workaround style

Look for:

- source written in a more awkward form only because common string helpers were thought to be unavailable in strict mode

Action:

- simplify only when the result is clearly easier to read

### C. Cursor-heavy vector-removal workarounds

Look for:

- loops that were written in a more complicated style only to avoid indexed vector removal

Action:

- simplify only if behavior stays obvious and test coverage remains good

## 5. Things Not To “Clean Up”

These should remain part of the intended strict style.

Do not remove them just because the language gained other improvements.

### A. Explicit types

Reason:

- they are part of the quality/readability goal, not temporary overhead

### B. `take(...)`-style checked operation boundaries

Reason:

- current upstream docs explicitly support this as a strict-mode pattern
- it matches Open M3’s safety expectations

### C. Explicit mixed-boundary normalization when shape is genuinely dynamic

Reason:

- not every cast/guard is workaround debt
- some of it is the right cost for crossing dynamic metadata into typed structures

## 6. Recommended Cleanup Order

When Open M3 performs a cleanup pass, use this order:

1. update planning docs to mark fixed items as historical
2. preserve still-live compatibility patterns such as expanded null guards
3. review obvious old workaround code in isolated low-risk places
4. retest affected `base/` and tool projects after each small batch
5. only then consider broader style simplification

## Final Conclusion

The current SimpleC++ improvements do justify some Open M3 cleanup.

But the cleanup should be selective.

The right goal is:

- remove stale workaround assumptions
- keep still-needed safety workarounds
- preserve explicit high-quality strict code

This is not a “make the code shorter” pass.

It is a “stop paying for old limitations that are now gone” pass.
