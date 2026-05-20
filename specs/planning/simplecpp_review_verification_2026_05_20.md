# SimpleC++ Review Verification

Status: active verification note

Date: 2026-05-20

Purpose: verify the current live status of selected SimpleC++ review findings against the installed toolchain instead of relying only on older Open M3 observations.

Verified toolchain:

- `scpp 0.1.56`
- upstream repo root: `/home/alexv/__AI/simple_cpp/stable`
- upstream commit from `scpp --doctor`: `51d46a94b9ec`

Saved repro workspace:

- `/tmp/simplecpp-review-HRBsG1`

Each kept sample is intended to be reusable later for GitHub issue triage.

## Verification Summary

| Topic | Previous Open M3 concern | Current status on `0.1.56` | Evidence |
| --- | --- | --- | --- |
| Compact null-guard short-circuit | runtime fragility | `still live` | `/tmp/simplecpp-review-HRBsG1/null_guard_compact` |
| `string|null` ternary | generator/type failure | `fixed` | `/tmp/simplecpp-review-HRBsG1/nullable_string_ternary` |
| `unset()` on indexed `vector<>` | unsupported / failing | `fixed with nuance` | `/tmp/simplecpp-review-HRBsG1/vector_unset` |
| `unset()` on `hash<>` | baseline comparison | `works` | `/tmp/simplecpp-review-HRBsG1/hash_unset` |
| Unqualified strict helper calls | compile failures for common helpers | `fixed / documented` | `/tmp/simplecpp-review-HRBsG1/unqualified_helpers` and upstream strict docs |
| Strict philosophy around explicitness / `take(...)` | alignment question | `documented upstream` | upstream strict quick-learn and `specs/strict_mode.md` |

## 1. Compact Null Guard

Sample:

- `/tmp/simplecpp-review-HRBsG1/null_guard_compact/main.phs`

Command result:

- `scpp build`: success
- `scpp run`: runtime failure

Observed runtime behavior:

- first call prints `match=yes`
- second/third path fails at:
  - `main.phs:15`
  - operation: `operator->`
  - category: `runtime / invalid_shared_arrow_null`

Saved diagnostic evidence:

- `/tmp/simplecpp-review-HRBsG1/null_guard_compact/.prism/last_error.json`

Conclusion:

- the original Open M3 concern is still live
- diagnostics are better than the older behavior because the failure now maps back to the original `.phs` line and provides a stable runtime category/code
- the core semantic problem remains: natural strict short-circuit code still dereferences through a nullable path

## 2. Nullable `string|null` Ternary

Sample:

- `/tmp/simplecpp-review-HRBsG1/nullable_string_ternary/main.phs`

Command result:

- `scpp build`: success
- `scpp run`: success

Observed output:

```text
yes=ok
no=
```

Conclusion:

- the earlier Open M3 concern is no longer live on `0.1.56`
- this item should be removed from the active pain list and treated as fixed unless a more complex variant still fails

## 3. `unset()` On Indexed `vector<>`

Sample:

- `/tmp/simplecpp-review-HRBsG1/vector_unset/main.phs`

Command result:

- `scpp build`: success
- `scpp run`: success

Observed output:

```text
count=2
```

Nuance:

- build emits a C++ warning that the lowered internal `remove(...)` return value is ignored
- runtime behavior itself is correct

Conclusion:

- the older Open M3 concern is no longer live as a user-visible failure
- there is still a small implementation-quality follow-up worth noting because the generated/lowered path triggers a `nodiscard` warning

## 4. `unset()` On `hash<>`

Sample:

- `/tmp/simplecpp-review-HRBsG1/hash_unset/main.phs`

Command result:

- `scpp build`: success
- `scpp run`: success

Observed output:

```text
has_a=no
has_b=yes
```

Nuance:

- build also emits a `nodiscard` warning from the lowered internal `remove(...)` call

Conclusion:

- supported and working
- same internal warning nuance as the vector case

## 5. Unqualified Strict Helper Calls

Sample:

- `/tmp/simplecpp-review-HRBsG1/unqualified_helpers/main.phs`

Command result:

- `scpp build`: success
- `scpp run`: success

Observed output:

```text
he
2
```

Docs evidence:

- `/home/alexv/__AI/simple_cpp/stable/specs/simple_cpp_php_strict_quick_learn.md`
- builtin docs found for:
  - `trim`
  - `strtolower`
  - `substr`
  - `explode`

Conclusion:

- the earlier Open M3 concern is no longer live on `0.1.56`
- strict docs now explicitly present these helpers as supported strict builtins

## 6. Strict Philosophy And `take(...)`

Docs evidence:

- `/home/alexv/__AI/simple_cpp/stable/specs/simple_cpp_php_strict_quick_learn.md`
- `/home/alexv/__AI/simple_cpp/stable/specs/strict_mode.md`

Confirmed current upstream wording:

- strict mode is not designed for the shortest possible code
- `take(...)` exists to keep success, failure, absence, and usable values explicit
- wrapper-aware results are part of the intended strict surface

Conclusion:

- this part of the Open M3 review lens is now strongly aligned with upstream docs
- it does not need a GitHub issue
- it should instead be treated as a confirmed design principle when writing future review notes

## 7. Collection-Unset Documentation Status

Docs evidence:

- `/home/alexv/__AI/simple_cpp/stable/specs/array_semantics.md`

Confirmed current upstream wording:

- `unset($a[k])` is documented as:
  - no-op on missing keys
  - removal on existing keys

Conclusion:

- collection unset behavior now appears to be part of the documented supported subset
- any remaining follow-up here is about internal warning cleanliness, not feature absence

## Practical Triage Outcome

Still issue-worthy from this verification pass:

1. compact nullable short-circuit runtime failure remains live
2. possibly a smaller implementation-quality issue about lowered `unset(...)` paths ignoring `nodiscard` `remove(...)` return values

No longer active as original pain points:

1. nullable `string|null` ternary
2. unqualified common strict helpers
3. vector/hash `unset(...)` as an unsupported user-facing operation

Best next step for issue prep:

- use `/tmp/simplecpp-review-HRBsG1/null_guard_compact` as the primary live repro
- optionally keep `/tmp/simplecpp-review-HRBsG1/vector_unset` and `/tmp/simplecpp-review-HRBsG1/hash_unset` as references if we decide to file a smaller warning-cleanup issue
