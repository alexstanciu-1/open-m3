# Descriptive UI Definition Direction

Status: initial planning note

Purpose: define the first authored UI shape for a minimal `Hello World!` UI while keeping future materialization to web and native UI targets possible.

## One-Sentence Summary

The first UI source should live under `src/ui/`, start with a tiny declarative `Hello World!` definition, and use an element vocabulary that can render to web now while preserving a future path to native controls.

## Source Layout

UI source should live under:

```text
src/ui/
```

For a single UI, the first slice can use:

```text
src/ui/main/
  ui.json
```

For multiple UIs:

```text
src/ui/
  admin/
    ui.json
  public/
    ui.json
  mobile/
    ui.json
```

The folder name is the UI identity unless overridden by the UI manifest.

The split inside one UI folder can be decided later. For now, keep one file per UI so the first materializer is simple.

## First Hello World Target

Minimum first authored UI:

```text
src/ui/main/ui.json
```

It should describe:

- UI id/name
- root element
- one text element saying `Hello World!`
- optionally one button for the first event/bridge test

The first materialized PWA should render this UI from the same description.

## Definition Format Options

### Option 1: JSON

Example:

```json
{
  "ui": "main",
  "root": {
    "type": "view",
    "children": [
      { "type": "text", "value": "Hello World!" },
      { "type": "button", "label": "Ping", "action": "hello.ping" }
    ]
  }
}
```

Pros:

- easiest to parse in regular PHP and JavaScript
- stable for materialization
- easy to generate from other formats
- easy to validate with schema-like checks

Cons:

- less pleasant for hand-authored nested UI
- comments/trailing commas are not available

### Option 2: JS-JSON

Example:

```js
{
  ui: "main",
  root: {
    type: "view",
    children: [
      { type: "text", value: "Hello World!" },
      { type: "button", label: "Ping", action: "hello.ping" }
    ]
  }
}
```

Pros:

- friendlier to author by hand
- can use the existing JS-JSON to JSON converter
- keeps canonical materializer input as JSON

Cons:

- needs conversion before strict tooling
- must stay data-only, not arbitrary JavaScript

### Option 3: XML

Example:

```xml
<ui name="main">
  <view>
    <text>Hello World!</text>
    <button action="hello.ping">Ping</button>
  </view>
</ui>
```

Pros:

- familiar for UI markup
- good for hierarchical trees
- can be edited with XML tools

Cons:

- heavier parser path in PHP/JS
- mixed content rules can become awkward
- less natural for state/action/config objects

### Option 4: XHTML/HTML Subset

Example:

```html
<main data-ui="main">
  <section>
    <p>Hello World!</p>
    <button data-action="hello.ping">Ping</button>
  </section>
</main>
```

Pros:

- immediately familiar to web authors
- easy to preview in browsers
- natural for web/PWA target

Cons:

- HTML semantics can leak into the descriptive model
- harder to map cleanly to native controls
- needs rules for non-HTML app concepts such as state, actions, data binding, permissions, routes

## Element Vocabulary Options

### Option A: Own Vocabulary

Examples:

- `view`
- `panel`
- `text`
- `button`
- `input`
- `list`
- `grid`
- `form`
- `field`
- `tabs`
- `dialog`

Pros:

- can be target-neutral from day one
- easier to map to native controls later
- avoids accidental dependence on HTML behavior

Cons:

- users must learn a new vocabulary
- web materializer must define all rendering semantics

### Option B: HTML Subset Plus Extensions

Examples:

- `main`
- `section`
- `header`
- `footer`
- `p`
- `button`
- `input`
- `form`
- `table`
- plus Open M3 extensions such as `grid`, `panel`, `data-view`

Pros:

- familiar to frontend authors
- PWA materialization is straightforward
- easy first prototype

Cons:

- native mapping may be less direct
- HTML names may carry browser-specific expectations

### Option C: Semantic Core With Web Aliases

Canonical element names stay target-neutral, but web-friendly aliases are allowed.

Examples:

```text
canonical: view, text, action, stack, grid
aliases: section -> view, p -> text, button -> action/button
```

Pros:

- gives users familiar names where possible
- keeps a native-friendly canonical model internally
- materializer can normalize aliases before rendering

Cons:

- requires a normalization layer
- documentation must clearly distinguish source aliases from canonical nodes

### Option D: Platform-Neutral Accessibility Vocabulary

Elements are named by role and intent rather than rendering tag.

Examples:

- `screen`
- `region`
- `label`
- `command`
- `textField`
- `choice`
- `collection`
- `table`
- `navigation`

Pros:

- maps well to native accessibility and UI automation concepts
- encourages intent-first definitions
- good long-term for cross-platform UI

Cons:

- more abstract than users expect for first authoring
- may feel less natural for simple visual layout

## Recommended First Direction

Use JSON or JS-JSON as the authored source for the first slice.

Use a semantic core vocabulary with optional web aliases later.

For the first `Hello World!`, keep the canonical vocabulary tiny:

- `view`
- `text`
- `button`

Example canonical JSON:

```json
{
  "ui": "main",
  "version": 1,
  "root": {
    "type": "view",
    "layout": "stack",
    "children": [
      {
        "type": "text",
        "value": "Hello World!"
      },
      {
        "type": "button",
        "label": "Ping",
        "action": "hello.ping"
      }
    ]
  }
}
```

This can materialize to web as:

```html
<main>
  <div>Hello World!</div>
  <button>Ping</button>
</main>
```

And later to native as:

```text
view -> window/content root or native container
text -> label/static text
button -> native button/control
stack layout -> platform stack/box/flex equivalent
```

## Materialization Rule

The materializer should normalize authored UI into a canonical UI tree before target rendering.

```text
source UI file
  -> parse
  -> normalize element names and aliases
  -> validate canonical tree
  -> emit target UI artifacts
```

This keeps future native materialization possible even if the source format becomes friendlier over time.

## First Native Mapping Goal

The first native-oriented model should avoid browser-only assumptions.

Good first elements:

- `view`
- `text`
- `button`
- `input`
- `stack`

Defer:

- CSS-specific layout semantics
- arbitrary HTML
- DOM-only lifecycle hooks
- browser-specific events
- canvas/SVG-heavy UI

## Open Questions

- Should the first source file be `ui.json`, `ui.jsjson`, or `ui.xml`?
- Should `button` be canonical, or should canonical command controls be named `command` with `button` as a web/native style?
- Should layout be an element type such as `stack`, or a property such as `layout: "stack"`?
- Should multi-UI folders contain a manifest file, or is the folder name enough at first?
- Should web aliases be accepted in v1, or should v1 start canonical-only?
