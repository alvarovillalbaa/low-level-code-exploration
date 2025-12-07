# weird-binaries

A playground of finished, demonstrable low-level experiments: polyglot binaries, loader oddities, verified packers, tiny parsers, and MOV-only boot toys. Each subproject ships with a README, build/test/demo targets, and validation scripts.

## Layout

- `docs/init.md` — original sequencing/requirements document.
- `tools/` — shared helpers for format validation, disassembly, and timing harness.
- `trimodal-ape/` — APE/Bios/UEFI tri-boot artifact.
- `cross-isa-same-bytes/` — x86-64 ↔ RISC-V same-bytes demo.
- `identity-polyglot/` — PNG/EXE and WAV/ELF identity files.
- `mov-os/` — MOV-only bootable service.
- `parser-1kb/` — ≤1 KiB parser demo.
- `verified-packer/` — formally-inclined packer scaffold.
- `pce/` — proof-carrying executables prototype.
- `meta-assembler/` — peephole/e-graph rewrites with proof logs.
- `.github/workflows/ci.yml` — CI smoke.

## Quickstart

```bash
make help        # show targets
make tools-check # optional sanity of local deps
make smoke       # light, dependency-checked demos
```

Heavy runs (QEMU, pngcheck, movfuscator) are guarded; scripts skip gracefully when missing.