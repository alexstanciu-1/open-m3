# Open M3 Sub-Structure Refinement Example

Status: draft

Purpose: keep a practical reference example for path-based `struct.sub` refinement.

## Example

### Address.json

```json
{
  "Street": "...",
  "City": "...",
  "Country": "..."
}
```

### Hotel.json

```json
{
  "Address": {
    "type": "Address",
    "properties": {
      "Custom_Field_1": "..."
    }
  }
}
```

### App.json

```json
{
  "Hotels": {
    "type": "Hotel[]",
    "properties": {
      "Address": {
        "type": "Address",
        "properties": {
          "Custom_Field_2": "..."
        }
      }
    }
  }
}
```

## Explanation

| Path | Meaning |
| --- | --- |
| `Address` | Base reusable model definition. |
| `Hotel.Address` | Local refinement of the base `Address` model at the `Hotel` level. |
| `App.Hotels.Address` | Additional local refinement of the same base `Address` model at the root path level. |

## Effective Interpretation

| Location | Effect |
| --- | --- |
| base model | Defines the shared reusable address structure. |
| `Hotel.Address.properties` | Adds or disables fields for address as used inside `Hotel`. |
| `App.Hotels.properties.Address.properties` | Adds or disables fields again for address as used specifically from the `Hotels` root entry. |

This means the effective shape of a `struct.sub` model may depend on the full path from the root model.

## Why This Exists

| Problem | Practical Need |
| --- | --- |
| Shared submodels are not always sufficient | A reusable model such as `Address` may need local changes depending on where it is embedded. |
| Root path matters | `Hotels.Address` and `Customers.Address` may need different local fields or disabled fields. |
| References are different | This path-sensitive behavior is needed for `struct.sub`, not for `struct.ref` or `struct.weakref`. A strong reference should instead point to an expected root entry such as `Cities` or `Countries`. |

## Allowed Refinement Operations

| Operation | Allowed |
| --- | --- |
| add property | yes |
| disable inherited property | yes |
| change existing property type | no |
| change scalar/reference/sub semantics | no |
| change collection-ness | no |

## Direction

| Topic | Direction |
| --- | --- |
| simplicity | Keep the authoring model local and practical. |
| reuse | Reuse a stable base model and refine it where needed. |
| control | Allow control based on the full path from the root model. |
| internals | Let the system compute any internal abstract/extends mechanics if needed. |
