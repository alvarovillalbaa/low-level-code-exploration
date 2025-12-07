Trimodal APE experiment: single artifact intended to run as APE userland binary, BIOS boot image, and UEFI PE. This scaffold builds a simple hello binary and provides QEMU scripts with graceful skip when deps are missing.

Targets:
- `make build` — compile `build/trimodal.com` (regular ELF for now).
- `make test` — run Linux path locally; BIOS/UEFI scripts run only if QEMU present.
- `make smoke` — tolerant wrapper.

See `ape-layout.md` for notes on intended layout work.

