#!/usr/bin/env bash
set -euo pipefail

file="${1:-}"
if [ -z "$file" ]; then
  echo "usage: $0 path/to/file.png" >&2
  exit 1
fi

if ! command -v pngcheck >/dev/null 2>&1; then
  echo "pngcheck not installed; skipping."
  exit 0
fi

pngcheck "$file"

