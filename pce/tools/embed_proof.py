#!/usr/bin/env python3
import sys, struct, pathlib

MARK = b"PCEPROOF"

def embed(bin_path, proof_path, out_path):
    b = pathlib.Path(bin_path).read_bytes()
    p = pathlib.Path(proof_path).read_bytes()
    with open(out_path, "wb") as f:
        f.write(b)
        f.write(p)  # proof first
        f.write(MARK)
        f.write(struct.pack("<I", len(p)))
    print(f"embedded proof ({len(p)} bytes) into {out_path}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        raise SystemExit("usage: embed_proof.py binary proof out")
    embed(sys.argv[1], sys.argv[2], sys.argv[3])

