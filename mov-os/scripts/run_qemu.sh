#!/usr/bin/env bash
set -euo pipefail
img="${1:-}"
if [ -z "$img" ]; then echo "usage: $0 img"; exit 1; fi
if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
  echo "qemu-system-x86_64 missing; skipping"
  exit 0
fi
qemu-system-x86_64 -drive format=raw,file="$img" -serial stdio -nographic -no-reboot -d guest_errors -display none -boot c -m 64M -monitor none -no-reboot -no-shutdown -smp 1

