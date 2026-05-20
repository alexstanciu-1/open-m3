# SimpleC++ GitHub Triage Shortlist

Status: active triage note

Date: 2026-05-20

Purpose: convert the current verified SimpleC++ review state into a short GitHub-issue-oriented triage list.

Verification basis:

- [SimpleC++ review verification](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_review_verification_2026_05_20.md:1)
- saved repro workspace: `/tmp/simplecpp-review-HRBsG1`
- verified toolchain: `scpp 0.1.56`

## Triage Rules

This shortlist includes:

- still-live issues worth filing or checking against existing upstream issues
- smaller implementation-quality follow-ups that are no longer feature blockers but may still deserve cleanup

This shortlist excludes:

- concerns already verified as fixed and documented
- philosophical alignment points that now match upstream docs and do not need an issue

## 1. Compact Nullable Short-Circuit Still Dereferences Through Null

Issue title:

- strict compact nullable short-circuit guard still evaluates `->` on null path at runtime

Status:

- still live on `scpp 0.1.56`

Repro path:

- `/tmp/simplecpp-review-HRBsG1/null_guard_compact`

Sample:

```php
$match = ($root === null || $root->child === null || $root->child->name === null) ? "no" : "yes";
```

Expected:

- ordinary short-circuit semantics
- when `$root` is `null`, or `$root->child` is `null`, the rest of the chain should not dereference further
- program should print:

```text
match=yes
match=no
match=no
```

Actual:

- first call succeeds
- later run fails at source line `main.phs:15`
- runtime category: `invalid_shared_arrow_null`
- runtime message: `operator->() requires a present shared pointer value`

Suggested issue priority:

- high

Why priority is high:

- this is a correctness issue, not a style preference
- it affects natural readable strict code
- it pushes users toward expanded workaround code for ordinary nullable guards

Notes:

- current diagnostics are better than older reports because the error maps back to the original `.phs` line and includes a stable category
- the semantic/runtime bug remains

## 2. Lowered `unset(...)` Paths Ignore `nodiscard` `remove(...)` Result

Issue title:

- lowered strict `unset(...)` on vector/hash ignores internal `remove(...)` `nodiscard` result and emits build warnings

Status:

- live as implementation-quality warning
- not a user-facing feature failure

Repro paths:

- `/tmp/simplecpp-review-HRBsG1/vector_unset`
- `/tmp/simplecpp-review-HRBsG1/hash_unset`

Expected:

- `unset(...)` should build cleanly when the surface operation is supported
- no avoidable warning should be emitted from the generated/lowered implementation

Actual:

- both samples build and run correctly
- both builds emit warnings about ignoring the return value of internal `remove(...)`

Suggested issue priority:

- low-medium

Why priority is not higher:

- runtime behavior is correct
- feature support now exists
- this is primarily warning hygiene / lowering quality

Notes:

- this could be folded into a general generated-code warning-cleanup issue if upstream prefers broader cleanup over a narrow standalone issue

## 3. Check Existing Issue Before Filing: Compact Null Guard

Issue title:

- triage check: confirm whether compact null-guard runtime failure already has an open active issue

Status:

- triage action required before filing duplicate

Repro path:

- `/tmp/simplecpp-review-HRBsG1/null_guard_compact`

Expected:

- either reuse an existing live issue with updated `0.1.56` repro confirmation
- or file a fresh issue if the old one is closed/stale/not equivalent

Actual:

- local verification confirms the problem is still present on `0.1.56`

Suggested issue priority:

- high if no current issue exists
- medium if this is only an update comment on an already-open issue

Notes:

- the valuable new contribution here is not only the repro
- it is the confirmation that the behavior still reproduces on `0.1.56` plus the saved structured runtime report

## Not Issue-Worthy After Verification

These should not be filed as new issues from this pass unless a more specific new variant appears.

### A. Nullable `string|null` ternary

Reason:

- verified fixed on `scpp 0.1.56`

Repro kept at:

- `/tmp/simplecpp-review-HRBsG1/nullable_string_ternary`

### B. Unqualified strict `trim` / `strtolower` / `substr` / `explode`

Reason:

- verified working
- documented upstream

Repro kept at:

- `/tmp/simplecpp-review-HRBsG1/unqualified_helpers`

### C. `unset()` on `vector<>` or `hash<>` as unsupported user-facing behavior

Reason:

- both verified working
- only warning-cleanup follow-up remains

Repro kept at:

- `/tmp/simplecpp-review-HRBsG1/vector_unset`
- `/tmp/simplecpp-review-HRBsG1/hash_unset`

## Recommended Next Triage Action

1. search upstream issues for the compact null-guard problem first
2. if an issue exists, add a concise update with:
   - `scpp 0.1.56`
   - repro path
   - expected vs actual
   - note that diagnostics improved but runtime semantics are still wrong
3. optionally file or batch the `nodiscard` warning cleanup as a lower-priority generated-code-quality issue
