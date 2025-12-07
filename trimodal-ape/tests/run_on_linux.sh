#!/usr/bin/env bash
set -euo pipefail
bin="${1:-}"
if [ -z "$bin" ]; then echo "usage: $0 bin"; exit 1; fi
"$bin" >/dev/null
echo "linux run ok"

