# SimpleC++ ORM Friction Log

Date: 2026-05-20

Purpose: record the concrete Simple C++ friction encountered while implementing and validating the Open M3 ORM schema read / diff / emit pipeline.

This note is practical rather than philosophical. It focuses on what actually slowed or complicated the work, what was fixed upstream, what was filed, and what still remains locally relevant.

## Confirmed Upstream Issues Filed During This ORM Pass

### Build / cache / rebuild ergonomics

- [#162 Common strict project edits should not require shared runtime rebuilds outside scpp update flows](https://github.com/alexstanciu-1/simplecpp/issues/162)
  - common edits still too easily push Open M3 toward `scpp build --build-runtime --build-dependencies`
  - desired direction: ordinary work should generally use plain `scpp build`, with runtime rebuilds reserved for real toolchain/runtime changes

- [#163 Stale or partially refreshed rebuild state can lead to invalid object/link cache failures](https://github.com/alexstanciu-1/simplecpp/issues/163)
  - representative failure:
    - `mold: ... model_assembler.o: unknown file type`
  - usually cleared by a fuller rebuild
  - still relevant during this pass

### Strict nullable / authoring surface

- [#164 Strict nullable-boundary runtime failures are easy to trigger through indirect access shapes](https://github.com/alexstanciu-1/simplecpp/issues/164)
- [#165 Hash lookups combined with nullable guards are still too sensitive in strict code](https://github.com/alexstanciu-1/simplecpp/issues/165)
- [#166 Nullable-boundary diagnostics should identify the failing path or source location more precisely](https://github.com/alexstanciu-1/simplecpp/issues/166)

These came directly from real Open M3 schema-builder work, especially while normalizing legacy storage metadata and helper/link-table materialization.

## Important Issues Fixed Upstream During This Broader ORM Slice

These were meaningful blockers earlier in the work and were verified fixed during the same overall ORM effort:

- [#145 override dispatch through base methods](https://github.com/alexstanciu-1/simplecpp/issues/145)
- [#146 strict `str_contains(...)`](https://github.com/alexstanciu-1/simplecpp/issues/146)
- [#147 strict `is_bool` / `is_int` / `is_float` on `mixed`](https://github.com/alexstanciu-1/simplecpp/issues/147)
- [#148 `scpp::mysqli` runtime linking gap](https://github.com/alexstanciu-1/simplecpp/issues/148)
- [#149 typed generic by-reference parser issue](https://github.com/alexstanciu-1/simplecpp/issues/149)
- [#150 strict `getenv(...)` lowering](https://github.com/alexstanciu-1/simplecpp/issues/150)
- [#151 assignment-in-condition visibility diagnostic](https://github.com/alexstanciu-1/simplecpp/issues/151)
- [#154 mysqli result exhaustion / non-terminating fetch](https://github.com/alexstanciu-1/simplecpp/issues/154)

The ORM live schema reader only became viable after the `mysqli` fixes landed.

## Practical Friction Still Seen Locally

### 1. Rebuilds still drift toward heavier commands than they should

Even after several upstream fixes, Open M3 still too often needs:

- `scpp build --build-dependencies`
- and occasionally `scpp build --build-runtime --build-dependencies`

for work that feels like ordinary schema/model iteration.

This is the core reason issue `#162` was filed.

### 2. Stale-object linker/cache behavior still shows up intermittently

This still appeared during this pass, including while rebuilding after enum-structure changes.

Representative symptom:

- `mold: fatal: ... model_assembler.o: unknown file type`

The immediate rebuild usually succeeds afterward, which reinforces that this is cache/build-state fragility rather than a deterministic source error.

This is the core reason issue `#163` was filed.

### 3. Nullable-boundary debugging remains too expensive

Real Open M3 work still hit runtime failures like:

- `scpp::nullable runtime error: implicit typed boundary conversion requires a present wrapped value`

The checks are directionally useful, but the failing path is not always obvious enough, especially in long schema-builder methods.

This is why `#164` and `#166` were split apart.

### 4. Hash + nullable patterns still require defensive rewrites

Even guarded access shapes around:

- `isset(...)`
- hash-backed collections
- nullable string/value normalization

can still require more explicit rewrites than expected.

This is why `#165` was filed separately instead of folding it into a generic nullable note.

## Additional Strict-Surface Friction Not Yet Filed Separately

### 1. `json_encode(...)` on `vector<string>` was not directly usable in the strict compare path

While trying to compare parsed enum value lists semantically, this shape failed in strict code:

- `json_encode($vector_of_strings)`

Observed compile failure:

- invalid initialization of reference of type `const scpp::mixed_t&` from expression of type `scpp::vector_t<scpp::string_t>`

Practical workaround used locally:

- compare a stable manually serialized string instead of relying on `json_encode(...)`

This is not filed separately yet because:

- the workaround is small
- it is not yet clear whether this is intended strict-surface behavior or a missing convenience bridge

### 2. New structured enum support exposed the same stale-link/cache issue again

The new `column_value_list` work itself was fine, but the first rebuild after wiring it in hit the stale object/link failure again before a second rebuild succeeded.

This is more evidence for `#163`, not necessarily a separate issue.

## Local Open M3 Authoring Rules Learned From This Pass

- prefer semantic comparison layers over raw SQL text comparison
- treat MySQL integer display width as non-semantic
- treat implicit Open M3 `varchar` and explicit legacy `varchar(255)` as equivalent in the legacy-comparison lane
- parse enum/set values into dedicated structured data rather than keeping them only as raw SQL fragments
- avoid clever nullable/hash patterns when a simpler explicit rewrite is available
- after shared `base` changes, expect to retest all affected `prism.json` tools

## Current Status At The End Of This Note

The ORM compatibility comparison against the imported legacy H2B schema is now down to a very small set, and most of the serious Simple C++ blockers from earlier in the work have either:

- already been fixed upstream, or
- been recorded as concrete ergonomics/toolchain issues with focused GitHub tickets

The main remaining live Simple C++ friction for this ORM lane is:

- rebuild/cache robustness
- nullable authoring clarity
- diagnostics precision
- a small strict-surface convenience gap around `json_encode(...)` on typed vectors
