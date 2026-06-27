# Descriptive Materialization - Legacy Grid Takeaways

Date: 2026-06-27

This note captures lessons from the legacy Omi Grid generator/runtime pair:

- generator: `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/common/gens`
- runtime: `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/omi-frame/common/view/Grid`

The goal is not to copy that implementation. The goal is to keep the parts that made it productive, then rebuild them with a cleaner description -> materialization -> runtime architecture.

## What Worked

1. Generator/runtime split

   The generator produced view-specific files, selectors, config, and templates. The runtime owned common behavior: modes, routing, data loading, submit handling, search, export, popup rendering, URL state, JS interactions, and security checks.

   This is the most important architectural lesson. The materializer should emit compact, deterministic artifacts. Repeated behavior should live in a shared runtime.

2. Generated unit folders

   Each view had its own generated folder/files. That made the generated output inspectable and overridable by convention.

   For the new system, generated units should live under `.generated/build/{target}/...`, while source remains under `src/`.

3. Template-based UI generation

   The old generator produced UI through templates. This helped a lot: the generator code stayed simpler, output was easier to reason about, and visual changes could often be made by editing templates instead of rewriting generator logic.

   The new system should keep templates as a first-class materialization mechanism. The materializer should decide what needs to be produced from the canonical UI IR, then expand target-specific templates. For example, a descriptive `tabs` node may become several HTML elements, ARIA attributes, event bindings, and CSS hooks for the PWA target. Later, the same `tabs` node may become native MVVM view declarations, bindings, and view-model wiring for a native target.

4. Template families

   The old generator supported template families such as `v01-classic`, `v02-modern`, and `h2b`. This made visual/runtime variants possible without changing the source model.

   The new system should keep this concept, but name it explicitly as a materialization profile or renderer profile.

5. Config overlays by selector/path

   The old `SetupExtraConfigMerge` and `ExtractExtraConfig` flow allowed config to apply at `::`, class, property path, wildcard, and selector-like scopes. This was powerful because small config overlays could shape large generated views.

   This is worth preserving, but with a documented schema and deterministic merge rules.

6. Explicit config vocabulary

   `Grid_Config_.php` separated known view-level and property-level config keys. This gave the generator a real vocabulary: labels, input type, listing behavior, dropdown behavior, hidden rules, tabs, steps, popup width, list checkboxes, and so on.

   The new system should define a first-class schema for UI nodes, property bindings, actions, layouts, capabilities, and target hints.

7. Selector validation before generation

   The old generator checked that group/layout selections existed in the model selectors before writing output. This moved failures to materialization time instead of runtime.

   The new materializer should validate source references, bindings, actions, capabilities, and target support before emitting artifacts.

8. Safe, idempotent writes

   The old generator used changed-file writes with commit/rollback behavior. This matters because generated output can be large, and noisy rewrites make review and CI unpleasant.

   The new materializer should produce a write plan, write only changed artifacts, and emit an artifact manifest.

9. Generated config consumed by runtime

   The old generated view class included config like selectors and grid settings. The runtime then used those values generically.

   The new equivalent should be a generated manifest/IR bundle consumed by `descriptivejs` and by the backend/host adapter.

## What To Improve

1. Avoid global mutable generator state

   The old generator relied heavily on static state such as placeholders, cached data, selected template, and extra selectors. The new materializer should use explicit context objects passed through the pipeline.

2. Make the intermediate representation explicit

   The old generator moved from model/config/templates directly to files. The new flow should have a canonical UI IR between parsing and writing:

   `source description -> normalized description -> canonical UI IR -> target artifact plan -> generated files`

3. Keep ORM/model/UI boundaries clean

   The old Grid system mixed model selectors, UI config, runtime behavior, URL handling, and ORM/data concerns. The new descriptive app should let UI materialization depend on model metadata when needed, but not let ORM concepts take over the UI module.

4. Prefer data schemas over executable config

   The old system loaded PHP config files. That was flexible, but hard to validate and harder for agents to modify safely.

   For v1, prefer JSON or JS-JSON source with schemas. Extension hooks can exist later, but the core descriptive surface should be data-first.

5. Separate target adaptation

   The old templates mostly produced web/PHP/QWebControl output. The new system needs PWA, native webview, and later native UI targets. Target adaptation must be its own step, not scattered through templates.

