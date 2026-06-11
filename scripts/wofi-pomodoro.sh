#!/usr/bin/env bash
# uair pomodoro control via wofi  (lives in ~/scripts; tracked in dotfiles).
#   menu:   wofi-pomodoro.sh
#   direct: wofi-pomodoro.sh s5|s10|s20|s30|s60|s90 | toggle | finish | status
#
# NOTE on "start": uair clamps the remaining time on `jump` (never resets UP
# mid-run), so the only reliable way to start a FULL fresh duration is from a
# fresh daemon — hence restart_daemon before jump+resume.
set -u

restart_daemon() {
  if systemctl --user is-active --quiet uair 2>/dev/null; then
    systemctl --user restart uair
  else
    pkill -x uair 2>/dev/null || true
    setsid uair </dev/null >/dev/null 2>&1 &
  fi
  # wait for the control socket
  i=0; while [ "$i" -lt 20 ]; do uairctl fetch '' >/dev/null 2>&1 && break; sleep 0.1; i=$((i+1)); done
}
ensure() { pgrep -x uair >/dev/null 2>&1 || { setsid uair </dev/null >/dev/null 2>&1 & sleep 0.4; }; }

start()  { restart_daemon
           uairctl jump "$1" >/dev/null 2>&1
           uairctl resume    >/dev/null 2>&1
           notify-send -u low "🍅 Pomodoro" "Started ${1#s} min"; }
toggle() { ensure; uairctl toggle 2>/dev/null; }
finish() { ensure; uairctl finish 2>/dev/null; }
status() { ensure; notify-send -u low "🍅 Pomodoro" "$(uairctl fetch '{name} {time}{state}' 2>/dev/null || echo idle)"; }

menu() {
  choice=$(printf '%s\n' \
    "🍅   5 min" \
    "🍅  10 min" \
    "🍅  20 min" \
    "🍅  30 min" \
    "🍅  60 min" \
    "🍅  90 min" \
    "⏸   Pause / Resume" \
    "⏭   Finish" \
    "⏱   Status" \
    | wofi --dmenu --prompt "Pomodoro")
  case "$choice" in
    *"5 min")  start s5  ;;
    *"10 min") start s10 ;;
    *"20 min") start s20 ;;
    *"30 min") start s30 ;;
    *"60 min") start s60 ;;
    *"90 min") start s90 ;;
    *Pause*)   toggle ;;
    *Finish*)  finish ;;
    *Status*)  status ;;
    *)         : ;;
  esac
}

case "${1:-menu}" in
  s5|s10|s20|s30|s60|s90) start "$1" ;;
  toggle) toggle ;;
  finish) finish ;;
  status) status ;;
  menu|"") menu ;;
  *) echo "unknown action: $1" >&2; exit 1 ;;
esac
