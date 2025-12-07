#!/usr/bin/env bash
set -euo pipefail

file="${1:-}"
if [ -z "$file" ]; then
  echo "usage: $0 path/to/file" >&2
  exit 1
fi

if ! command -v readelf >/dev/null 2>&1; then
  echo "readelf not installed; skipping."
  exit 0
fi

readelf -h "$file"

