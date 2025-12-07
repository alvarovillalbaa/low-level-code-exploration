Proof-Carrying Executables (PCE) scaffold. Adds a `.pceproof` trailer with a tiny marker and length, plus a verifier that checks the marker and prints proof bytes.

Format v0:
- Original binary bytes
- ASCII marker `PCEPROOF`
- u32 little-endian proof length
- proof bytes

Targets:
- `make build` — compile verifier and embed example.
- `make test` — run verifier on example.
- `make smoke` — tolerant wrapper.

