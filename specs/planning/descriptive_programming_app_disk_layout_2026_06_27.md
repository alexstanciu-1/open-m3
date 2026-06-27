# Descriptive Programming App Disk Layout

Status: initial planning note

Purpose: define a practical on-disk shape for a Descriptive Programming app that can materialize to PWA first and later to Simple C++ native webview targets.

## One-Sentence Summary

A Descriptive Programming app should keep authored description, shared web runtime, target adapters, capability manifests, engine topology, and materialized outputs separate enough that PWA and native webview builds can share almost everything.

## Naming

Working name:

```text
descriptive-programming-app
```

This can be a generated app folder, a sample fixture, or eventually the root shape for real descriptive apps.

## Layout Principle

The descriptive app source should look familiar to users.

Authored/descriptive files live under `src/`.

Generated, materialized, cached, diagnostic, and local runtime artifacts should live under one generated root folder.

This gives a simple mental model:

```text
src/
  source of truth that users edit

.generated/
  generated or local tool/runtime state
```

Recommended generated layout:

```text
.generated/
  build/
    generated/materialized target output
  run/
    local run state
  cache/
    tool caches
  diagnostics/
    logs and diagnostic snapshots
```

The `.generated/` folder should generally be disposable or ignored by version control unless a specific artifact is promoted as a fixture.

## Top-Level Shape

Proposed root layout:

```text
descriptive-programming-app/
  app.dp.json
  app.capabilities.json
  app.engine.json
  descriptive.lock.json

  src/
    app.json
    ui/
      main/
        ui.json
    views/
    actions/
    state/
    routes/
    assets/
    materializers/
      templates/

  runtime/
    descriptivejs/
    adapters/
    components/
    themes/

  materializers/
    materialize.php
    templates/
      web_app_basic/

  engines/
    remote/
    local/
    mock/

  .generated/
    build/
      pwa/
      webview-win/
      webview-mac/
      webview-linux/
      webview-ios/
      webview-android/
    run/
      pwa/
      webview-win/
    cache/
    diagnostics/
      materialization.log
      runtime.log
      bridge.log
```

## Root Manifest

`app.dp.json` is the app entry manifest.

It should answer:

- what app is this
- which description entry should load
- which runtime version is expected
- which materializer engine should be used
- which target is being materialized
- which adapter should be selected
- which capability and engine manifests apply

Example:

```json
{
  "name": "descriptive-programming-app",
  "version": "0.0.1",
  "descriptionEntry": "src/app.json",
  "runtime": {
    "name": "descriptivejs",
    "version": "0.0.1"
  },
  "targets": ["pwa", "native-webview"],
  "defaultTarget": "pwa",
  "capabilities": "app.capabilities.json",
  "engine": "app.engine.json"
}
```

## Source Folder

`src/` is the authored descriptive source of the app.

It should be the durable source of truth for the UI/app model.

Suggested shape, with folders included only when the app or host needs them:

```text
src/
  app.json
  views/
    workbench.json
    sample-counter.json
  actions/
    runtime-actions.json
  state/
    initial-state.json
  routes/
    routes.json
  assets/
    logo.svg
```

The first slice can start with a single `src/app.json`, then split into folders once there is real pressure.

## Capability Manifest

`app.capabilities.json` describes what the selected target can do.

This file should be readable by both frontend and backend/host.

Example PWA capability manifest:

```json
{
  "target": "pwa",
  "capabilities": {
    "localPersistence": "indexeddb",
    "filesystem": "none",
    "projectAccess": "remote",
    "nativeDialogs": false,
    "notifications": "browser",
    "clipboard": "browser",
    "offline": "partial",
    "installable": true,
    "nativeWindowControls": false,
    "diagnostics": ["console", "runtime-log", "remote"]
  }
}
```

Example native webview capability manifest:

```json
{
  "target": "native-webview",
  "capabilities": {
    "localPersistence": "host",
    "filesystem": "host-mediated",
    "projectAccess": "host-mediated",
    "nativeDialogs": true,
    "notifications": "host-mediated",
    "clipboard": "browser-or-host",
    "offline": "full-local-when-engine-local",
    "installable": false,
    "nativeWindowControls": true,
    "diagnostics": ["console", "runtime-log", "host"]
  }
}
```

## Engine Manifest

`app.engine.json` describes where the application engine runs, when the app has one. Not all apps need a remote backend.

This is separate from the UI target.

Example PWA engine manifest when backend behavior is needed:

```json
{
  "mode": "remote",
  "required": true,
  "endpoint": "http://localhost:8787",
  "transport": "http-json",
  "healthCheck": "/health"
}
```

Example no-backend engine manifest:

```json
{
  "mode": "none",
  "required": false
}
```

Example native local engine manifest:

```json
{
  "mode": "local",
  "required": true,
  "transport": "simplecpp-webview-message",
  "host": "ui_window"
}
```

Example native remote engine manifest:

```json
{
  "mode": "remote",
  "required": true,
  "endpoint": "https://example.test/runtime",
  "transport": "http-json"
}
```

## Runtime Folder

`runtime/` contains common frontend runtime code.

