Goal: sub-1 KiB-ish parser that reads a tiny profile format and prints a summary. Built in C with a custom linker script to encourage size discipline; not guaranteed to stay under 1024 bytes without tuning flags.

Targets:
- `make build` — build `build/parser`.
- `make test` — run parser on samples and size check.
- `make smoke` — same as test but tolerant of missing compiler.

Input format (lines):
- `name: <text>`
- `role: <text>`
- `skills: item1, item2, item3`

Output:
`<name> (<role>) has N skills.`

Dependencies: `clang` or `gcc`.