6. Improve diagnostics

   The new materializer should explain what it parsed, what it normalized, what it generated, what changed, and what target/capability decisions were made.

7. Make artifact ownership explicit

   Generated artifacts should be traceable to source nodes. A generated artifact manifest should include source paths, target, materializer version, runtime version, file hashes, and diagnostics.

## Proposed V1 Materialization Flow

The first target should be PWA because it is easiest to test in the current setup and uses the same web runtime concept as native webview targets.

```text
src/ui/main/ui.json
  -> parse source
  -> normalize aliases/defaults
  -> validate schema
  -> build canonical UI IR
  -> adapt for target: pwa
  -> select materialization profile/templates
  -> expand templates into target artifacts
  -> create artifact plan
  -> write .generated/build/pwa/...
  -> emit manifest and diagnostics
  -> run through pwa adapter
```

The same canonical UI IR should later feed:

```text
.generated/build/pwa/...
.generated/build/webview-win/...
.generated/build/webview-mac/...
.generated/build/webview-linux/...
.generated/build/webview-ios/...
.generated/build/webview-android/...
```

The important rule is that templates are target-specific, but the source description is not. A `tabs` description should not need to know whether it becomes HTML, a Simple C++ webview app folder, or a future native MVVM view.

```text
canonical UI IR: tabs
  pwa/html templates:
    div/tablist/buttons/panels/aria/css/js bindings
  native MVVM templates:
    view declaration/bindings/view-model commands/platform style hooks
```


## Template Strategy Update

The materializer should use template-centric organization rather than one fully duplicated template tree per target.

Primary template strategy note:

```text
specs/planning/descriptive_materializer_template_strategy_2026_06_27.md
```

The short version:

```text
materializers/templates/{template_name}/template.json
materializers/templates/{template_name}/files/**
materializers/templates/{template_name}/overlays/{target-selector}/**
```

Target selectors can name one target or a target family:

```text
pwa
webview-*
pwa+webview-*
webview-win+webview-linux
```

This lets the same `web_app_basic` template produce Hello World for PWA and for all webview targets, with small overlays for target-specific files.

## Proposed Generated Layout

```text
.generated/
  build/
    pwa/
      app/
        index.html
        manifest.webmanifest
        service-worker.js
      ui/
        main/
          ui.ir.json
          ui.manifest.json
          component.js
          styles.css
      runtime/
        descriptivejs/
        adapters/
          pwa.js
      diagnostics/
        materialization.json
  diagnostics/
    materialization-latest.json
```

For native webview, the output can be structurally similar:

```text
.generated/build/webview-linux/app/
.generated/build/webview-win/app/
.generated/build/webview-mac/app/
```

Those app folders are good candidates for `webview_load_app(view, folder)` in Simple C++.

## Runtime Shape

Inspired by legacy Grid, runtime behavior should be shared and adapter-driven:

```text
descriptivejs runtime
  common:
    render tree
    bind state
    dispatch actions
    subscribe to events
    capability checks
    diagnostics channel
  adapters:
    pwa
    simplecpp-webview
    browser-dev
```

The adapter should be the main target-specific surface:

```text
adapter.getCapabilities()
adapter.getEngineInfo()
adapter.connectEngine()
adapter.invoke(action, payload)
adapter.subscribe(topic, handler)
adapter.openExternal(url)
adapter.readFile?(options)
adapter.writeFile?(options)
```

## First Hello World Target

Source:

```text
src/ui/main/ui.json
```

Example:

```json
{
  "ui": "main",
  "version": 1,
  "root": {
    "type": "view",
    "layout": "stack",
    "children": [
      { "type": "text", "value": "Hello World!" },
      { "type": "button", "label": "Ping", "action": "hello.ping" }
    ]
  }
}
```

Generated PWA artifacts:

```text
.generated/build/pwa/app/index.html
.generated/build/pwa/ui/main/ui.ir.json
.generated/build/pwa/ui/main/ui.manifest.json
.generated/build/pwa/ui/main/component.js
.generated/build/pwa/runtime/adapters/pwa.js
```

Run path:

```text
description:     src/ui/main/ui.json
materialization: .generated/build/pwa/...
runtime:         descriptivejs + pwa adapter
```

## Key Design Rule

Generated files should be boring.

The description should carry intent. Templates should carry target shape. The materializer should produce deterministic artifacts. The runtime should carry behavior. The adapter should carry environment differences.
