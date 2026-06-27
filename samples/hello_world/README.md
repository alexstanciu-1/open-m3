# Hello World Descriptive App Sample

This is the first Descriptive Programming UI sample.

It demonstrates the intended v1 flow:

```text
description -> materialization -> runtime
```

Source description:

```text
src/ui/main/ui.json
```

Materialized PWA fixture:

```text
.generated/build/pwa/app/
```

This fixture is intentionally tiny. It uses a small DescriptiveJS v1 shell, a PWA adapter, and a generated UI IR. The generated files are checked in for now so the runtime shape can be inspected before the materializer exists.


Generate all first targets:

```bash
php materializers/materialize.php --app samples/hello_world --all
```

Generated targets:

```text
.generated/build/pwa/
.generated/build/webview-win/
.generated/build/webview-mac/
.generated/build/webview-linux/
.generated/build/webview-ios/
.generated/build/webview-android/
```

Run from the repository root:

```bash
python3 -m http.server 4173 --bind 127.0.0.1 --directory samples/hello_world/.generated/build/pwa/app
```

Then open:

```text
http://127.0.0.1:4173/
```
