# Open M3 Metadata Review

Status: draft

Purpose: document what legacy metadata attributes appear to do in code, whether they are used, and whether they may duplicate other mechanisms.

This file is intentionally incremental. It starts with attributes that have been verified in code.

## Model

| Attribute | Scope | What It Does | Evidence | Used? | Duplicate? | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `model.captionProperties` | type | Defines the property path list used to derive captions / display labels for model instances. | `QModelQuery.php`, `QModel_Methods.php`, `Grid_Methods.php`, `QCodeStorage.php` in `omi-frame`; many model docblocks in `omi-frame` and `omi-mods`. | yes | no clear duplicate | Strong cross-project usage. This is one of the most important model-level attributes. |
| `property.validation` | property | Carries validation rules for a property. At least `mandatory` is consumed by framework helpers. | `QModelProperty.php` in Travelfuse `omi-frame` checks `mandatory` via `preg_match`. | yes | partly overlaps `storage.mandatory` | Likely needs later normalization because both validation and storage/admin metadata can express required-ness. |
| `property.types` | property | Defines accepted type(s) for the property and drives scalar/model/reference semantics. | `QModelProperty.php`, `QSqlModelInfoType.php`, `QSqlModelInfoProperty.php`. | yes | no | Fundamental model metadata. |
| `property.fixValue` | property | Requests value normalization before persistence/use, such as `trim`. | Present broadly in exported metadata; direct consumer still to be traced. | unknown | maybe overlaps validation/transform hooks | Needs a second pass to find the exact runtime normalization point. |
| `struct.ref` | property | Intended structural marker for a strong reference to another model object. | Added as working Open M3 classification attribute; legacy code trace not done yet. | unknown | overlaps parts of `property.types` and storage relation metadata | Useful as a cleaner semantic category than encoding everything through ORM attributes. |
| `struct.sub` | property | Intended structural marker for a contained/nested sub-object rather than an external reference. | Added as working Open M3 classification attribute; legacy code trace not done yet. | unknown | overlaps parts of `storage.dependency`, `storage.display`, and composition conventions | Good candidate for separating composition from persistence. |
| `struct.weakref` | property | Intended structural marker for a weak or non-owning reference. | Added as working Open M3 classification attribute; legacy code trace not done yet. | unknown | overlaps selected `optionsPool` / reference-style patterns | Likely valuable for distinguishing lookup/reference semantics from containment. |

## Storage

