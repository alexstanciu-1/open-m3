# Foreach Probe Report

Date: 2026-04-24

Project:
- [D:\Work_2026\open_m3\tools\foreach_mixed_repro](D:\Work_2026\open_m3\tools\foreach_mixed_repro)

Runtime:
- local Simple C++ repo: [D:\Work_2026\open_m3\simple_cpp](D:\Work_2026\open_m3\simple_cpp)

Command used:

```bash
cd /d/Work_2026/open_m3/tools/foreach_mixed_repro
scpp run
```

## Cases

| Case | Source | Form | Result |
|---|---|---|---|
| 1 | direct object-like data | `foreach ($data as $v)` | pass |
| 2 | direct object-like data | `foreach ($data as $k => $v)` | pass |
| 3 | direct object-like data | `foreach ($data as &$v)` | pass |
| 4 | direct object-like data | `foreach ($data as $k => &$v)` | pass |
| 5 | `json_decode(...)` data | `foreach ($data as $v)` | pass |
| 6 | `json_decode(...)` data | `foreach ($data as $k => $v)` | pass |
| 7 | `json_decode(...)` data | `foreach ($data as &$v)` | pass |
| 8 | `json_decode(...)` data | `foreach ($data as $k => &$v)` | pass |

## Exact Stdout

```text
without_json_decode
case_1_value_only
1
2
case_2_key_value
a:1
b:2
case_3_ref_value
a:11
b:12
case_4_key_ref_value
a:11
b:12
after:a:11
after:b:12
with_json_decode
case_5_value_only
1
2
case_6_key_value
a:1
b:2
case_7_ref_value
a:11
b:12
case_8_key_ref_value
a:11
b:12
after:a:11
after:b:12
```

## Conclusion

For object-like `mixed_t` data, both direct construction and `json_decode(...)` now support all four required `foreach` forms:

- value only
- key and value
- by-reference value
- key and by-reference value
