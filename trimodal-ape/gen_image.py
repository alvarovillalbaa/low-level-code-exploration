#!/usr/bin/env python3
"""
Placeholder generator: copies the built ELF to trimodal.com until real APE/BIOS/UEFI packing is implemented.
"""
import shutil, sys, pathlib

def main(src, dst):
    psrc, pdst = pathlib.Path(src), pathlib.Path(dst)
    if not psrc.exists():
        raise SystemExit(f"missing input {psrc}")
    shutil.copy(psrc, pdst)
    print(f"copied {psrc} -> {pdst}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: gen_image.py built_binary out_image", file=sys.stderr)
        raise SystemExit(1)
    main(sys.argv[1], sys.argv[2])

