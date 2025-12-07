Format v0 (trailer):
- Original executable bytes
- Proof payload
- Marker: ASCII `PCEPROOF`
- u32 little-endian proof length

Verifier should:
- Seek to end, read marker/length, ensure bounds.
- Optionally hash or parse proof (left as future work).

