#!/usr/bin/env bash
set -euo pipefail
bin="${1:-}"
if [ -z "$bin" ]; then echo "usage: $0 bin"; exit 1; fi
if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
  echo "qemu-system-x86_64 missing; skipping UEFI path"
  exit 0
fi
echo "UEFI path placeholder (would boot OVMF with $bin as image)"
exit 0

