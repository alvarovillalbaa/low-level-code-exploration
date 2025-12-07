Format v0:
- [0:4] little-endian uint32 = payload length
- [4:] payload bytes

Security goals (future):
- Length bounds checked before allocation.
- Constant-time w.r.t payload bytes.
- Proof artifacts live in `jasmin/`.

