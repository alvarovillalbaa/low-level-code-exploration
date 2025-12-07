#!/usr/bin/env bash
set -euo pipefail
bin="${1:-}"
if [ -z "$bin" ]; then echo "usage: $0 bin"; exit 1; fi
if ! command -v qemu-system-riscv64 >/dev/null 2>&1; then
  echo "qemu-system-riscv64 missing; skipping"
  exit 0
fi
echo "rv64 placeholder run for $bin (real boot path pending)"

