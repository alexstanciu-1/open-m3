# SimpleC++ GitHub Retest

Status: active verification note

Date: 2026-05-22

Purpose:

- confirm the installed `scpp` version before retesting
- re-evaluate upstream releases published in the last 2 days
- re-test the relevant GitHub issues and release-note repros on the current toolchain

## Installed Toolchain

Verified with `scpp --doctor`:

- `scpp 0.1.60`
- upstream repo root: `/home/alexv/__AI/simple_cpp/stable`
- upstream commit from `scpp --doctor`: `4be8f1811df5`
- `git_up_to_date_with_origin_main: yes`

Update hygiene:

- `scpp update`: `Already up to date.`
- `scpp update --force`: also rebuilt the shared release runtime cache

Important runtime-cache observation:

- before `scpp update --force`, fresh strict projects in default reuse mode failed because the shared release runtime artifact was missing at:
  - `/home/alexv/__AI/simple_cpp/stable/.prism/runtime/release/php-strict/debug/libruntime.so`
- after `scpp update --force`, the shared release runtime matrix existed for:
  - `php-legacy/debug`
  - `php-legacy/release`
  - `php-strict/debug`
  - `php-strict/release`
- after that forced refresh, ordinary strict `scpp build` reuse-mode runs succeeded again

## Release Window Reviewed

The last 2-day release window for the installed upstream checkout is:

- `0.1.57` on 2026-05-20
- `0.1.58` on 2026-05-21
- `0.1.59` on 2026-05-21
- `0.1.60` on 2026-05-21

Release-note source:

- `/home/alexv/__AI/simple_cpp/stable/CHANGELOG.md`

## Summary Table

| Release / issue | Current result on `0.1.60` | Today’s conclusion |
| --- | --- | --- |
| `0.1.57` missing reusable runtime artifact diagnostics | reproduced clear first-class preflight error before force-refresh | resolved as a diagnostics improvement |
| `0.1.58` / GitHub issue `#162` shared release runtime reuse | partially improved, but still needs follow-up | follow up needed |
| `0.1.59` first-class `dynamic` alias hotfix | not tied to a GH issue in the reviewed release notes | no GH retest target from this pass |
| `0.1.60` first-class `dynamic` Phase 1 | not tied to a GH issue in the reviewed release notes | no GH retest target from this pass |
| GitHub issue `#110` compact chained nullable guard | still fails at runtime | nothing changed |
| GitHub issue `#113` nullable guard docs guidance | docs guidance present and still matches current authoring recommendation | resolved |
| GitHub issue `#120` indexed `unset()` on `vector<>` | works; warning nuance remains | resolved, optional low-priority warning follow-up only |

## 1. GitHub Issue `#162`

Issue:

- [#162](https://github.com/alexstanciu-1/simplecpp/issues/162)

Current tracker state:

- `open`

Release relevance:

- explicitly referenced by the `0.1.58` planning anchor
- closely related to the `0.1.57` missing-runtime-artifact diagnostics release note

What was retested:

1. fresh strict repro projects using default `scpp build`
2. `scpp update`
3. `scpp runtime-build --debug`
4. `scpp update --force`

Observed behavior before forced update:

- plain strict `scpp build` failed in reuse mode with a clear preflight message:
  - `Required runtime artifact is missing.`
  - expected path:
    - `/home/alexv/__AI/simple_cpp/stable/.prism/runtime/release/php-strict/debug/libruntime.so`
- this confirms the `0.1.57` diagnostics improvement is working as intended
- plain `scpp update` on an already-current checkout did not repair the missing strict shared runtime artifact
- `scpp runtime-build --debug` from the Open M3 workspace only prepared `php-legacy/debug`, not the missing strict shared runtime artifact

Observed behavior after forced update:

- `scpp update --force` populated the strict shared release runtime artifacts
- after that, the same strict repro projects succeeded in ordinary reuse mode

Conclusion:

- the release direction is clearly improved versus older behavior
- however, `#162` should stay open for now because the practical shared-runtime recovery story is still incomplete when:
  - the checkout is already current
  - the strict shared release artifact is missing
  - the user runs plain `scpp update` instead of `scpp update --force`

Recommended follow-up:

- add a comment to `#162` with today’s `0.1.60` retest
- scope the comment narrowly:
  - diagnostics are better
  - `scpp update --force` repairs the full shared runtime matrix
  - plain already-current `scpp update` did not repopulate the missing strict shared runtime artifact in this checkout

## 2. GitHub Issue `#110`

Issue:

- [#110](https://github.com/alexstanciu-1/simplecpp/issues/110)

Current tracker state:

- `open`

Retest sample:

- compact chained nullable guard over nullable object members

Observed result on `0.1.60`:

- build: success
- run: still fails at runtime
- output:

```text
match=yes
scpp::shared_p runtime error: operator->() requires a present shared pointer value.
```

Conclusion:

- nothing changed for the core semantic bug
- `#110` remains live

## 3. GitHub Issue `#113`

Issue:

- [#113](https://github.com/alexstanciu-1/simplecpp/issues/113)

Current tracker state:

- `closed`

Retest basis:

- current strict quick-learn in the installed upstream checkout

Relevant current guidance:

- preferred nullable-path guard form:
  - `if (!isset($root->child->name)) { ... }`
- less preferred form:
  - long manual null chain with `||`
- docs explicitly say:
  - `prefer isset(...) for compact nullable-path checks`

Docs evidence:

- `/home/alexv/__AI/simple_cpp/stable/specs/simple_cpp_php_strict_quick_learn.md`

Conclusion:

- the docs-guidance issue remains resolved
- no follow-up needed from this pass

## 4. GitHub Issue `#120`

Issue:

- [#120](https://github.com/alexstanciu-1/simplecpp/issues/120)

Current tracker state:

- `closed`

Retest sample:

- typed `vector<string>` with `unset($items[1])`

Observed result on `0.1.60`:

- build: success
- run: success
- output:

```text
count=2
```

Nuance:

- the explicit runtime rebuild path still emits the previously known lowered warning:
  - internal `remove(...)` return value ignored on the generated `unset(...)` path

Conclusion:

- the user-facing feature remains fixed
- no reopen needed
- warning hygiene is still only an optional low-priority follow-up

## 5. Recent Release-Note Repros Without A GH Issue In This Pass

These were still worth rechecking because they were explicitly named in the reviewed release notes.

### Unqualified strict helpers

Observed result on `0.1.60`:

```text
he
2
```

Conclusion:

- still fixed

### Nullable `string|null` ternary

Observed result on `0.1.60`:

```text
yes=ok
no=
```

Conclusion:

- still fixed

## Practical Outcome

Best current triage posture:

1. `#162`: keep open and add a follow-up comment with the `0.1.60` retest nuance
2. `#110`: still open, still live, no change in behavior
3. `#113`: resolved, docs still match the intended workaround style
4. `#120`: resolved, only optional warning-cleanup remains
