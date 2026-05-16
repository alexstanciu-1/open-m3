# SimpleC++ / PHP++ Language Surface Report

Status: active evaluation note

Date: 2026-05-11

Current-status note:

- this report was written while Open M3 was still dealing with `0.1.36`-era build and lowering friction
- some specific build-workflow complaints in this document have improved on current `scpp 0.1.42`
- keep the high-level experience notes, but revalidate any version-specific pain claim before treating it as current

Purpose: capture the current Open M3 experience with the Simple C++ / PHP++ strict surface, focusing on what feels easy or hard, where the syntax is heavier than it needs to be, where workarounds were required, and what seems odd from a programming perspective.

Scope:

- based on actual Open M3 authoring and retest work
- focused on strict `.phs` usage
- not a general language-design review independent of repo context

## Framing

This report is written from the perspective that Simple C++ is not trying to be ordinary PHP or Python.

The intended value appears closer to:

- a compiled language surface
- explicit types for long-lived projects
- source that remains readable, but does not hide important type information

That matters for criticism.

The main question is not:

- "is this more verbose than PHP/Python?"

The main question is:

- "does this explicitness buy clarity, safety, and predictability for long-lived compiled code?"

Under that lens:

- explicit variable/property typing is usually a feature
- explicit container typing is usually a feature
- explicit error capture can be a feature

So the strongest criticism should focus on cases where the extra surface:

1. does not add real semantic clarity
2. mainly compensates for current inference/lowering limitations
3. leaks build/runtime/generator concerns into ordinary source authoring

## 1. Easy vs Hard

### Easier / Pleasant Parts

#### A. Typed schema-style class declarations

Open M3 data classes read fairly naturally in strict `.phs`.

Representative example:

- [base/schema/model_property.phs](/home/alexv/__AI/open_m3/open_m3_01/base/schema/model_property.phs:1)

Why this feels good:

- `?string`, `bool`, `int`, `hash<T>`, and `vector<T>` are compact enough for model work
- the authored surface is readable without too much runtime noise
- object structure is clear even before code generation
- explicit typing fits the long-lived compiled-project use case well

#### B. Top-level scripting for small tools

Small tool entry files are easy to write and easy to scan.

Representative example:

- [tools/hash_probe/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/hash_probe/main.phs:1)

Why this feels good:

- top-level imperative code is convenient
- the language can be used both for schema-ish code and for script-ish code
- quick repro tools are cheap to author

#### C. Familiar container iteration syntax

When container typing and lowering cooperate, `foreach` is very approachable.

Representative example:

- [tools/hash_probe/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/hash_probe/main.phs:27)

Why this feels good:

- surface syntax is familiar
- it avoids the ceremony of explicit iterator objects
- it supports quick exploratory tools well

### Harder / Friction Points

#### A. Mixed-data normalization boundaries

Work against decoded JSON or legacy maps gets cast-heavy and inference-light.

Representative example:

- [base/json_loader.phs](/home/alexv/__AI/open_m3/open_m3_01/base/json_loader.phs:25)

Why this feels hard:

- historically many boundaries required manual `(string)` / `(bool)` normalization
- value shape is often only known by convention
- this area should be re-checked continuously because recent strict updates may have reduced some of that burden

#### B. Shared-project build behavior is harder to reason about than source code itself

The main difficulty in recent Open M3 work was not authored syntax, but build/dependency behavior.

Representative evidence:

- [simplecpp_0_1_36_regression_notes_2026_05_11.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_0_1_36_regression_notes_2026_05_11.md:1)

Current note:

- the specific `0.1.36` entrypoint and dependency-artifact failures cited there no longer reproduce on the current local tool version
- the remaining concern is more about build/debug ergonomics than hard build failure

Why this feels hard:

- author intent and source correctness are not enough to predict build success
- `scpp build` vs `scpp build --build-dependencies` materially changes outcomes
- dependency artifact materialization is not obvious from the language surface

#### C. Nullability and typed-boundary behavior still leak generator/runtime concerns

Even when the source is simple, generated behavior can still depend on subtle signature choices.

Representative example:

- [base/model_assembler.phs](/home/alexv/__AI/open_m3/open_m3_01/base/model_assembler.phs:1690)

