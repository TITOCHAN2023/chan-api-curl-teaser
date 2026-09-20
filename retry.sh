#!/usr/bin/env bash
# Usage: bash retry.sh <max_tries> -- <command...>
set -euo pipefail
max="${1:?max tries}"
shift
[[ "${1:-}" == "--" ]] && shift
delay=1
n=1
while true; do
  if "$@"; then
    exit 0
  fi
  code=$?
  if (( n >= max )); then
    exit "$code"
  fi
  sleep "$delay"
  delay=$((delay * 2))
  n=$((n + 1))
done
