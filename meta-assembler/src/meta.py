#!/usr/bin/env python3
"""
Minimal meta-assembler: parse lines, apply rewrites, emit transformed asm and log.
"""
import sys, pathlib
from rewrites.simple import apply_rewrites
from proof_export.logger import Logger

def parse_lines(path):
    lines = []
    for line in pathlib.Path(path).read_text().splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith(";"):
            continue
        lines.append(stripped)
    return lines

def main(inp, out_path, log_path):
    logger = Logger()
    lines = parse_lines(inp)
    rewritten = apply_rewrites(lines, logger)
    pathlib.Path(out_path).parent.mkdir(parents=True, exist_ok=True)
    pathlib.Path(log_path).parent.mkdir(parents=True, exist_ok=True)
    pathlib.Path(out_path).write_text("\n".join(rewritten) + "\n")
    pathlib.Path(log_path).write_text("\n".join(logger.lines) + "\n")
    print(f"wrote {out_path} and {log_path}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        raise SystemExit("usage: meta.py input.asm output.asm proof.log")
    main(sys.argv[1], sys.argv[2], sys.argv[3])