Why this feels hard:

- small source changes can alter generated nullability casts
- the author sometimes has to think about lowered C++ behavior
- this weakens confidence that source-level types are the only thing that matter

## 2. Syntax That Feels Heavier Than Needed

In this section, "heavier than needed" does not mean "more explicit than Python."

It means:

- extra syntax that may not currently buy enough clarity for its cost
- extra ceremony that may reflect toolchain limitations more than language intent
- places where explicitness is doing less useful work than it could

This section groups only strong examples, not marginal ones.

### Group A: explicit out-parameter wrappers for common operations

Representative example:

- [tools/verify_model_loader/main.phs](/home/alexv/__AI/open_m3/open_m3_01/tools/verify_model_loader/main.phs:18)

```php
$entries vector<string> = [];
if (!take($entries, $err, fs_scan($dir))) {
	echo "scan_failed:", $dir, "\n";
	$scan_failed = $scan_failed + 1;
	continue;
}
```

Why it deserves review:

- it is more explicit than many mainstream surfaces
- but that explicitness is aligned with a meticulous design where `fs_scan(...)` may fail and the error is meant to be handled rather than ignored
- the real design question is not whether explicit error capture exists, but whether this can be made slightly lighter without losing that discipline

### Group B: repetitive manual casts at mixed/legacy map boundaries

Representative example:

- [base/json_loader.phs](/home/alexv/__AI/open_m3/open_m3_01/base/json_loader.phs:97)

```php
$out->name = (string) $property_name;
if (isset($property_data["name"])) {
	$out->name = (string) $property_data["name"];
}
if (isset($property_data["type.name"])) {
	$out->type_name = (string) $property_data["type.name"];
}
```

Why it needs re-checking:

- this was a real source of friction in earlier Open M3 work
- but recent strict updates may have loosened some of these requirements
- before raising it as an issue, Open M3 should re-test which of these casts are still required and which are now just historical carry-over

### Group C: explicit typed container spellings in everyday source

Representative example:

- [base/schema/model.phs](/home/alexv/__AI/open_m3/open_m3_01/base/schema/model.phs:5)

```php
public int $property_count = 0;
public model_property $properties hash = [];
public ?storage $attached_storage = null;
```

Clarification:

- explicit container typing is not itself a problem here
- the Open M3 direction is to keep this strongly typed and make it the normal required style
- the desired improvement is source-order ergonomics and enforcement of the preferred form, not removing explicit typing
- this is best read as a style-direction note, not as a complaint against strong typing

### Group D: metadata modeled as boolean flag combinations instead of more expressive shape constructs

Representative example:

- [base/schema/model_property.phs](/home/alexv/__AI/open_m3/open_m3_01/base/schema/model_property.phs:9)

```php
public bool $type_list = false;
public bool $required = false;
public ?string $struct_ref = null;
public bool $struct_sub = false;
public bool $struct_weakref = false;
```

Clarification:

- this point is about representation shape, not about wanting dynamic typing or less explicitness
- today, one property’s semantics are spread across several flags and nullable fields
- the question is whether that is the right model, or whether a tighter representation would express the same intent with fewer cross-field combinations

## 3. Workarounds Required

### Group A: build workflow workarounds

Representative evidence:

- [specs/simple_cpp_php_strict_quick_learn.md](/home/alexv/__AI/open_m3/open_m3_01/specs/simple_cpp_php_strict_quick_learn.md:27)
- [simplecpp_0_1_36_regression_notes_2026_05_11.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_0_1_36_regression_notes_2026_05_11.md:134)

Workaround:

- use `scpp build --build-dependencies` for `base` and projects depending on `base`

Why this is a workaround:

- the default build path should normally be enough
- build success should not depend on the user knowing which dependency refresh knob to add

### Group B: source-shape adjustments to satisfy stricter validation or lowering

Representative evidence:

- [simplecpp_strict_compatibility_report_2026_05_09.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md:39)

Examples:

- removing `<?php` and `declare(strict_types=1);` from strict `.phs`
- adding explicit parameter types such as `$known_types hash<bool>`
- removing namespace from the `base` entrypoint

Why this is a workaround family:

