Verified packer scaffold: defines a tiny packed format and stub decompressor. Formal proofs are not present yet; Jasmin/Vale directory holds placeholders for future proofs.

Format v0 (trivial):
- u32 little-endian: original size
- raw bytes of payload (no compression)

Targets:
- `make build` — build `build/decompressor`.
- `make test` — pack/unpack a sample and diff.
- `make smoke` — tolerant wrapper.

