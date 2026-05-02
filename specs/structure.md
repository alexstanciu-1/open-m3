# Open M3 Structure

Status: draft

Purpose: record the current intended folder and module structure for Open M3 in a simple practical form.

## Main Idea

Open M3 should keep a clear separation between:

- specifications
- tools
- samples
- modules
- legacy reference material

This keeps the project readable while allowing the runtime to grow gradually.

## Top-Level Folders

| Folder | Purpose |
| --- | --- |
| `specs/` | Architecture, layer, model, storage, process, and other design documents. |
| `tools/` | Small utilities, converters, generators, probes, and one-off migration tools. |
| `samples/` | Generated examples, reference outputs, and comparison artifacts used to validate the design. |
| `modules/` | Runtime modules that implement Open M3 capabilities in reusable compiled form. |
| `_legacy_code/` | Legacy projects and framework code kept for study, conversion, and compatibility work. This may live outside the tracked repo when needed. |
| `simple_cpp/` | A local Simple C++ compiler/runtime checkout used to build Open M3 code. It may be kept adjacent to the repo instead of committed inside it. |

## Current Direction For Modules

The `modules/` folder is intended for reusable runtime pieces, not for app-specific code.

The first major runtime module should be:

- `modules/orm/`

This fits the current roadmap because the ORM is the first major Open M3 runtime capability needed for co-working with legacy projects.

## ORM Module Direction

| Topic | Direction |
| --- | --- |
| folder | Place the ORM under `modules/orm/`. |
| role | The ORM should materialize Open M3 model and storage definitions and co-work with legacy databases. |
| build shape | The ORM should compile as a shared library such as `.so` or `.dll`. |
| reason | This keeps the ORM reusable, modular, and separate from app/tool code. |

## Suggested ORM Internal Structure

This is still provisional, but the ORM module will likely need internal areas such as:

- metadata assembly
- model/storage linking
- relation planning
- SQL generation
- runtime query and persistence behavior
- database or dialect-specific code

The important point is that `modules/orm/` should stay a module, not become a catch-all folder.

## Relationship Between Folders

| From | To | Relationship |
| --- | --- | --- |
| `specs/` | `modules/` | Specs define what modules should do. |
| `tools/` | `samples/` | Tools generate and refresh sample outputs. |
| `tools/` | `_legacy_code/` | Tools read legacy metadata and code to extract know-how. |
| `modules/` | `samples/` | Modules should eventually be validated against sample outputs and legacy comparisons. |
| `modules/` | `_legacy_code/` | Runtime compatibility is tested against legacy schemas and behavior. |

## Current Working View

The current repository is not yet fully structured as a final platform.

At the moment, some important reference material is intentionally external to this tracked repo:

- legacy reference root: `/home/alexv/__AI/open_m3/open_m3_primary/_legacy_code`
- local Simple C++ checkout: `/home/alexv/__AI/open_m3/open_m3_primary/simple_cpp`

At this stage:

- `specs/` defines the architecture
- `tools/` bridges legacy data into Open M3 form
- `samples/` shows what the new metadata looks like
- `modules/orm/` is the next major runtime piece to build

That is enough structure to keep moving without over-designing the repo too early.
