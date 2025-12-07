Cross-ISA same-bytes scaffold. Current artifact is a tiny byte sequence intended for future overlapping encodings; tests only assert presence and provide QEMU hooks that skip when missing.

Targets:
- `make build` — emit `build/polyglot.bin`.
- `make test` — run QEMU scripts (skip without qemu).
- `make smoke` — tolerant wrapper.

