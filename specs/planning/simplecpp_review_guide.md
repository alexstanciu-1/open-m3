# SimpleC++ Review Guide

Status: active review guide

Date: 2026-05-20

Purpose: provide a reusable Open M3 review rubric for evaluating SimpleC++ as both:

- a language surface
- a helper/library ecosystem

This guide is for future read-only reviews of current SimpleC++ code in Open M3 `base/`, `modules/`, `tools/`, and related strict-mode `.phs` projects.

It is intentionally opinionated.

The goal is not to reward the shortest code.

The goal is to identify where SimpleC++ helps authors write code that is:

- safe
- readable later
- explicit where explicitness matters
- hard to misuse
- predictable at compile time and runtime

## Core Position

SimpleC++ should be understood as a simple language for high-quality code.

That means:

- explicit types are usually a feature, not noise
- ownership and state transitions should be visible
- side-effecting operations should not encourage blind continuation
- helper APIs should make the safe path feel natural
- brevity is only good when it does not reduce clarity or safety

When reviewing, do not treat "more characters" as a problem by itself.

Instead ask:

1. does the extra surface buy real clarity?
2. does it prevent mistakes?
3. does it make later reading easier?
4. does it expose failure and ownership clearly?
5. or is it only compensating for a toolchain or helper limitation?

## Good Reference Examples

These are examples of the design direction this review should respect.

### `take()`

`take()` is a strong example of deliberate explicitness.

It makes success/failure handling visible at the call site and discourages ignoring important outcomes.

Representative pattern:

```php
$entries vector<string> = [];
if (!take($entries, $err, fs_scan($dir))) {
	echo "scan_failed:", $dir, "\n";
	continue;
}
```

Why this is good:

- failure is not hidden
- the author must make a decision
- data and error flow are visible
- later readers can see that the operation may fail

### Explicit types

Explicit types are a quality feature when they improve future readability and make intent local.

This is especially valuable in:

- long-lived model/schema code
- helper return values
- container-heavy logic
- ownership-sensitive code
- mixed-boundary normalization

The review should not push the language toward weaker typing just to save a few tokens.

### Checked side effects

Filesystem, process, DB, network, and similar helpers should encourage explicit success/failure handling.

Examples like `fs_scan` and `mkdir` should be judged by this question:

- does the API make it natural to check whether the operation actually succeeded before continuing?

The review should favor designs where unsafe continuation is difficult to do accidentally.

## Review Scope

During a review, separate findings into these groups.

### 1. Language Surface

Focus on:

- type syntax
- nullability behavior
- ownership/move semantics
- control-flow clarity
- error/result handling
- module/import ergonomics
- collection syntax
- diagnostics
- compile-time predictability

Questions:

1. where does the language make good code easier to write?
2. where does it force ceremony that adds little clarity?
3. where do source authors have to think about lowering/runtime internals?
4. where does the language fail to encode important safety expectations?

### 2. Helpers / Standard-Library Direction

Focus on:

- filesystem helpers
- string helpers
- collection helpers
- JSON/mixed-data helpers
- process helpers
- DB helpers
- validation/normalization helpers

Questions:

1. which operations are repetitive because helpers are missing?
2. which helpers allow important return values to be ignored too easily?
3. which helpers push too much boilerplate onto ordinary safe code?
4. where would a focused helper reduce repeated bug-prone patterns?

### 3. Authoring Ergonomics

Focus on places where code is heavier than needed for reasons that do not improve correctness.

Good targets:

- repetitive mixed-boundary casts
- repetitive null guards
- repetitive normalization blocks
- repetitive error propagation patterns
- awkward container traversal patterns

Important: do not confuse "explicit" with "bad."

Only call something too heavy when the extra surface does not buy enough readability or safety.

### 4. Safety and Misuse Resistance

Focus on whether the language or helpers make the safe path the easy path.

Questions:

1. can important failures be ignored by accident?
2. can null-sensitive code look correct while behaving unsafely?
3. can APIs be called in the wrong order without obvious friction?
4. are there helpers whose names sound safe but whose behavior is easy to misuse?
5. are side effects visible enough at the call site?

### 5. Diagnostics and Tooling Experience

Focus on the user experience of finding the real problem.

Questions:

1. do errors point near the source of the issue?
2. does the toolchain explain rebuild/runtime/dependency behavior clearly?
3. does the language surface leak generator or C++ internals too often?
4. are common strict-mode mistakes diagnosed in author terms or toolchain terms?

