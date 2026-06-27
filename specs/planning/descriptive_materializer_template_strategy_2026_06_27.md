# Descriptive Materializer Template Strategy

Date: 2026-06-27

Purpose: define how materializer templates should be organized so the same descriptive UI can emit PWA and native webview Hello World targets without duplicating entire template trees.

## Direction

Templates should be reusable materialization products.

Targets should be compatibility metadata and overlay selectors, not necessarily top-level duplicated template folders.

This keeps the source description stable while allowing one template family to emit multiple targets:

```text
src/ui/main/ui.json
  -> materializers/templates/web_app_basic
  -> .generated/build/pwa/app
  -> .generated/build/webview-win/app + host
  -> .generated/build/webview-mac/app + host
  -> .generated/build/webview-linux/app + host
  -> .generated/build/webview-ios/app + host
  -> .generated/build/webview-android/app + host
```

## Canonical First Targets

Use explicit UI materialization target names:

```text
pwa
webview-win
webview-mac
webview-linux
webview-ios
webview-android
```

These names describe the generated frontend/host shape. CI runner names and platform package names may use aliases such as `windows`, `macos`, `linux`, `ios`, and `android`, but the materializer target should stay explicit.

## Template Folder Shape

Recommended shared template layout:

```text
materializers/
  templates/
    web_app_basic/
      template.json
      files/
        app/
          index.html.tpl
          ui/main/component.js.tpl
          ui/main/styles.css.tpl
          runtime/descriptivejs/runtime.js.tpl
          runtime/adapters/{{adapter}}.js.tpl
      overlays/
        pwa/
          app/manifest.webmanifest.tpl
          app/service-worker.js.tpl
        pwa+webview-any/
          app/ui/main/ui.ir.json.tpl
          app/ui/main/ui.manifest.json.tpl
        webview-any/
          app/webview-bridge.js.tpl
          host/prism.json.tpl
        webview-win+webview-linux/
          host/main.phs.tpl
        webview-mac/
          host/main.phs.tpl
        webview-ios+webview-android/
          host/main.phs.tpl
```

`files/` is the base template content.

`overlays/` contains target-specific or target-family additions/replacements.

The example overlay names are selectors. They are not arbitrary labels.

## Template Manifest

Each template has a manifest:

```json
{
  "name": "web_app_basic",
  "version": 1,
  "targets": [
    "pwa",
    "webview-win",
    "webview-mac",
    "webview-linux",
    "webview-ios",
    "webview-android"
  ],
  "defaultTarget": "pwa",
  "runtime": "descriptivejs-v1-shell",
  "description": "Basic web UI shell for PWA and Simple C++ webview targets.",
  "overlays": [
    "pwa",
    "pwa+webview-any",
    "webview-any",
    "webview-win+webview-linux",
    "webview-mac",
    "webview-ios+webview-android"
  ]
}
```

The materializer should validate that the requested target is listed in `targets`.

## Target Selector Syntax

The first selector syntax should stay small:

```text
pwa                 exact target
webview-any           wildcard target family
pwa+webview-any       union of selectors
webview-win+webview-linux
```

Rules:

- `+` means union.
- `*` is allowed only as a suffix wildcard for now.
- exact target selectors are more specific than wildcard selectors.
- if multiple layers write the same file, the last matching layer wins for now.
- the materializer must record overwritten files in diagnostics and the artifact manifest.

## Overlay Resolution

For a target, build the artifact plan from layers:

```text
1. template base files/
2. matching template overlays, broad to narrow
3. app/source template overrides from `src/materializers/`, broad to narrow
4. explicit app materialization config
```

Example for `webview-win`:

```text
materializers/templates/web_app_basic/files/**
materializers/templates/web_app_basic/overlays/pwa+webview-any/**
materializers/templates/web_app_basic/overlays/webview-any/**
materializers/templates/web_app_basic/overlays/webview-win+webview-linux/**
samples/hello_world/src/materializers/templates/web_app_basic/overlays/webview-win/**
```

The sample/app override should be able to replace one file without copying the whole template.

## App-Level Overrides

Apps and samples may override templates locally:

```text
samples/hello_world/
  src/
    materializers/
      templates/
        web_app_basic/
          overlays/
            pwa/
              app/ui/main/styles.css.tpl
            webview-any/
              app/ui/main/styles.css.tpl
```

The materializer should record local overrides in diagnostics and the generated artifact manifest.

## Generated Output

For `pwa`:

```text
.generated/build/pwa/app/
  index.html
  manifest.webmanifest
  service-worker.js
  ui/main/ui.ir.json
  ui/main/component.js
  ui/main/styles.css
  runtime/descriptivejs/runtime.js
  runtime/adapters/pwa.js
```

For webview targets:

```text
.generated/build/webview-win/
  host/
    main.phs
    prism.json
  app/
    index.html
    webview-bridge.js
    ui/main/ui.ir.json
    ui/main/component.js
    ui/main/styles.css
    runtime/descriptivejs/runtime.js
    runtime/adapters/simplecpp-webview.js
```

The `app/` folder should be loadable by Simple C++ with:

```php
webview_load_app($view, "app")
```

## CI Smoke Goal

The next validation step is Hello World emission for all first targets:

```text
pwa
webview-win
webview-mac
webview-linux
webview-ios
webview-android
```

Initial GitHub CI should regenerate and verify the sample:

1. run the materializer for each target
2. compare generated output with the expected fixture or expected artifact manifest
3. confirm output folder exists
4. confirm each target emits an app folder with `index.html`
5. confirm every webview target emits a real Simple C++ host project
6. validate JSON manifests
7. confirm artifact manifest records template, target, overlays, source files, overwritten files, and generated files
8. launch/render the PWA output and capture a screenshot artifact

This CI step should not yet require app-store signing, mobile simulator launches, or deep bridge behavior. The screenshot proves the generated UI renders at least for the browser/PWA path.

## Locked First Implementation Decisions

1. Template files use `*.tpl`.
2. Overlay conflicts use last matching layer wins for now.
3. Overwritten files are recorded in diagnostics and the artifact manifest.
4. `webview-ios` and `webview-android` should emit real Simple C++ host projects, not placeholder manifests.
5. App-level overrides live under `src/materializers/`.
6. CI regenerates generated sample outputs, compares them with the expected fixture or manifest, and captures a browser screenshot so render success is visible.


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
