# Open M3 Metadata Categories

Status: draft

Purpose: collect the metadata vocabulary found in legacy systems and group it by category.

These tables are intentionally simple for now. We can add more columns later.

## Model

| Attribute | Scope |
| --- | --- |
| `type.api` | type |
| `type.cfg` | type |
| `type.class` | type |
| `type.is_abstract` | type |
| `type.is_interface` | type |
| `type.methods` | type |
| `type.model` | type |
| `type.parent` | type |
| `type.path` | type |
| `type.properties` | type |
| `type.storage` | type |
| `property.cfg` | property |
| `property.default` | property |
| `property.filter` | property |
| `property.fixValue` | property |
| `property.name` | property |
| `property.parent` | property |
| `property.strict` | property |
| `struct.ref` | property |
| `struct.sub` | property |
| `struct.weakref` | property |
| `property.types` | property |
| `property.validation` | property |
| `model.captionInvoice_Series` | type |
| `model.captionInvoices_VAT_Rates` | type |
| `model.captionProperties` | type |
| `model.captions` | type |

## Storage

| Attribute | Scope |
| --- | --- |
| `property.storage` | property |
| `storage.admin.default` | property |
| `storage.admin.readonly` | property |
| `storage.admin.readonly_IF` | property |
| `storage.admin.render_IF` | property |
| `storage.api_identifier` | type |
| `storage.attrs` | property |
| `storage.avoid_duplicates` | property |
| `storage.caption` | type/property |
| `storage.captions` | type/property |
| `storage.checkbox_coll_binds` | property |
| `storage.checkbox_coll_custq` | property |
| `storage.collection` | property |
| `storage.collection_type` | property |
| `storage.column` | property |
| `storage.compressed` | property |
| `storage.date_format` | property |
| `storage.default` | type/property |
| `storage.dependency` | property |
| `storage.dims` | property |
| `storage.display` | property |
| `storage.display.sections` | property |
| `storage.display.sub_sections` | property |
| `storage.display.tabs` | property |
| `storage.displayOnTab` | property |
| `storage.dropdownProperty` | property |
| `storage.dropdownSelector` | property |
| `storage.enum_captions` | property |
| `storage.enum_display` | property |
| `storage.enum_styles` | property |
| `storage.enum_values` | property |
| `storage.enum_values_props` | property |
| `storage.field.style` | property |
| `storage.fileMode` | property |
| `storage.filePath` | property |
| `storage.fileWithPath` | property |
| `storage.filter` | property |
| `storage.formula` | property |
| `storage.has_default_row` | property |
| `storage.in_menu` | property |
| `storage.index` | property |
| `storage.info` | property |
| `storage.keepInSync` | property |
| `storage.mandatory` | property |
| `storage.manyToMany` | property |
| `storage.mergeBy` | type/property |
| `storage.no_default_row` | property |
| `storage.none` | property |
| `storage.nonull` | property |
| `storage.notnull` | property |
| `storage.oneToMany` | property |
| `storage.oneToOne` | property |
| `storage.optionsPool` | property |
| `storage.populateBeforeInsert` | property |
| `storage.settings` | type/property |
| `storage.synchronizable` | property |
| `storage.table` | type/property |
| `storage.type` | property |
| `storage.unsigned` | property |
| `storage.use_wysiwyg` | property |
| `storage.view_js_patch` | property |
| `storage.view_to_load` | property |
| `storage.views` | property |

## View

| Attribute | Scope |
| --- | --- |
| `property.display` | property |
| `display.block` | property |
| `display.controls` | property |
| `display.fk_expand` | property |
| `display.properties` | property |
| `display.show` | property |
| `display.sticky` | property |
| `display.tree` | property |
| `display.type` | property |
| `@boxes` | type/view |
| `@groups` | type/view |
| `@layout` | type/view |
| `@layout-mode` | type/view |
| `@select` | type/view |
| `@tag` | type/view |
| `@sections` | type/view |
| `@subSections` | type/view |
| `@tabs` | type/view |
| `@steps` | type/view |
| `@rows` | type/view |
| `@cols` | type/view |
| `@sectionProps` | type/view |
| `@tabProps` | type/view |
| `@onSection` | property |
| `@onTab` | property |
| `@main` | type/view |
| `@tag` | type/view |
| `@caption` | property |
| `@caption_add` | type/view |
| `@caption_edit` | type/view |
| `@caption_list` | type/view |
| `@caption_view` | type/view |
| `@display` | property |
| `@display.datepicker` | property |
| `@display.editor` | property |
| `@display.hideLabel` | property |
| `@display.placeholder` | property |
| `@dropdown` | property |
| `@dropdown.binds` | property |
| `@date.format` | property |
| `@input.type` | property |
| `@input.min` | property |
| `@input.max` | property |
| `@readonly` | property |
| `@readonly_if` | property |
| `@render_if` | property |
| `@hidden.if` | property |
| `@default` | property |
| `@mandatory` | property |
| `@validation` | property |
| `@fixValue` | property |
| `@info` | property |
| `@type` | property |
| `@view.style` | property |
| `@label.display` | property |
| `@listing.caption` | property |
| `@listing.link` | property |
| `@enum.captions` | property |
| `@enum.display` | property |
| `@enum.values` | property |
| `@checkbox.extraLabel` | property |
| `@collection.hide.add` | property |
| `@collection.hide.delete` | property |
| `@collection.popup.edit` | property |
| `@coll.checkboxes` | property |
| `@coll.checkboxCustomQuery` | property |
| `@select` | type/view |
| `@search` | property |
| `@options` | property |
| `@pattern` | property |
| `@show_bulk_button` | type/view |
| `@filed` | property |
| `@multi` | property |
| `@list_checkboxes` | property |

## Security

| Attribute | Scope |
| --- | --- |
| `property.security` | property |

## API

| Attribute | Scope |
| --- | --- |
| `method.api` | method |
| `method.in` | method |
| `method.name` | method |
| `method.parent` | method |
| `method.static` | method |
| `api.enable` | method |
