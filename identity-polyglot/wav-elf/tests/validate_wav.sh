#!/usr/bin/env bash
set -euo pipefail

wav="${1:-}"
payload="${2:-}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [ -z "$wav" ] || [ -z "$payload" ]; then
  echo "usage: $0 polyglot.wav payload_bin" >&2
  exit 1
fi

if [ -f "$ROOT/../../tools/format-validators/wavcheck.sh" ]; then
  "$ROOT/../../tools/format-validators/wavcheck.sh" "$wav"
fi

out="$("$payload" "$wav")"
orig=$(cat "$wav")
if [ "$out" != "$orig" ]; then
  echo "identity check failed"
  exit 1
fi

echo "wav identity ok"

