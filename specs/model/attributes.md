# Open M3 Model Attributes

Status: draft

Purpose: define the proposed Open M3 model attribute surface in a structured table format.

These are proposed new attributes, not a legacy inventory.

## Type Attributes

| Attribute | Scope | Data Type | Purpose |
| --- | --- | --- | --- |
| name | type | model_name | Declares the local model name within its folder-derived namespace. |
| properties | type/property | properties_list | Declares the named properties of a type definition. The same structure may also be reused for local struct.sub refinement. |
| disabled_props | type/property | string[] | Declares inherited property names disabled for a type-level or local sub-structure refinement. |
| abstract | type | bool | Marks the model as abstract and non-instantiable. |
| extends | type | type_ref | Declares the abstract base model extended by this concrete or abstract model. |

## Property Attributes

| Attribute | Scope | Data Type | Purpose |
| --- | --- | --- | --- |
| name | property | property_name | Declares the property name within its containing model. |
| type.name | property | scalar_type or type_ref | Declares the element type of the property. Together with `type.list`, this means either one value of that type or a list of values of that type. |
| type.list | property | bool | Declares whether the property is a list of values of `type.name`. Default is `false`, so it is only written when `true`. |
| required | property | bool | Declares whether the property is required at model level. |
| default | property | scalar or null | Declares the default semantic value for the property. |
| validation | property | validation_rule or validation_rule[] | Declares model-level validation rules. |
| struct.ref | property | string | Declares that a non-scalar property is a strong reference and names the expected root entry for that reference, such as Cities or Countries. |
| struct.weakref | property | bool | Declares that the property is a weak or non-owning reference. |
| struct.sub | property | bool | Declares that the property is a contained sub-structure. |

## Type Notes

| Name | Meaning |
| --- | --- |
| model_name | A local model name such as Hotel. The full model identity is derived from folder path plus local name. |
| type_ref | A reference to one model type, resolved as a file-like path such as Hotel, TF/Merch/Hotel, or ../../Hotel. |

## Property Notes

| Name | Meaning |
| --- | --- |
| property_name | A property name within its containing model, such as Address, Street, or Country. |
| scalar_type | One scalar type such as string, int, bool, float, date, datetime, time, or file. |
| scalar | A scalar literal value compatible with the declared scalar type. |
| validation_rule | A structured validation rule or rule identifier. |
| properties_list | A named list of locally declared refinement properties for a struct.sub usage. |

## Core Rules

| Rule Area | Rule |
| --- | --- |
| naming | Every model must have one explicit name. |
| naming | The effective model namespace is derived from folder structure by default. |
| naming | The effective full model identity is derived from folder namespace plus local model name. |
| naming | Every property must have one explicit name within its containing model. |
| naming | Property names must be unique within their containing model. |
| naming | Model type references resolve as file-like paths relative to the current model location by default. |
| inheritance | A concrete model may only extend an abstract model. |
| inheritance | A concrete model must not extend another concrete model. |
| root | An abstract model must not appear on the root model. |
| storage boundary | An abstract model must not have storage of its own. |
| interfaces | Interfaces are out of scope for the model system. Empty abstract models may be used instead. |
| typing | A property type must be strict. |
| typing | A property is defined as one value of `type.name` or a list of values of `type.name`. |
| typing | `type.list` defaults to false and should normally be omitted unless true. |
| typing | Only one scalar type is allowed per property. |
| typing | A property must not mix scalar and reference semantics. |
| typing | Only one reference target type is allowed per property. |
| typing | A reference target may be abstract. |
| structure | A non-scalar property defaults to struct.sub if no explicit struct.* attribute is declared. |
| structure | A non-scalar property must declare exactly one struct.* attribute after defaulting is applied. |
| structure | A scalar property must not declare a struct.* attribute. |
| structure | A property must not declare more than one struct.* attribute. |
| structure | If struct.ref is used, its value must be a string naming the expected root entry. |
| refinement | A struct.sub refinement may add properties. |
| refinement | A struct.sub refinement may disable inherited properties. |
| refinement | A struct.sub refinement must not change existing property types. |
| refinement | A struct.sub refinement must not change scalar/reference/sub semantics. |
| refinement | A struct.sub refinement must not change collection-ness. |

## Notes

| Topic | Note |
| --- | --- |
| naming | Inside an explicit model definition context, model-native attributes do not use the model. prefix. |
| naming | Folder structure is the default namespace source. Property names remain local to their containing model. |
| naming | Type references should use file-like paths such as Hotel, TF/Merch/Hotel, or ../../Hotel. |
| structure | The properties block is part of type structure. The same properties shape may also be reused inside struct.sub refinement. |
| structure | Every non-scalar property must choose exactly one structural mode through struct.ref, struct.weakref, or struct.sub. If nothing explicit is written, struct.sub is the default. Scalars do not use struct.* attributes. |
| direction | Model attributes may drive storage and view attributes, not the other way around. |
| structure | Structural meaning should be explicit in model metadata instead of inferred from storage conventions. |
| typing | The intended property message is `type.list` or not of `type.name`, not two unrelated meanings. |
| typing | When `type.list` is omitted, the property is treated as singular. |
| root/default selection | Root availability and default data-class selection should be defined in the top-level data definition, not on the model itself. |
| sub refinement | For struct.sub, local path-based refinement is allowed through add/disable style refinement. |
| internals | The system may auto-compute abstract/extends internals for refined submodels rather than requiring the user to author them explicitly. |
| polymorphism | If a property references an abstract model, derived concrete types should ideally materialize together for performance. |