| Attribute | Scope | What It Does | Evidence | Used? | Duplicate? | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `storage.table` | type/property | Maps a model type, or sometimes a property/ref collection, to a storage table name. | `QSqlModelInfoType.php`, `QModelType.php`, `QSqlTable.class.php`. | yes | no | Core storage mapping attribute. |
| `storage.type` | property | Forces the storage column type / SQL type for a property. | `QSqlModelInfoProperty.php`. | yes | no | Strong ORM/storage attribute. |
| `storage.index` | property | Declares index behavior, including unique/indexed fields. | Seen in exported metadata; storage info code reads storage definitions broadly. | likely yes | no | Needs a precise callsite pass for index generation. |
| `storage.none` | property | Marks a property as non-stored / skipped in SQL mapping and traversal. | `QSqlTable.class.php`, `QSqlTable_Titem.php`, `QSqlModelInfoType.php`. | yes | no | Important divider between model-only and persisted properties. |
| `storage.oneToMany` | property | Declares one-to-many ownership/backref mapping. | `QSqlTable.class.php`, `QSqlTable_Titem.php`, `QModelProperty.php`. | yes | no | Core relationship storage attribute. |
| `storage.manyToMany` | property | Declares many-to-many collection semantics. | `QModelProperty.php` and SQL mapping code paths. | yes | no | Usually used together with `storage.collection`. |
| `storage.collection` | property | Declares join-table / collection mapping details. | `QModelProperty.php`, `QSqlModelInfoType.php`. | yes | no | Core relationship storage attribute. |
| `storage.mergeBy` | type/property | Controls merge/upsert identity for nested or related items. | `QSqlTable.class.php`, `QSqlTable_Titem.php`, `QSqlModelInfoType.php`. | yes | no | Important for sync/import style systems. |
| `storage.populateBeforeInsert` | property | Requests data population before insert flow. | `QSqlTable.class.php`. | yes | no clear duplicate | Operational storage lifecycle attribute. |
| `storage.optionsPool` | property | Points a property to an app-level source collection used for references/options. | `QModel_Trait.php`, `QModel_Methods.php`, `Grid.php`, `QApi.class.php`, `QSqlTable_Titem.php`. | yes | no | Heavy cross-layer usage. Acts as bridge between storage/reference metadata and generated UI/API behavior. |
| `storage.view_to_load` | property | Names the popup/helper view used to manage or select referenced items in generated UI. | `Grid.php`, reference dropdown templates, model docblocks like `Address.class.php`. | yes | no | This is view-facing but encoded under storage in legacy systems. Candidate for relocation in Open M3. |
| `storage.checkbox_coll_custq` | property | Provides a custom query/callback for checkbox collection options. | `Grid.php`; model docblocks like `Price_Profile.class.php`. | yes | maybe overlaps richer collection/query config | Strong generator/backend attribute, not pure storage. |
| `storage.enum_captions` | property | Supplies label mapping for enum/raw values in edit, list, scalar, and search views. | `QModel_Methods.php`, `Grid.php`, many generator templates in `common/gens/templates`. | yes | overlaps `@enum.captions` | Clear legacy duplication between source metadata and backend-config overrides. |
| `storage.displayOnTab` | property | Associates a property with tab placement in generated forms. | `Grid.php` parses `storage.full["displayOnTab"]`. | yes | overlaps config `@tabs` / `@onTab` | Likely should become view/generator metadata in Open M3. |
| `storage.admin.readonly_IF` | property | Expression controlling readonly state in generated backend forms. | `Grid.php`, model docblocks such as `Owner_Trait.php`. | yes | overlaps `@readonly_if` | Strong example of source-level and config-level duplication. |
| `storage.admin.render_IF` | property | Expression controlling whether a field is rendered in generated backend UI. | `Grid.php`, templates like `list_inner.tpl`, model docblocks such as `Owner_Trait.php`. | yes | overlaps `@render_if` | Same duplication pattern as readonly. |
| `storage.views` | property | Attaches generated/admin view tags to an app property or collection. | `QCodeSync2.php`, many `App.type.php` exports. | yes | overlaps backend config naming | Feels more like generator/view routing metadata than storage proper. |

## View

