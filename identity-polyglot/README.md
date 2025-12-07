Identity polyglots: media files (PNG/WAV) paired with executables whose payload prints the exact bytes of the media file. These are scaffolds, not size-optimized.

Targets:
- `make build` — generate media files and payload binaries.
- `make test` — validate signatures and identity property.
- `make smoke` — runs tests but skips if python/compiler missing.

Subdirs:
- `png-exe/` — 1x1 PNG + payload that echoes its bytes.
- `wav-elf/` — minimal WAV + payload that echoes its bytes.

