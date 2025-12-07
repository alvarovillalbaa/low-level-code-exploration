#!/usr/bin/env python3
"""
Emit a 512-byte boot sector with a simple hlt loop and 0xAA55 signature.
"""
import sys, pathlib

def main(out_path):
    buf = bytearray(512)
    # infinite loop: cli; hlt; jmp $
    buf[0:4] = bytes([0xfa, 0xf4, 0xeb, 0xfe])
    buf[510] = 0x55
    buf[511] = 0xaa
    p = pathlib.Path(out_path)
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_bytes(buf)
    print(f"wrote boot image {p} ({len(buf)} bytes)")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: build_image.sh out.img")
    main(sys.argv[1])

