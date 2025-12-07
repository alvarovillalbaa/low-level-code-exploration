#!/usr/bin/env python3
import sys, struct, pathlib

def pack(inp, out):
    data = pathlib.Path(inp).read_bytes()
    with open(out, "wb") as f:
        f.write(struct.pack("<I", len(data)))
        f.write(data)
    print(f"packed {inp} -> {out} ({len(data)} bytes payload)")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("usage: pack.py input output")
    pack(sys.argv[1], sys.argv[2])

