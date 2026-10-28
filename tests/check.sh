#!/bin/bash
# Non-destructive smoke checks. Never calls the reset subcommand on macOS.
set -euo pipefail
cd "$(dirname "$0")/.."
/bin/bash -n scripts/displaylink-memory.sh
/bin/bash scripts/displaylink-memory.sh help >/dev/null
expect_usage_error() {
  local code=0
  /bin/bash scripts/displaylink-memory.sh "$@" >/dev/null 2>&1 || code=$?
  [ "$code" -eq 2 ] || { printf 'Unexpected usage exit: %s\n' "$code" >&2; exit 1; }
}
expect_usage_error invalid
expect_usage_error diagnose extra
if [ "$(uname -s)" != Darwin ]; then
  for action in diagnose reset; do
    code=0
    /bin/bash scripts/displaylink-memory.sh "$action" </dev/null >/dev/null 2>&1 || code=$?
    [ "$code" -eq 1 ] || exit 1
  done
fi
printf '%s\n' 'PASS: syntax, help, argument validation, and (on non-macOS) platform refusal.'
