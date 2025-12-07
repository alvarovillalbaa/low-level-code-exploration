#!/usr/bin/env bash
set -euo pipefail

file="${1:-}"
if [ -z "$file" ]; then
  echo "usage: $0 binary" >&2
  exit 1
fi

if ! command -v objdump >/dev/null 2>&1; then
  echo "objdump not installed; skipping."
  exit 0
fi

objdump -Mintel -D "$file" | head -n 200