For the first slice this can be checked in as source files.

Later it may be copied from a package or generated by a materializer.

Suggested shape:

```text
runtime/
  descriptivejs/
    boot.js
    runtime.js
    description-loader.js
    store.js
    actions.js
    diagnostics.js
    renderer.js
  adapters/
    pwa-adapter.js
    simplecpp-webview-adapter.js
    mock-adapter.js
  components/
    builtin-components.js
  themes/
    default.css
```

The common runtime should import an adapter by target, but not depend on target-specific transport details.

## Materialization Engine

For v1, the description-to-code transform should use regular PHP.

This keeps materialization productive while Simple C++ matures.

Simple C++ can still support generated native hosts, webview samples, diagnostics, and optional backend acceleration, but it should not be required for the first materializer.

The materializer should be able to emit:

- PWA folders
- native webview app folders
- Simple C++ host project files when targeting native webview
- regular-PHP remote backend scaffolding when the app needs a backend

## Materializers Folder

`materializers/` contains materialization logic and reusable templates.

The preferred shape is template-centric, not target-folder-centric:

```text
materializers/
  materialize.php
  templates/
    web_app_basic/
      template.json
      files/
        app/
          index.html.tpl
          ui/main/component.js.tpl
          runtime/descriptivejs/runtime.js.tpl
      overlays/
        pwa/
          app/manifest.webmanifest.tpl
          app/service-worker.js.tpl
        pwa+webview-*/
          app/ui/main/ui.ir.json.tpl
          app/ui/main/ui.manifest.json.tpl
        webview-*/
          app/webview-bridge.js.tpl
          host/prism.json.tpl
        webview-win+webview-linux/
          host/main.phs.tpl
        webview-mac/
          host/main.phs.tpl
        webview-ios+webview-android/
          host/main.phs.tpl
```

Apps and samples may override only the templates they need from source:

```text
samples/hello_world/
  src/
    materializers/
      templates/
        web_app_basic/
          overlays/
            pwa/
              app/ui/main/styles.css.tpl
```

The first canonical UI materialization targets are:

```text
pwa
webview-win
webview-mac
webview-linux
webview-ios
webview-android
```

See `specs/planning/descriptive_materializer_template_strategy_2026_06_27.md` for selector syntax and overlay resolution.

## Materialization CI Smoke

GitHub CI should include a light emission smoke for each frontend target:

- `pwa`
- `webview-win`
- `webview-mac`
- `webview-linux`
- `webview-ios`
- `webview-android`

At this stage, the smoke should not be extensive.

It should verify that materialization completes, emits the expected folder/project shape for each target, and matches the expected generated fixture or artifact manifest.

For native webview targets, CI should verify that the generated app folder contains an `index.html`, is shaped for `webview_load_app(...)`, and includes a real Simple C++ host project.

CI should also launch/render the PWA output and save a screenshot artifact. Deeper native launch and bridge tests can be added later per platform.

## Generated Build Folder

`.generated/build/` contains generated artifacts.

It should be disposable.

Suggested shape:

```text
.generated/build/
  pwa/
    app/
      index.html
      manifest.webmanifest
      app.description.json
      app.capabilities.json
      app.engine.json
      runtime/
      assets/
  webview-win/
    host/
      main.phs
      prism.json
    app/
      index.html
      app.description.json
      app.capabilities.json
      app.engine.json
      runtime/
      assets/
```

For native webview, the folder under `.generated/build/webview-{target}/app/` should be loadable through:

```php
webview_load_app($view, "app")
```

That means the generated native project should run from a working directory where `app/index.html` exists.

## Generated Run Folder

`.generated/run/` contains runtime state and logs for local runs.

It should be disposable or ignored by version control.

Suggested shape:

```text
.generated/run/
  pwa/
    state.json
    bridge.log
    diagnostics.log
  native-webview/
    state.json
    bridge.log
    diagnostics.log
```

For browser PWA tests, state may live in IndexedDB/localStorage, but exporting a run snapshot here would be useful for debugging.

## App Codebase vs Instance Root

A remote-backend deployment needs to distinguish the shared application codebase from per-instance runtime roots.

For installed native apps, this is less visible because the app installs and runs in an OS-managed location.

For server-hosted or remote-engine apps, the same codebase may serve many independent instances.

Example instance roots:

```text
/home/tfc_eximtur_ro/
/home/tfc_velmardrams_ro/
/home/tfc_albaturism_ro/
```

Each instance may have some instance-specific folders, for example. These are illustrative; some concerns may not exist as folders at all:

```text
config.json
logs/
public_html/
public_html/uploads/
sessions/
temp/
```

But they may all point at or resolve against one shared codebase/release on disk.

That means the disk model needs at least two roots:

```text
codebase root
  shared immutable or mostly immutable app/runtime/materializer code

instance root
  per-customer/per-site/per-tenant config, generated public files, optional mutable storage bindings, and database bindings
```

## Shared Codebase Root

The shared codebase root contains versioned app code and materialization logic.

Suggested shape:

```text
descriptive-programming-app-codebase/
  app.dp.json
  descriptive.lock.json
  src/
  runtime/
  materializers/
  engines/
  releases/
```

The codebase root should be safe to share across many instances.

It should avoid storing tenant-specific data, uploaded files, sessions, mutable logs, or secrets.

## Instance Root

The instance root contains instance-specific configuration and storage bindings. Mutable concerns such as sessions, logs, uploads, temp, or cache may be absent, filesystem-backed, database-backed, or delegated to another service.

Suggested shape, with folders included only when the app or host needs them:

```text
descriptive-programming-instance/
  instance.json
  config.json
  capabilities.instance.json
  engine.instance.json

  public_html/
    index.html
    app.description.json
    app.capabilities.json
    app.engine.json
    runtime/
    assets/
    uploads/

  data/
  logs/
  sessions/
  temp/
  cache/
```

For existing server layouts, the instance root may map directly to the deployment home directory, and the concrete folders are deployment-specific:

```text
/home/tfc_eximtur_ro/
  config.json
  logs/
  public_html/
  public_html/uploads/
  sessions/
  temp/
```

## Instance Manifest

`instance.json` should identify the instance and the codebase/release it uses.

Example:

```json
{
  "instanceId": "tfc_eximtur_ro",
  "app": "descriptive-programming-app",
  "codebase": "/opt/openm3/apps/descriptive-programming-app",
  "release": "2026.06.27-001",
  "target": "pwa",
  "config": "config.json",
  "capabilities": "capabilities.instance.json",
  "engine": "engine.instance.json",
  "publicRoot": "public_html",
  "storage": {
    "uploads": { "kind": "filesystem", "path": "public_html/uploads" },
    "logs": { "kind": "database" },
    "sessions": { "kind": "database" },
    "temp": { "kind": "filesystem", "path": "temp" }
  }
}
```

The materialized frontend should be able to know its instance id and engine endpoint, but it should not need to know the full server filesystem layout.

## Instance Overlay Rules

A practical lookup order is:

1. instance override
2. materialized target output
3. shared codebase release
4. runtime defaults

Examples:

- instance `config.json` overrides default app config
- instance `capabilities.instance.json` narrows or extends target capabilities
- instance `engine.instance.json` selects the actual remote backend endpoint/database binding
- uploaded files, when present, may live under the instance root or in external storage
- logs, sessions, temp, and cache may be absent, filesystem-backed, database-backed, or service-backed

The materializer should never write tenant data back into the shared codebase.

## Remote Engine Implication

For PWA and other remote-backend apps, the running engine should receive enough context to resolve both:

- app codebase/release identity
- instance root identity

This allows one backend codebase to serve multiple app instances while keeping configs, databases, uploads, sessions, and logs isolated.

The bridge should include instance context with commands either explicitly or through the connected engine session.

Candidate connection context:

```json
{
  "target": "pwa",
  "engineMode": "remote",
  "instanceId": "tfc_eximtur_ro",
  "appRelease": "2026.06.27-001"
}
```

## PWA Materialized Output

Minimum runnable PWA output:

```text
.generated/build/pwa/
  index.html
  app.description.json
  app.capabilities.json
  app.engine.json
  runtime/
    descriptivejs/
    adapters/pwa-adapter.js
  assets/
```

Later additions:

- `manifest.webmanifest`
- `service-worker.js`
- icons
- offline cache manifest

The PWA adapter must assume a remote engine exists.

The first development version can point to a local mock/dev server.

## Native WebView Materialized Output

Minimum runnable native output:

```text
.generated/build/webview-win/
  prism.json
  main.phs
  app/
    index.html
    app.description.json
    app.capabilities.json
    app.engine.json
    runtime/
      descriptivejs/
      adapters/simplecpp-webview-adapter.js
    assets/
```

`main.phs` should:

1. create `ui_app`
2. create `ui_window`
3. create `webview`
4. call `webview_load_app($view, "app")`
5. show the window
6. poll events
7. route `webview_message` to the local or remote engine
8. reply with `webview_reply_ok(...)` or `webview_reply_error(...)`

## First Fixture

The first fixture can be intentionally small:

```text
descriptive-programming-app/
  app.dp.json
  app.capabilities.json
  app.engine.json
  src/app.json
  runtime/descriptivejs/*
  runtime/adapters/pwa-adapter.js
  runtime/adapters/simplecpp-webview-adapter.js
  materializers/materialize.php
  materializers/templates/web_app_basic/*
```

The first materialization target should be:

```text
.generated/build/pwa/
```

The next materialization targets should be:

```text
.generated/build/webview-win/
.generated/build/webview-mac/
.generated/build/webview-linux/
.generated/build/webview-ios/
.generated/build/webview-android/
```

## Open Questions

- Should `app.capabilities.json` and `app.engine.json` be root files, target-specific files, or both?
- Should materialized files copy runtime code, symlink it, or bundle it?
- How should the regular-PHP v1 materializer be packaged and invoked?
- Should generated native webview projects be standalone Simple C++ projects or subfolders of the descriptive app?
- Should `.generated/run/` be part of the app root or live under a global workspace cache?
