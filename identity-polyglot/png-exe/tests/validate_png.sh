#!/usr/bin/env bash
set -euo pipefail

png="${1:-}"
payload="${2:-}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [ -z "$png" ] || [ -z "$payload" ]; then
  echo "usage: $0 polyglot.png payload_bin" >&2
  exit 1
fi

if ! command -v "$payload" >/dev/null 2>&1 && [ ! -x "$payload" ]; then
  echo "payload binary missing"
  exit 1
fi

if [ -f "$ROOT/../../tools/format-validators/pngcheck.sh" ]; then
  "$ROOT/../../tools/format-validators/pngcheck.sh" "$png"
fi

out="$("$payload" "$png")"
orig=$(cat "$png")
if [ "$out" != "$orig" ]; then
  echo "identity check failed"
  exit 1
fi

echo "png identity ok"

