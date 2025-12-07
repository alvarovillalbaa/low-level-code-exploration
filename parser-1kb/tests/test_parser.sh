#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT/build/parser"

if [ ! -x "$BIN" ]; then
  echo "parser binary missing"
  exit 1
fi

out="$("$BIN" < "$ROOT/samples/sample1.txt")"
if [ "$out" != "Alice (Engineer) has 3 skills." ]; then
  echo "unexpected output: $out"
  exit 1
fi

size=$(wc -c < "$BIN")
echo "binary size: $size bytes"
if [ "${STRICT_SIZE:-0}" = "1" ] && [ "$size" -gt 1024 ]; then
  echo "binary exceeds 1024 bytes"
  exit 1
fi

echo "ok"

