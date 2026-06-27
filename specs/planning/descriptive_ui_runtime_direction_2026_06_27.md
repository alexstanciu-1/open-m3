# Descriptive UI Runtime Direction

Status: initial planning note

Purpose: define the first practical path for Descriptive Programming UI support using a common web runtime, a PWA-first materialization target, and later native Simple C++ webview adapters.

## One-Sentence Summary

Descriptive UI should move through a standard `description -> materialization -> run` flow, with most behavior shared across web-based targets and only the bridge/platform adapter changing.

## Background

Simple C++ `0.1.73` added developer-preview support for:

- native `ui` windows across Windows, Linux, macOS, iOS, and Android backend boundaries
- `webview` URL/HTML/app-folder loading, JavaScript evaluation, browser-like events, and JavaScript-to-native message replies
- strict `ui_*` and `webview_*` helper surfaces
- a golden `strict_webview_bridge` sample

That gives Open M3 a credible native host for a webview-based supporting app.

The released preview API includes:

```text
webview_load_app(webview $view, string $folder): result<bool>
```

The golden bridge sample loads its UI with:

```php
webview_load_app($view, "app")
```

That means native webview materialization can target an app folder rather than a single generated HTML string.

The first validation target should still be PWA because it is the easiest to run and inspect in the current setup.

## Standard Flow

The expected flow is:

1. description
2. materialization
3. run

The materialization target should be explicit:

- `pwa`
- `webview-win`
- `webview-mac`
- `webview-linux`
- `webview-ios`
- `webview-android`

For the first implementation slice:

- description is a declarative UI/app model
- materialization produces a runnable PWA folder
- run opens that PWA in a browser

Later native targets should reuse the same description model and web runtime, then swap only the adapter and host packaging.

## Core Principle

All web-based targets should share as much as possible.

Common:

- description loading
- validation
- UI rendering
- state store
- action dispatch
- binding evaluation
- routing/navigation
- diagnostics
- event log
- asset resolution rules
- runtime inspection views

Target-specific:

- bridge transport
- platform lifecycle
- persistence backend
- native capability access
- filesystem/project access
- packaging/install hooks
- platform diagnostics

The common runtime should not know whether it is running in:

- browser PWA
- Simple C++ native webview
- WebView2
- WebKitGTK
- WKWebView
- Android WebView

It should only know that an adapter satisfies the runtime bridge contract.

## Proposed Layers

The practical layers are:

```text
description
  declarative UI, state, action, route, and binding model

materialization
  target-aware builder that emits runnable artifacts

runtime
  common descriptive JavaScript runtime plus target adapter
```

For a PWA:

```text
description
  -> pwa materializer
      -> index.html
      -> app description artifact
      -> descriptivejs runtime
      -> pwa adapter
      -> manifest/service worker when needed
  -> browser run
```

For a native webview target:

```text
description
  -> native materializer
      -> Simple C++ ui_window host
      -> webview app folder loaded with webview_load_app(...)
      -> same descriptivejs runtime
      -> native webview adapter
      -> platform packaging when needed
  -> native run
```

The native webview app folder should be structurally close to the PWA output folder.

The first expected difference is the adapter:

- PWA folder uses the PWA/browser adapter
- native folder uses the Simple C++ webview adapter

The rest of the folder should remain common where possible:

- `index.html`
- runtime JavaScript
- materialized description artifact
- styles/assets
- optional manifest where useful

## DescriptiveJS Role

`descriptivejs` should be treated as the common web runtime and renderer.

It should not own platform details directly.

Its responsibilities should include:

- loading a materialized description
- building an in-memory runtime graph
- rendering DOM from the description
- maintaining runtime state
- dispatching actions through the bridge
- applying state updates
- showing diagnostics and event history

It should call an adapter for external effects.

## Capability Model

Targets should expose a shared capability description that is visible to both the frontend and the backend or host.

This should not be guessed from the target name alone.

