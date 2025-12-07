Meta-assembler scaffold: parses a tiny AArch64-like pseudo-asm, applies a couple peephole rewrites, and emits a proof log showing which rules fired. This is a placeholder for a future proof-producing pipeline.

Targets:
- `make build` — rewrite examples into `build/`.
- `make test` — assert rewrites applied.
- `make smoke` — tolerant wrapper.

