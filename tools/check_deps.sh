#!/usr/bin/env bash
set -euo pipefail

missing=0
check_opt() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[warn] $1 not found (optional)"
    missing=1
  else
    echo "[ok] $1"
  fi
}

echo "Checking optional deps (skipping installs)..."
for bin in qemu-system-x86_64 qemu-system-riscv64 pngcheck objdump nasm clang gcc python3; do
  check_opt "$bin"
done

exit 0