A PWA, native desktop webview, native mobile webview, and future hosted app may all support different combinations of:

- local persistence
- remote backend calls
- filesystem access
- project-folder access
- native dialogs
- notifications
- clipboard
- camera or media access
- offline operation
- background work
- installability
- native window controls
- diagnostics and logging sinks

The runtime should be able to read a target capability manifest during boot.

Candidate shape:

```js
{
  target: "pwa",
  engine: {
    mode: "remote",
    required: true,
    note: "for apps that need backend behavior"
  },
  capabilities: {
    localPersistence: "indexeddb",
    filesystem: "none",
    projectAccess: "remote",
    nativeDialogs: false,
    notifications: "browser",
    offline: "partial",
    diagnostics: ["console", "runtime-log"]
  }
}
```

The frontend should use this for UI affordances.

The backend or host should use the same capability description to validate commands and produce clear diagnostics when a requested operation is unavailable.

## Backend Engine Topology

The runtime should also model where the application engine lives.

Some targets may have a local/native engine:

- Simple C++ desktop webview host
- Simple C++ mobile webview host
- future packaged native apps

Some targets may have a remote backend engine:

- PWA
- hosted web app
- future collaborative/cloud runtime

A PWA should be treated as requiring a remote backend engine when the app needs backend behavior, because it cannot start a local Simple C++ engine by itself. A purely static or client-only PWA may not need an engine.

This creates two independent questions:

- what target is rendering the UI
- where does the engine execute

Examples:

```text
pwa + remote engine
native-webview + local engine
native-webview + remote engine
native-webview + hybrid local/remote engine
```

The bridge adapter should transport commands to the selected engine location, but the common runtime should keep the command model stable.

This keeps the first PWA backend test honest: it is not just a browser adapter; it is a browser adapter plus a remote-engine assumption when the app needs backend behavior, even if the first prototype uses a mock/local development server.

## V1 Implementation Bias

Until Simple C++ is more mature, the v1 materializer should use regular PHP.

The regular-PHP materialization path owns the description-to-code transform so UI/runtime work is not slowed down by compiler/runtime maturity.

For v1, remote backend engines should also be regular-PHP first, with Simple C++ support optional where it is useful.

Not all apps need a backend. Backend and engine configuration should remain optional except for targets/apps that require server behavior.

Simple C++ remains important for native webview hosting, future local engines, stricter/runtime-backed execution, and later acceleration.

## Instance Context

Remote-backend deployments should treat instance identity as part of the runtime connection, not as an incidental server path.

A single shared app codebase/release may run many isolated instances with different config, databases, and optional storage concerns such as uploads, sessions, logs, temp, or cache. Those concerns may be absent, filesystem-backed, database-backed, or service-backed.

The exact storage bindings are deployment-specific.

Example instance roots:

```text
/home/tfc_eximtur_ro/
/home/tfc_velmardrams_ro/
/home/tfc_albaturism_ro/
```

The common runtime should be able to know the public instance identity, selected app release, target, and engine mode.

The backend engine should resolve that instance identity to private server-side paths and bindings.

Candidate connection context:

```js
{
  target: "pwa",
  engineMode: "remote",
  instanceId: "tfc_eximtur_ro",
  appRelease: "2026.06.27-001"
}
```

For bridge commands, instance context may be sent once during `connectEngine()` when an engine exists and then associated with the engine session.

The frontend should not need direct knowledge of private paths such as logs, sessions, temp, or database credentials.

## Adapter Contract

The first adapter contract should stay small and stable. Engine functions may return "none" or no-op results for apps that do not use a backend.

Candidate shape:

```js
{
  target: "pwa",

  getCapabilities() {},
  getEngineInfo() {},
  connectEngine() {},

  invoke(command, payload) {},
  subscribe(eventName, handler) {},

  loadDescription(source) {},
  persistState(key, value) {},
  restoreState(key) {},

  resolveAsset(path) {},
  reportDiagnostic(diagnostic) {}
}
```

