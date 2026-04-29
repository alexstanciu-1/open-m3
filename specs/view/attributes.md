# Open M3 View Attributes

Status: draft

Purpose: define the proposed Open M3 view attribute surface in a structured table format.

These are proposed new attributes, not a legacy inventory.

## Type Attributes

| Attribute | Scope | Data Type | Purpose |
| --- | --- | --- | --- |
| caption | type | string | Declares the default view-facing caption or label for the model in UI contexts. |

## Property Attributes

| Attribute | Scope | Data Type | Purpose |
| --- | --- | --- | --- |
| caption | property | string | Declares the default view-facing caption or label for the property in UI contexts. |
| enum.captions | property | caption_list | Declares view-facing captions for enum values in UI contexts. |

## View Notes

| Name | Meaning |
| --- | --- |
| caption_list | A list of enum values paired with their view-facing captions. |

## Notes

| Topic | Note |
| --- | --- |
| separation | Caption is treated as view metadata for now, not model metadata. |
| separation | Enum captions are treated as view metadata for now, not model metadata. |
| enums | Enum values are intentionally out of the current model/view attribute set until a cleaner enum design is specified. |
| direction | View metadata may be derived from model semantics, but it must not define core model meaning. |