## Review Principles

Use these principles when deciding whether something is a worthwhile improvement request.

### Principle 1: Prefer explicitness that carries meaning

Keep explicit syntax when it communicates:

- ownership
- failure possibility
- nullability
- container element type
- mutation intent
- boundary normalization

Push back only when the explicitness is mostly mechanical and adds little signal.

### Principle 2: Side effects should demand attention

Operations that touch the outside world should not read like pure/local transformations.

This especially applies to:

- `fs_scan`
- `mkdir`
- file writes
- deletes
- moves/renames
- DB schema updates
- process execution

Good API design should make the caller confront:

- success/failure
- produced data
- error details
- whether it is safe to continue

### Principle 3: Safer code should not require cleverness

If the safest way to use a feature is subtle, verbose in the wrong way, or easy to forget, that is a review finding.

SimpleC++ should reward straightforward careful code, not tricky author knowledge.

### Principle 4: Real-code friction matters more than abstract elegance

A review finding should be grounded in actual repository patterns.

Prefer:

- "this pattern appears in these files and invites mistakes"

over:

- "in theory the language could be more elegant"

### Principle 5: Toolchain leakage is a language-experience problem

If ordinary source code becomes awkward because authors must think about:

- lowering details
- generated C++
- dependency cache state
- runtime artifact state
- hidden inference boundaries

that is a real review issue even if the syntax itself looks acceptable.

## What To Praise

A good SimpleC++ review should also record strengths.

Look for:

- typed model/schema declarations that read clearly
- explicit ownership/failure patterns like `take()`
- helpers that make unsafe continuation difficult
- code that stays understandable under maintenance
- clear container and nullability annotations
- small tools/repros that are easy to author and scan

The goal is not only to find pain points.

The goal is to reinforce what the language is already doing well so future changes preserve it.

## What To Flag

These patterns are especially worth flagging in reviews.

### A. Boilerplate that only exists because of current limitations

Examples:

- repeated casts that add no real information
- explicit `if` rewrites of natural expressions due to lowering failures
- duplicated guard logic caused by missing helpers

### B. APIs that allow silent failure or blind continuation

Examples:

- side-effecting helpers whose result is easy to ignore
- helpers that produce partially valid state without making that obvious
- flows where failure data exists but is cumbersome to access

### C. Nullability or control-flow surfaces that look safe but are fragile

Examples:

- compact expressions with surprising runtime behavior
- natural short-circuit patterns that must be manually expanded
- ternary or boundary patterns that fail in non-obvious ways

### D. Mixed-boundary code that is noisier than the semantics require

Examples:

- repetitive JSON normalization
- repeated shape extraction from legacy maps
- repeated scalar conversion scaffolding

### E. Diagnostics that misdirect the author

Examples:

- parser or generator errors that hide a simple author mistake
- build-state failures that masquerade as source failures
- runtime messages that do not identify the source shape clearly

## Suggested Finding Format

For future reviews, write findings in a consistent shape:

1. title
2. category
3. severity or importance
4. concrete repository examples
5. why this matters for SimpleC++'s quality goals
6. suggested direction
7. whether this is:
   - likely a language improvement
   - likely a helper/library improvement
   - likely a tooling/diagnostics improvement
   - or only a repo-side pattern to clean up

Example categories:

- language
- helpers
- safety
- readability
- diagnostics
- mixed-boundary ergonomics
- nullability
- build/tooling

## Non-Goals For Reviews

Do not use this review style to argue for:

- making the language dynamically loose
- hiding failure for convenience
- replacing explicit types with vague inference by default
- shortening code at the expense of later readability
- pushing author responsibility into undocumented helper magic

## Practical Review Workflow

When doing a full review:

1. read the relevant specs first
2. inspect current `base/`, `modules/`, and `tools/` code
3. sample both core library code and focused repro tools
4. note repeated patterns, not just one-off oddities
5. separate language issues from helper issues
6. distinguish current live issues from historical notes already fixed upstream
7. tie every important proposal back to actual code

## Final Standard

A strong SimpleC++ improvement proposal should usually satisfy at least one of these:

1. it makes ownership or failure more explicit
2. it preserves explicitness while removing low-signal boilerplate
3. it makes side-effecting code harder to misuse
4. it improves readability of long-lived strict code
5. it reduces the need to understand toolchain internals during ordinary authoring
6. it improves diagnostics so authors can find the real issue faster

If a proposal only makes code shorter, but not safer or clearer, it should normally be rejected.