The runtime should treat `invoke` as the standard bridge entry point.

Examples:

```js
bridge.invoke("runtime.action", { id, payload });
bridge.invoke("materialize", { description });
bridge.invoke("project.load", { path });
```

Runtime-originated events should also use the common contract:

```js
bridge.subscribe("runtime.state", handler);
bridge.subscribe("diagnostic", handler);
bridge.subscribe("materialized", handler);
```

The PWA adapter can implement these with local JavaScript, browser storage, fetch, and later service workers.

The native webview adapter can implement the same contract with Simple C++ `webview_*` message replies.

## First UI Goal

The first supporting UI should help the author see what is happening.

It should be a runtime viewer/workbench, not a complete app builder yet.

Minimum panes:

- description source/tree
- rendered UI
- runtime state
- bridge/event log
- diagnostics

This gives the first loop practical value:

- edit or load a description
- materialize it for PWA
- run it
- inspect rendered output
- inspect state and events
- confirm the adapter boundary

## Cross-Target CI Emission Smoke

Even though the first local validation target is PWA, the materialization path should be checked in GitHub CI for all intended frontend targets.

CI should lightly verify that the regular-PHP materializer can emit frontend/UI artifacts for:

- `pwa`
- `webview-win`
- `webview-mac`
- `webview-linux`
- `webview-ios`
- `webview-android`

This should not be extensive at this stage. The first CI level does not need to prove full app-store packaging, deep platform behavior, or complete runtime behavior for every target.

The initial smoke gate should prove:

1. the target can be selected
2. materialization completes
3. the expected output folder/project shape exists
4. required frontend assets are present
5. native webview targets include an app folder suitable for `webview_load_app(...)`
6. target-specific manifests/configs are generated
7. diagnostics are produced on failure

Later CI levels can add deeper build, launch, screenshot, and bridge-message checks per platform as Simple C++ UI/WebView support matures.


The next concrete CI goal is the Hello World sample across all first UI targets:

```text
samples/hello_world
  -> pwa
  -> webview-win
  -> webview-mac
  -> webview-linux
  -> webview-ios
  -> webview-android
```

The first CI pass should regenerate the sample outputs, compare them with the expected fixture or artifact manifest, and capture a PWA/browser screenshot. It should not require full native launch, app-store packaging, or deep bridge behavior yet.

## First Validation Slice

The first test should prove:

1. a small UI description can be loaded
2. the PWA materializer emits a runnable folder
3. `descriptivejs` reads target capabilities and optional engine topology
4. `descriptivejs` renders the described UI
5. user interaction dispatches an action through the adapter
6. the action updates runtime state
7. the viewer shows the description, state, capabilities, engine info, event log, and diagnostics

The first sample can be intentionally small:

- one window/app root
- one view
- a few controls
- one mutable state value
- one action
- one diagnostic/event stream
- one declared capability manifest
- one mock or development remote engine for PWA tests that need backend behavior

## Non-Goals For The First Slice

The first slice should not try to solve:

- native app packaging
- mobile packaging
- menu bars
- system trays
- custom webview schemes
- download/file chooser callbacks
- rich JavaScript return-value marshalling
- full offline PWA behavior
- complex routing
- complex component libraries

Those belong after the shared runtime and bridge contract are validated.

## Open Questions

- Should the first description artifact be JSON, JavaScript module, or Open M3 metadata lowered to JSON?
- Should materialization be performed by Open M3 code first, by a small JS prototype first, or by a Simple C++ helper app?
- How much of the runtime viewer should itself be described by the same description model?
- Should PWA persistence start with `localStorage`, `IndexedDB`, or an adapter-neutral storage abstraction?
- What is the minimum canonical component set for the first sample?

## Near-Term Plan

