#!/usr/bin/env bash
set -euo pipefail

file="${1:-}"
if [ -z "$file" ]; then
  echo "usage: $0 path/to/file.wav" >&2
  exit 1
fi

python3 - "$file" <<'PY'
import struct, sys

path = sys.argv[1]
with open(path, "rb") as f:
    data = f.read(44)

if len(data) < 44 or data[:4] != b"RIFF" or data[8:12] != b"WAVE":
    print("invalid WAV header")
    sys.exit(1)

chunk_id, size, fmt = struct.unpack("<4sI4s", data[:12])
print(f"ok WAV header, size field={size}")
PY

