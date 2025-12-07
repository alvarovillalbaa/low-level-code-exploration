MOV-only OS service experiment. Bootable image placeholder that currently emits a zeroed boot sector with a halt loop; later replaced by movfuscator-produced payload.

Targets:
- `make build` — create `build/mov-os.img` via script.
- `make test` — run QEMU if present.
- `make smoke` — tolerant wrapper.