1. define a minimal description schema for the first UI sample
2. define the `descriptivejs` runtime module boundary
3. define the PWA adapter
4. build a tiny materialized PWA fixture
5. add the runtime viewer panes
6. run the sample in browser
7. map the same adapter contract to Simple C++ webview messages

## DescriptiveJS Baseline Check

Checked on 2026-06-27:

- local: `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code/descriptivejs`
- GitHub: `https://github.com/alexstanciu-1/descriptivejs`
- remote `master`: `fc6fb49f6dda83d3dc18f71068f0b4a229ef9691`

A temporary shallow clone of the GitHub repository matched the local legacy folder at file level. The local folder is not a standalone checkout; it is nested under the broader `open_m3_primary` repository history. For planning purposes, the local folder and GitHub repo should be treated as the same baseline.

The current DescriptiveJS baseline is valuable, but early:

- `package.json` only declares ESM mode.
- `README.md` is minimal.
- The real design knowledge is in `src/core/*`, `apps/docs`, `apps/samples/pwa`, `@todo.txt`, and the directive examples.

Useful existing ideas:

- `DNode` runtime graph over DOM nodes.
- `DProxy` change tracking and transaction-style commits.
- template/directive vocabulary such as `q-data`, `q-if`, `q-each`, `q-call`, `q-func`, `q-text`, `q-tpl`, and `q-ctrl`.
- dynamic module/template loading.
- URL controller concept.
- PWA sample with manifest and service worker.
- explicit TODOs around modules, caching, resource versioning, data traversal, two-way binds, server-side rendering, virtual DOM/compile, and native app direction.

Main caution:

The existing runtime is powerful but broad. For the new descriptive app, we should not vendor it wholesale as the v1 foundation unless we first trim and stabilize its boot contract. The better first move is a small runtime shell that reuses the successful ideas and can absorb old DescriptiveJS pieces deliberately.

## Runtime Strategy

Use the name and direction of DescriptiveJS, but start with a clean v1 runtime shell.

This means:

- Keep the concepts: descriptive templates, runtime graph, state/binds, actions, adapters, dynamic resources.
- Avoid inheriting all current global state, test code, dev-only boot behavior, and broad directive surface at once.
- Build the first runtime around materialized artifacts, not arbitrary page scanning.
- Keep the old DescriptiveJS code as prior art and a source of proven mechanisms.

The runtime should be able to run in three modes:

```text
browser-dev
  local browser, no install assumptions, useful diagnostics

pwa
  browser runtime, optional service worker, remote engine when backend behavior is needed

simplecpp-webview
  same web runtime, Simple C++ bridge adapter, app folder loaded by webview_load_app(...)
```

## Hello World Runtime Contract

The first Hello World UI does not need the full old DescriptiveJS directive engine. It needs only:

1. boot
2. load generated UI manifest or IR
3. render the root node
4. wire actions to an adapter
5. report diagnostics

Candidate boot shape:

```js
import { createRuntime } from './runtime/descriptivejs/runtime.js';
import { createPwaAdapter } from './runtime/adapters/pwa.js';
import ui from './ui/main/ui.ir.json' with { type: 'json' };

const runtime = createRuntime({
  adapter: createPwaAdapter(),
  diagnostics: true
});

runtime.mount(document.getElementById('app'), ui);
```

For broader browser compatibility, the materializer can avoid JSON module imports and emit:

```js
import { createRuntime } from './runtime/descriptivejs/runtime.js';
import { createPwaAdapter } from './runtime/adapters/pwa.js';

const runtime = createRuntime({ adapter: createPwaAdapter() });
const ui = await fetch('./ui/main/ui.ir.json').then((response) => response.json());
runtime.mount(document.getElementById('app'), ui);
```

Minimum runtime API:

```js
runtime.mount(domNode, uiIr)
runtime.unmount()
runtime.dispatch(actionName, payload)
runtime.getState()
runtime.setState(patch)
runtime.getDiagnostics()
```

