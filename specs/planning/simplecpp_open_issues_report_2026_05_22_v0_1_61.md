# SimpleC++ Open Issues Report (`v0.1.61`)

Status: active triage note

Date: 2026-05-22

Purpose:

- confirm the local Open M3 toolchain after updating to `scpp 0.1.61`
- re-check the currently open SimpleC++ GitHub issues against the new release
- recommend the next action for each issue:
  - close
  - reply
  - keep open
  - keep open but narrow/reframe

Repository:

- `alexstanciu-1/simplecpp`

Toolchain snapshot:

- `scpp 0.1.61`
- upstream repo root: `/home/alexv/__AI/simple_cpp/stable`
- upstream commit: `2bdf5082a30d`
- `git_up_to_date_with_origin_main: yes`

Open-issue snapshot reviewed:

- 2026-05-22
- GitHub open issues visible in repo:
  - `#171`
  - `#166`
  - `#165`
  - `#164`
  - `#163`
  - `#162`
  - `#158`
  - `#110`
  - `#96`
  - `#90`

## Release `0.1.61` Signals

The `0.1.61` changelog explicitly claims improvements in three areas relevant to the current open set:

- typed vector reassignment / const-parameter `foreach`
- runtime diagnostics presentation and saved-report flow
- strict JSON-boundary guidance

That means the highest-value retests for this pass were:

1. `#171`
2. `#166`
3. `#90`
4. `#158`
5. `#110` as the main still-live nullable-path contrast case

## Direct Retests Performed

### `#171` typed vector reassignment + const parameter `foreach`

Fresh strict repro on `0.1.61`:

```php
function demo(vector<string> $columns, string $kind): vector<string>
{
	$column_list = $columns;

	if ($kind === "singular_ref") {
		$column_list = ["Id"];
		foreach ($columns as $column_name) {
			$column_list[] = $column_name;
		}
	}

	return $column_list;
}
```

Observed result:

- `scpp build`: success
- run output:
  - `Id`
  - `Name`
  - `Type`

Conclusion:

- the concrete issue repro now works on `0.1.61`
- this issue is ready to close

### `#110` compact nullable short-circuit guard

Fresh strict repro on `0.1.61`:

```php
$match = ($root === null || $root->child === null || $root->child->name === null) ? "no" : "yes";
```

Observed result:

- first call prints `match=yes`
- nullable path still fails at runtime
- current default runtime output is now:

```text
Runtime error in main.phs:13
Cannot convert value at this typed boundary.
Source:
> 13 | 	$match = ($root === null || $root->child === null || $root->child->name === null) ? "no" : "yes";
Operation: operator->
Run 'scpp error' for more details.
Run 'scpp full-error' for the saved JSON report.
```

Conclusion:

- the semantic issue remains live
- the failure presentation is much better than before
- keep `#110` open

### `#166` diagnostics precision

Current `0.1.61` default runtime output for the `#110` repro now includes:

- remapped source file + line
- source snippet
- operation name
- source-first default presentation
- explicit `scpp error` / `scpp full-error` follow-up guidance

This aligns closely with the current upstream comment on `#166`.

Conclusion:

- the main diagnostics goal appears substantially satisfied
- close `#166`, or leave one short confirming reply and then close

### `#90` expression/source-context runtime diagnostics

Compared with the original request, the current shipped diagnostics now clearly provide:

- source-first remapped location
- a source snippet
- a much cleaner author-facing default runtime summary

The remaining gap is narrower:

- exact expression/path naming in all cases
- richer saved JSON/source-context fields beyond the current short summary

Conclusion:

- no longer a high-priority active pain point
- do not treat as urgent
- best action: reply that `0.1.61` substantially improves this and ask whether the remaining ask is specifically richer expression/path metadata

### `#158` JSON-boundary ergonomics / guidance

`0.1.61` added explicit guidance in the upstream quick-learn for:

- treating `json_decode(...)` as a fat-variable boundary
- documenting expected payload shape locally
- stabilizing early into typed locals/properties/objects/containers

This directly addresses the issue’s request for clearer strict guidance.

Conclusion:

- guidance/documentation side is addressed
- close `#158`, or leave a final reply pointing to the new guidance and then close

## Remaining Open-Issue Recommendations

### `#171`

Status on `0.1.61`:

- verified fixed locally

Recommended action:

- close

### `#166`

Status on `0.1.61`:

- effectively addressed by the new source-first runtime diagnostics flow

Recommended action:

- close

### `#165`

Status on `0.1.61`:

- not directly reproed in this pass
- latest issue comments suggest several earlier-sensitive cases now have direct regression coverage
- still reasonable as a bucket for fresh hash+nullable repros only

Recommended action:

- keep open
- reply only if we want to request one fresh still-live minimal repro

### `#164`

Status on `0.1.61`:

- not directly reproed in this pass
- latest issue comments suggest the issue is now too broad and overlaps with `#110` / `#165`

Recommended action:

- keep open but narrow/reframe
- best next step is to ask for 2-3 fresh indirect-only repros, otherwise consider closing as too vague

### `#163`

Status on `0.1.61`:

- latest issue comments suggest the original confusing linker symptom is already addressed
- remaining value is a broader cache/artifact-hardening bucket

Recommended action:

- reply that the original narrow symptom looks fixed
- either close, or rename/reframe later if upstream wants a general robustness bucket

### `#162`

Status on `0.1.61`:

- not re-broken in this pass
- upstream comments now lean toward “mostly historical / documentation clarity”
- current docs now clearly say:
  - `scpp update` refreshes the default shared runtime cache when a real update lands
  - `scpp update --force` rebuilds it even when already current
  - `scpp runtime-build` explicitly rebuilds the reusable runtime cache

Recommended action:

- reply with the updated `0.1.61` docs posture
- unless a fresh repro still exists, this looks closeable soon

### `#158`

Status on `0.1.61`:

- guidance request now directly addressed in docs

Recommended action:

- close

### `#110`

Status on `0.1.61`:

- still live
- new diagnostics make it easier to understand, but behavior is still not safe

Recommended action:

- keep open

### `#96`

Status on `0.1.61`:

- issue comment already says fixed in `v0.1.49`
- no conflicting evidence seen in this pass

Recommended action:

- close

### `#90`

Status on `0.1.61`:

- substantially improved by current runtime-diagnostics work
- possible smaller follow-up remains

Recommended action:

- reply rather than close immediately
- ask whether the remaining request is specifically expression/path metadata

## Practical Action Queue

If we want the cleanest next GitHub pass from the Open M3 side:

1. close `#171`
2. close `#166`
3. close `#158`
4. close `#96`
5. keep `#110` open
6. reply on `#90`
7. reply on `#162`
8. decide whether `#163` should close or be reframed
9. keep `#164` and `#165` only if we still want broad buckets for fresh repros

## Net Take

After upgrading to `scpp 0.1.61`, the open SimpleC++ issue list looks healthier than it did on `0.1.60`.

The biggest concrete change from today’s direct retest is:

- `#171` is fixed

The biggest workflow-quality change is:

- runtime diagnostics are now source-first enough that `#166` and much of `#90` look largely satisfied

The clearest still-live strict correctness issue from Open M3 remains:

- `#110`
