# SimpleC++ GitHub Comment Drafts

Status: draft issue text

Date: 2026-05-20

Purpose: keep ready-to-paste GitHub text for the current upstream SimpleC++ triage follow-up.

Related notes:

- [SimpleC++ GitHub issue mapping](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_github_issue_mapping_2026_05_20.md:1)
- [SimpleC++ review verification](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_review_verification_2026_05_20.md:1)

Saved repro set:

- `/tmp/simplecpp-review-HRBsG1`

## 1. Update Comment For `#110`

Target:

- [#110](https://github.com/alexstanciu-1/simplecpp/issues/110)

Suggested paste:

```md
Rechecked this again on `scpp 0.1.56` from a fresh `/tmp` strict repro.

Current status: still reproducing.

The behavior is better than the original `0.1.42` report because it no longer crashes with exit `139`, but the compact chained null guard is still not semantically safe as a nullable-path guard.

Repro source:

```php
namespace review\null_guard_compact;

class child_state
{
    public ?string $name = null;
}

class root_state
{
    public ?child_state $child = null;
}

function test_guard(?root_state $root): void
{
    $match = ($root === null || $root->child === null || $root->child->name === null) ? "no" : "yes";
    echo "match=", $match, "\n";
}

$full = new root_state();
$full->child = new child_state();
$full->child->name = "ok";
test_guard($full);

$missing_child = new root_state();
test_guard($missing_child);

test_guard(null);
```

Commands used:

```bash
scpp build
scpp run
```

Current observed output on `0.1.56`:

```text
match=yes
Project mode: strict. Prefer supported Prism++ patterns over standard PHP assumptions.
Runtime error in main.phs:15
Cannot convert value at this typed boundary.
Operation: operator->
Runtime message: scpp::shared_p runtime error: operator->() requires a present shared pointer value.
```

Expected result:

```text
match=yes
match=no
match=no
```

So from the Open M3 side, the current state still looks like:

- old crash-class severity: improved
- diagnostics/source mapping: improved
- compact guard semantics as a safe nullable-path guard: still not fixed

I agree that `isset($node->child->name)` / `!isset($node->child->name)` is the better current v1 authoring rule, but I wanted this thread to reflect that the compact short-circuit source form still does not behave like a safe guard on `0.1.56`.
```

## 2. New Low-Priority Issue Draft For `nodiscard` Warning

Suggested title:

- strict lowered `unset(...)` emits avoidable `nodiscard` warning from internal `remove(...)` call

Suggested paste:

```md
## Summary

The user-facing `unset(...)` behavior now works correctly in strict projects, but the current lowering still emits avoidable compiler warnings because the generated/internal path ignores the return value of `remove(...)`, which is marked `[[nodiscard]]`.

This is not a functional regression. It looks like generated-code warning hygiene.

## Verified on

- `scpp 0.1.56`
- strict Prism++ / `.phs` projects

## Repro 1: vector indexed unset

`prism.json`
```json
{
  "config_version": 1,
  "project_name": "vector_unset",
  "entrypoint": "main.phs",
  "build_dir": ".prism/build",
  "generated_dir": ".prism/generated",
  "cache_dir": ".prism/cache",
  "native_cpp_dir": "native_cpp",
  "build": { "backend": "ninja", "mode": "debug", "cxx": null },
  "fastcgi": { "enabled": false, "workers": 1, "max_body_size": 4194304, "max_requests": 0 },
  "runtime": { "languages": { "php": { "profile": "strict" } } }
}
```

`main.phs`
```php
namespace review\vector_unset;

$items vector<string> = ["a", "b", "c"];
unset($items[1]);
echo "count=", count($items), "\n";
```

## Repro 2: hash keyed unset

`prism.json`
```json
{
  "config_version": 1,
  "project_name": "hash_unset",
  "entrypoint": "main.phs",
  "build_dir": ".prism/build",
  "generated_dir": ".prism/generated",
  "cache_dir": ".prism/cache",
  "native_cpp_dir": "native_cpp",
  "build": { "backend": "ninja", "mode": "debug", "cxx": null },
  "fastcgi": { "enabled": false, "workers": 1, "max_body_size": 4194304, "max_requests": 0 },
  "runtime": { "languages": { "php": { "profile": "strict" } } }
}
```

`main.phs`
```php
namespace review\hash_unset;

$items hash<int> = [];
$items["a"] = 10;
$items["b"] = 20;
unset($items["a"]);
echo "has_a=", isset($items["a"]) ? "yes" : "no", "\n";
echo "has_b=", isset($items["b"]) ? "yes" : "no", "\n";
```

## Commands

```bash
scpp build
scpp run
```

## Actual result

Both projects build and run successfully, but the build emits warnings like:

Vector case:

```text
warning: ignoring return value of ‘bool scpp::vector_t<T>::remove(...)’, declared with attribute ‘nodiscard’
```

Hash case:

```text
warning: ignoring return value of ‘bool scpp::hash_t<...>::remove(...)’, declared with attribute ‘nodiscard’
```

## Runtime result

Vector case:

```text
count=2
```

Hash case:

```text
has_a=no
has_b=yes
```

## Expected result

- `unset(...)` should continue to work as it does now
- generated/lowered code should not emit avoidable `nodiscard` warnings when the surface operation is fully supported

## Why this seems low priority

- functionality is correct
- this does not block strict authoring
- this is mainly about keeping generated builds clean and reducing warning noise
```