Minimum adapter API for Hello World:

```js
adapter.kind
adapter.getCapabilities()
adapter.invoke(actionName, payload)
adapter.log(level, message, data)
```

For the first button action, `hello.ping`, the PWA adapter can return a local mock response if no remote engine is configured:

```js
{
  ok: true,
  action: 'hello.ping',
  message: 'pong'
}
```

Later, the same `adapter.invoke(...)` call can cross the browser-to-remote-engine bridge or the Simple C++ webview bridge.

## Rendering Strategy

For v1 Hello World, rendering can be direct and tiny:

```text
view   -> div
text   -> span or p
button -> button + click dispatch
```

The important design point is that this direct renderer is still fed by the materialized UI IR. It is not a separate hand-written app.

As soon as we add richer elements such as `tabs`, the materializer should use templates:

```text
source description: tabs
canonical UI IR:    tabs node with items/panels/bindings
pwa materializer:   expands HTML/CSS/JS templates
runtime:            binds active tab state and actions
```

For future native MVVM targets, the same canonical node should flow through native templates:

```text
source description: tabs
canonical UI IR:    tabs node with items/panels/bindings
native materializer: expands native view declarations + view-model bindings
runtime/host:        binds state/actions through native MVVM
```

## Recommendation

For the first implementation slice:

1. Create a new small `descriptivejs` runtime under this repo.
2. Make it ESM-first and generated-artifact-first.
3. Implement only `view`, `text`, `button`, `action dispatch`, and diagnostics.
4. Keep a compatibility note mapping old DescriptiveJS concepts to new runtime concepts.
5. Pull old DescriptiveJS mechanisms in only when a feature needs them.

This lets Hello World stay simple while keeping the direction compatible with a richer DescriptiveJS future.



## CI-Only Native Compile Note

Simple C++ webview host compilation is a GitHub CI-only check for now. Local development should stop at materialization, shape validation, JSON validation, and PWA/browser rendering unless the developer explicitly has the native UI/WebView dependencies installed.


## iOS And Android CI Notes From Simple C++

Simple C++ already contains mobile WebView CI guidance and smoke coverage. Mobile targets should not be treated as a plain `scpp build` inside `host/`.

Source references in Simple C++:

```text
.github/workflows/ci.yml
docs/ui_webview_preview.md
specs/planning/webview_cross_platform_backlog_2026_06_26.md
tests/native/ios_webview_smoke/Info.plist
tests/native/android_webview_smoke/AndroidManifest.xml
tests/native/android_webview_smoke/simplecpp_webview_smoke.cpp
tests/native/android_webview_smoke/src/dev/simplecpp/smoke/ScppWebViewSmokeActivity.java
```

iOS pattern:

```text
macos-latest runner
  -> create .app bundle
  -> copy Info.plist
  -> compile Objective-C++ with iphonesimulator SDK
  -> enable SCPP_UI_BACKEND_UIKIT and SCPP_WEBVIEW_BACKEND_UIKIT_WKWEBVIEW
  -> codesign ad-hoc
  -> simctl boot/install/launch
  -> simctl screenshot
```

Android pattern:

```text
ubuntu-latest runner
  -> compile native WebView smoke library with Android NDK
  -> compile Activity Java source against android.jar
  -> d8 classes.dex
  -> aapt2 package resources + manifest
  -> include libc++_shared.so and native library
  -> zipalign/apksigner debug APK
  -> emulator launch + screenshot
```

Open M3 implication:

- `webview-win`, `webview-mac`, and `webview-linux` can use generated Simple C++ host projects and `scpp build` in CI.
- `webview-ios` needs an iOS app-bundle materialization template, not only `host/main.phs`.
- `webview-android` needs an Android Activity/APK materialization template, not only `host/main.phs`.
- Until those mobile templates exist, CI should validate mobile emission shape but should not run the desktop `scpp build` host job for mobile targets.
