#!/bin/bash
# Manual, narrowly scoped workaround. No persistence, uploads, or downloads.
set -euo pipefail
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
export LC_ALL=C
umask 077
readonly SERVICE='system/com.displaylink.DisplayLinkManager.PrivilegedHelper'
readonly APP='/Applications/DisplayLink Manager.app'

usage() {
  printf '%s\n' 'Usage: bash scripts/displaylink-memory.sh [diagnose|reset|help]' \
    'diagnose: print only OS/app version, helper PID and memory columns (default).' \
    'reset: ask for confirmation, then restart only the DisplayLink system helper.' \
    'No automatic restarts. External displays may briefly blink during reset.'
}
fail() { printf '%s\n' "$1" >&2; exit 1; }
[ "$#" -le 1 ] || { usage >&2; exit 2; }
case "${1:-diagnose}" in
  help|-h|--help) usage; exit 0 ;;
  diagnose|reset) action="${1:-diagnose}" ;;
  *) usage >&2; exit 2 ;;
esac
[ "$(/usr/bin/uname -s)" = Darwin ] || fail 'This workaround supports macOS only.'

helper_pid() {
  local info pid
  info=$(/bin/launchctl print "$SERVICE" 2>/dev/null) || fail 'DisplayLink system helper is not registered/running.'
  pid=$(printf '%s\n' "$info" | /usr/bin/awk '$1 == "pid" && $2 == "=" {print $3; exit}')
  case "$pid" in ''|*[!0-9]*) fail 'Could not determine a numeric helper PID.' ;; esac
  [ "$pid" -gt 1 ] || fail 'Refusing an invalid helper PID.'
  printf '%s\n' "$pid"
}

diagnose() {
  local pid
  pid=$(helper_pid) || return 1
  printf 'macOS: %s\n' "$(/usr/bin/sw_vers -productVersion)"
  printf 'DisplayLink Manager: %s\n' "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP/Contents/Info.plist" 2>/dev/null || printf unknown)"
  printf 'Helper PID: %s\n' "$pid"
  # Suppress top's machine-wide summary and unrelated processes.
  /usr/bin/top -l 1 -pid "$pid" -stats pid,command,mem,cmprs |
    /usr/bin/awk -v target="$pid" '$1 == "PID" || $1 == target { print }'
}

if [ "$action" = diagnose ]; then
  diagnose
  exit 0
fi
# Confirm the service exists before requesting privileges.
helper_pid >/dev/null
printf '%s\n' 'This restarts only the DisplayLink helper. Displays may briefly blink.'
printf 'Type RESET to continue: '
IFS= read -r answer || fail 'Cancelled; no service was changed.'
[ "$answer" = RESET ] || fail 'Cancelled; no service was changed.'
# Only the fixed Apple command crosses the privilege boundary. Never run this
# whole script as root; never pass caller-supplied strings to sudo or launchctl.
/usr/bin/sudo /bin/launchctl kickstart -k system/com.displaylink.DisplayLinkManager.PrivilegedHelper
printf '%s\n' 'Restart requested. If verification fails, wait a moment and run diagnose.'
diagnose