| Attribute | Scope | What It Does | Evidence | Used? | Duplicate? | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `property.display` | property | Carries display hints on a property. | Exported metadata shows values like `controls`; exact framework consumer still to be traced. | unknown | overlaps backend config directives | Needs a targeted pass. |
| `display.controls` | property | Enables control-style treatment for a property in UI metadata. | Seen in `Address.type.php` exports. | unknown | overlaps generator config | Export-only evidence so far. |
| `@groups` | type/view | Declares grouped layout blocks in generated forms/views. | `common/gens/Grid.php` reads and validates `@groups`. | yes | overlaps `@boxes` in layout intent | Both are active; may represent two layout vocabularies. |
| `@boxes` | type/view | Declares structured layout/placement blocks for generated forms/views. | `common/gens/Grid.php` reads `@boxes`, extracts selectors, and builds form selectors. | yes | overlaps `@groups` | Appears to be a second, more placement-oriented layout vocabulary. |
| `@layout` | type/view | Provides custom layout content/template inside groups/placeholders. | `common/gens/Grid.php` at placeholder and group layout handling. | yes | no | Strong generator/layout directive. |
| `@layout-mode` | type/view | Selects the layout strategy for a group or generated block, for example box layout. | Seen throughout backend config; used together with `@layout` and `@groups`. | likely yes | overlaps parts of `@boxes` semantics | Needs direct consumer trace. |
| `@select` | type/view | Declares which properties are included inside a configured group, box, or section. | `common/gens/Grid.php` validates missing select definitions and extracts selector data from groups/boxes. | yes | no | Central structural view attribute. |
| `@tag` | type/view | Tags a group, box, or section with an identifier such as `@main` or a named block. | Seen broadly in both backend config trees. | likely yes | maybe overlaps group keys | Needs direct render/layout consumer trace. |
| `@steps` | type/view | Declares multi-step form layout / flow grouping. | Present in backend config and step component system; exact central consumer still to be traced. | likely yes | overlaps specialized step components | Needs a focused pass on step templates and config consumers. |
| `@rows` | type/view | Declares row-oriented layout structure for configured views. | Present in backend config vocabulary. | seen-only | overlaps `@groups` / `@boxes` | Needs code trace. |
| `@cols` | type/view | Declares column count or column layout for a configured block or section. | Seen broadly in backend config box definitions. | likely yes | no | Layout metadata; needs direct consumer trace. |
| `@sections` | type/view | Declares higher-level section layout organization. | Present in backend config vocabulary. | seen-only | maybe overlaps `@groups` | Needs direct code trace. |
| `@subSections` | type/view | Declares nested subsection layout organization. | Present in backend config vocabulary. | seen-only | maybe overlaps `@groups` / `@boxes` | Needs direct code trace. |
| `@tabs` | type/view | Declares tabbed organization in generated forms or views. | Present in backend config vocabulary and conceptually overlaps `storage.displayOnTab`. | seen-only | overlaps `storage.displayOnTab` | Important duplication candidate. |
| `@sectionProps` | type/view | Carries extra section-level configuration properties. | Present in backend config vocabulary. | seen-only | no clear duplicate | Needs code trace. |
| `@tabProps` | type/view | Carries extra tab-level configuration properties. | Present in backend config vocabulary. | seen-only | no clear duplicate | Needs code trace. |
| `@onSection` | property | Assigns a property to a configured section. | Present in backend config vocabulary. | seen-only | overlaps section layout config | Needs code trace. |
| `@onTab` | property | Assigns a property to a configured tab. | Present in backend config vocabulary and overlaps tab placement metadata. | seen-only | overlaps `storage.displayOnTab` | Likely part of the same placement space. |
| `@caption` | property | Provides a custom caption/label for a property or a configured box/section. | Seen throughout both backend config trees. | likely yes | overlaps model captions and list captions | Very common attribute. |
| `@caption_add` | type/view | Provides the add-mode caption for a generated view/form. | Seen in backend config files like `Holder.php`, `Branding.php`. | likely yes | no | View-level heading metadata. |
| `@caption_edit` | type/view | Provides the edit-mode caption for a generated view/form. | Seen in backend config files like `Holder.php`, `Branding.php`. | likely yes | no | View-level heading metadata. |
| `@caption_list` | type/view | Provides list-mode caption text for a generated view. | Present in backend config vocabulary. | seen-only | no | Needs code trace. |
| `@caption_view` | type/view | Provides view-mode caption text for a generated view/form. | Present in backend config vocabulary. | seen-only | no | Needs code trace. |
| `@display` | property | Carries general display metadata for a property or configured view element. | Seen in backend config like `Customers.php`, `Porting.php`, `GeoNumberPortingConfigs@GeoNumberPortingConfigs.php`. | likely yes | overlaps `property.display` and `storage.display` | Needs trace to understand precedence. |
| `@display.datepicker` | property | Requests datepicker-style rendering for the field. | Seen in backend config like `Cancellation_Policies.php`. | likely yes | no clear duplicate | UI widget hint. |
| `@readonly_if` | property | Config-level readonly condition override in generated forms. | `common/gens/Grid.php` via `ExtractExtraConfig`. | yes | duplicates `storage.admin.readonly_IF` | Open M3 should likely keep one source of truth plus override rules. |
| `@render_if` | property | Config-level render condition override in generated views/forms. | `common/gens/Grid.php` via `ExtractExtraConfig`. | yes | duplicates `storage.admin.render_IF` | Same duplication pattern. |
| `@display.editor` | property | Forces editor/display mode in generated UI. | `common/gens/Grid.php`. | yes | no clear duplicate | View/generator-specific. |
| `@display.hideLabel` | property | Suppresses or alters label visibility in generated UI. | Present in backend config vocabulary. | seen-only | no | Needs code trace. |
| `@display.placeholder` | property | Sets placeholder text or placeholder-like display behavior. | Present in backend config vocabulary. | seen-only | no | Needs code trace. |
| `@dropdown` | property | Carries dropdown/reference control configuration in backend config. | Seen broadly in both backend config trees. | likely yes | overlaps `storage.optionsPool` and `storage.view_to_load` | Important bridge attribute. |
| `@dropdown.binds` | property | Provides bind parameters/configuration for dropdown-backed controls. | Present in backend config vocabulary. | seen-only | overlaps other dropdown config | Needs code trace. |
| `@date.format` | property | Declares date formatting for view/edit/search presentation. | Present in backend config vocabulary. | seen-only | overlaps storage/date formatting concerns | Needs code trace. |
| `@input.type` | property | Forces input control type in generated edit/search UI. | Seen widely in backend config. | likely yes | no | Core widget metadata. |
| `@input.min` | property | Declares minimum input value/constraint in generated UI. | Present in backend config vocabulary. | seen-only | overlaps validation concerns | Needs code trace. |
| `@input.max` | property | Declares maximum input value/constraint in generated UI. | Present in backend config vocabulary. | seen-only | overlaps validation concerns | Needs code trace. |
| `@readonly` | property | Forces read-only rendering independent of conditions. | Seen in backend config like `Porting.php` and `Age_Intervals.php`. | likely yes | overlaps `@readonly_if` | Simpler static variant. |
| `@hidden.if` | property | Conditional visibility rule hiding a property in generated UI. | Present in backend config vocabulary. | seen-only | overlaps `@render_if` | Needs code trace. |
| `@default` | property | Provides default UI/config value in backend-config-driven views and searches. | Seen broadly in backend config, especially search config. | likely yes | overlaps `property.default` and `storage.default` | Another duplication candidate. |
| `@mandatory` | property | Marks a field as required in generated UI/config. | Seen broadly in both backend config trees. | likely yes | overlaps `property.validation` and `storage.mandatory` | Important duplication candidate. |
| `@validation` | property | Carries validation-related UI/config directives. | Present in backend config vocabulary. | seen-only | overlaps `property.validation` | Needs code trace. |
| `@fixValue` | property | Carries value normalization/cleanup directives at config level. | Present in backend config vocabulary. | seen-only | overlaps `property.fixValue` | Needs code trace. |
| `@info` | property | Adds descriptive/help metadata for generated UI. | Present in backend config vocabulary. | seen-only | overlaps `storage.info` | Needs code trace. |
| `@type` | property | Declares control/search type in backend config. | Seen especially in search config like `Orders_Report.php`. | likely yes | overlaps `property.types` in meaning but not role | Should stay view-specific. |
| `@view.style` | property | Applies style variant/class semantics to generated property rendering. | Present in backend config vocabulary. | seen-only | overlaps `storage.field.style` | Needs code trace. |
| `@label.display` | property | Controls label rendering/display style. | Present in backend config vocabulary. | seen-only | overlaps generic display metadata | Needs code trace. |
| `@listing.caption` | property | Customizes listing caption/header semantics. | Present in backend config vocabulary. | seen-only | overlaps `@caption` | Needs code trace. |
| `@listing.link` | property | Controls link behavior in listing views. | Present in backend config vocabulary. | seen-only | no clear duplicate | Needs code trace. |
| `@enum.captions` | property | Config-level enum captions override. | `common/gens/Grid.php`. | yes | duplicates `storage.enum_captions` | Useful explicit override layer. |
| `@enum.display` | property | Config-level enum rendering mode, for example dropdown treatment. | Seen in backend config like `Cancellation_Policies.php`. | likely yes | overlaps widget/display settings | Needs code trace. |
| `@enum.values` | property | Config-level explicit enum value list. | Present in backend config vocabulary. | seen-only | overlaps storage enum metadata | Needs code trace. |
| `@checkbox.extraLabel` | property | Adds extra label text/behavior for checkbox-style controls. | Present in backend config vocabulary. | seen-only | no clear duplicate | Needs code trace. |
| `@collection.hide.add` | property | Hides add action for collection editors in generated UI. | Seen in both backend config trees. | likely yes | no | Collection UI behavior metadata. |
| `@collection.hide.delete` | property | Hides delete action for collection editors in generated UI. | Seen in both backend config trees. | likely yes | no | Collection UI behavior metadata. |
| `@collection.popup.edit` | property | Specifies popup edit view for a collection entry. | Seen in backend config such as `Customers@Customers.php`. | likely yes | overlaps `storage.view_to_load` | Similar concept in a different layer. |
| `@coll.checkboxes` | property | Requests checkbox-based collection editing/rendering. | Present in backend config vocabulary. | seen-only | overlaps `storage.collection_type` | Needs code trace. |
| `@coll.checkboxCustomQuery` | property | Supplies a custom query for checkbox-based collection options. | Present in backend config vocabulary. | seen-only | overlaps `storage.checkbox_coll_custq` | Same concept at config level. |
| `@search` | property | Declares custom search field definitions/config for a view or report. | Seen in backend config like `Orders_Report.php` and search templates. | likely yes | no | Important search/view metadata. |
| `@options` | property | Supplies option sets for search widgets or enumerated UI selectors. | Seen in search config and search templates. | likely yes | overlaps enum captions/options patterns | Needs finer split later. |
| `@pattern` | property | Declares matching/search pattern behavior. | Present in backend config vocabulary. | seen-only | no clear duplicate | Needs code trace. |
| `@show_bulk_button` | type/view | Controls whether bulk-action UI is shown for a view/list. | Seen in Voipfuse backend config. | seen-only | no clear duplicate | Needs code trace. |
| `@filed` | property | Legacy search-config key representing the bound field name. | Seen in `Orders_Report.php` and search templates. | yes | likely typo/duplicate of intended `@field` | Strong candidate for cleanup/rename in Open M3. |
| `@multi` | property | Marks a search or selector control as multi-value. | Seen in search templates and backend config vocabulary. | likely yes | no | Search/view control metadata. |
| `@list_checkboxes` | property | Requests checkbox treatment in list contexts. | Present in backend config vocabulary. | seen-only | overlaps other checkbox-related attributes | Needs code trace. |

## Security

| Attribute | Scope | What It Does | Evidence | Used? | Duplicate? | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `property.security` | property | Attaches security rules to a property. | `QSecurityGenerator.php` reads `$prop->security`. | yes | no | Real security metadata, not just a convention. |
| `type.security` | type | Attaches security rules to a type. | `QSecurityGenerator.php` reads `$type_inf->security`. | yes | no | This exists in code even though it did not show up in the earlier raw attribute table. |

## API

| Attribute | Scope | What It Does | Evidence | Used? | Duplicate? | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `api.enable` | method | Marks a method as API-exposed / callable through the framework API layer. | `QApi.type.php` exports, `QSecurity_Check.php`, MVVM API wrappers. | yes | no | Fundamental API exposure flag. |
| `method.in` | method | Indicates the declaring/input context used for generated method metadata. | Present in type exports for API-enabled methods. | likely yes | no | Needs a direct runtime consumer trace. |
