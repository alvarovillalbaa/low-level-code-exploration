#!/usr/bin/env python3
import sys, struct, hashlib

def gen_wav():
    sample_rate = 8000
    samples = [0, 0, 0, 0]
    data = b"".join(struct.pack("<h", s) for s in samples)
    byte_rate = sample_rate * 2
    block_align = 2
    bits_per_sample = 16

    riff_size = 36 + len(data)
    header = [
        b"RIFF",
        struct.pack("<I", riff_size),
        b"WAVE",
        b"fmt ", struct.pack("<I", 16),
        struct.pack("<HHIIHH", 1, 1, sample_rate, byte_rate, block_align, bits_per_sample),
        b"data", struct.pack("<I", len(data))
    ]
    return b"".join(header) + data

def main(out_path):
    wav = gen_wav()
    with open(out_path, "wb") as f:
        f.write(wav)
    print(f"wrote {out_path} ({len(wav)} bytes, sha256={hashlib.sha256(wav).hexdigest()})")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("usage: gen_polyglot.py out.wav", file=sys.stderr)
        sys.exit(1)
    main(sys.argv[1])

