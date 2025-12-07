#!/usr/bin/env python3
import sys, zlib, struct, hashlib

def chunk(tag, data):
    return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

def gen_png():
    width = height = 1
    ihdr = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    raw = b"\x00" + b"\x00\x00\x00"  # single black pixel
    idat = zlib.compress(raw)
    return b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", idat) + chunk(b"IEND", b"")

def main(out_path):
    png = gen_png()
    with open(out_path, "wb") as f:
        f.write(png)
    print(f"wrote {out_path} ({len(png)} bytes, sha256={hashlib.sha256(png).hexdigest()})")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("usage: gen_polyglot.py out.png", file=sys.stderr)
        sys.exit(1)
    main(sys.argv[1])

