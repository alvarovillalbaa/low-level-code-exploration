#!/usr/bin/env bash
set -euo pipefail
decomp="${1:-}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKER="$ROOT/packer/pack.py"
mkdir -p "$ROOT/build"
TMP="$(mktemp "$ROOT/build/test.XXXX.pck")"
SAMPLE="$ROOT/tests/sample.txt"

if [ -z "$decomp" ] || [ ! -x "$decomp" ]; then
  echo "usage: $0 path/to/decompressor" >&2
  exit 1
fi

python3 "$PACKER" "$SAMPLE" "$TMP"
out="$("$decomp" "$TMP")"
orig=$(cat "$SAMPLE")
if [ "$out" != "$orig" ]; then
  echo "equivalence failed"
  exit 1
fi
echo "equivalence ok"