- these changes were driven by toolchain compatibility and entrypoint behavior, not by core OM3 domain design

### Group C: generator-sensitive source rewrites

Representative evidence:

- [simplecpp_strict_compatibility_report_2026_05_09.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md:50)

Example:

- replacing top-level `const` declarations with accessor functions during the earlier generator crash window

Why this matters:

- it shows that normal source constructs can temporarily become unusable for generator reasons
- the workaround was valid operationally, but not desirable as source style

### Group D: typed-foreach stabilization patterns

Representative evidence:

- [simplecpp_strict_compatibility_report_2026_05_09.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md:245)

Example pattern:

```php
$key_s /** string */ = (string) $key;
```

Why this is now a historical-workaround bucket:

- the author already conceptually knows the foreach key is a string
- this pattern existed because typed boundaries previously needed extra stabilization
- recent strict updates suggest these patterns may no longer be needed in many cases, so Open M3 should treat them as revalidation targets rather than assumed current problems

### Group E: environment/runtime path workarounds

Representative evidence:

- [simplecpp_strict_compatibility_report_2026_05_09.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_strict_compatibility_report_2026_05_09.md:127)

Examples:

- restoring a local `simple_cpp` symlink
- diagnosing from `.prism/build`
- treating `scpp build` as more reliable than `scpp run`

Why this is a workaround family:

- these are environment/tool invocations the author should not need for ordinary project work

## 4. Things That Seem Odd From A Programming Perspective

### A. Entry-point behavior depends on source shape in ways that are not obvious from the language itself

Representative evidence:

- [base/main.phs](/home/alexv/__AI/open_m3/open_m3_01/base/main.phs:1)
- [simplecpp_0_1_36_regression_notes_2026_05_11.md](/home/alexv/__AI/open_m3/open_m3_01/specs/planning/simplecpp_0_1_36_regression_notes_2026_05_11.md:47)

Why it seems odd:

- ordinary top-level code can compile into a non-executable unit shape
- the distinction between “entry file” and “ordinary unit” is not explicit enough at author level

### B. The language surface is PHP-like, but several important operational rules are not what an experienced PHP author would expect

Examples:

- no `<?php`
- no `declare(strict_types=1);`
- current guidance against normal PHP include/require composition
- wrapper/result patterns such as `take(...)`

Why it seems odd:

- the syntax invites PHP intuition
- the semantic and operational rules frequently require unlearning PHP instincts

### C. Some source-level types still feel entangled with generator/runtime internals

Representative evidence:

- recent generated failure around `nullable<string_t>` from a source-level helper signature choice

Why it seems odd:

- the author writes `.phs`
- but certain problems only become understandable after looking at generated C++
- this makes the abstraction boundary feel leaky

### D. Property semantics are distributed across multiple fields instead of being represented as tighter language-level constructs

Representative example:

- [base/schema/model_property.phs](/home/alexv/__AI/open_m3/open_m3_01/base/schema/model_property.phs:5)

Why it seems odd:

- “what kind of property is this?” is not encoded in one strong construct
- authors must mentally combine `type_name`, `type_list`, `struct_ref`, `struct_sub`, and `struct_weakref`
- this increases cognitive load and invalid-state risk

Clarification:

- this is not a claim that the current model is wrong
- it is a prompt for later review of whether these semantics are best represented as separate fields or by a tighter structural model

### E. Build-system knowledge currently affects language confidence too much

Representative evidence:

- `scpp build` vs `scpp build --build-dependencies`

Why it seems odd:

- in a mature authoring surface, confidence in a source change should not depend so heavily on hidden dependency-materialization behavior

## Bottom Line

The Simple C++ / PHP++ strict surface is strong enough to express Open M3 cleanly in many schema and small-tool scenarios.

The main pain is not that the syntax is unfamiliar, and not that it is more explicit than scripting languages.

The main pain is that:

1. mixed-data boundaries are still too cast-heavy
2. build/dependency behavior is too visible to everyday programming
3. some source decisions still require thinking about lowering/runtime behavior

If those areas improve, the overall surface would feel lighter and more trustworthy while still preserving the explicit typed style that makes sense for long-lived compiled projects.
