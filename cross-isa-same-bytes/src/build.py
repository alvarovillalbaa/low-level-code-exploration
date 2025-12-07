#!/usr/bin/env python3
"""
Emit a toy byte sequence as placeholder polyglot:
- x86-64: NOP; NOP; RET; INT3 padding
- RV64: interprets as harmless illegal instructions; goal is to replace later.
"""
import sys, pathlib

def main(out_path):
    data = bytes([0x90, 0x90, 0xc3, 0x00])  # placeholder
    p = pathlib.Path(out_path)
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_bytes(data)
    print(f"wrote {p} ({len(data)} bytes)")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: build.py out.bin")
    main(sys.argv[1])

