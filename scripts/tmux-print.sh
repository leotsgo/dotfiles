#!/usr/bin/env bash
# Usage: tmux-print.sh <pane_id> [name]
# Paste the clipboard image into the focused pane as an @-attachment.
# Writes the PNG to the pane's cwd/.clip/<name or timestamp>.png (the
# bind-mounted workspace, so devcontainer sessions see the same path) and
# types "@.clip/<file>" into the pane — OpenCode's composer picker narrows
# to it; Enter attaches. Invalid/empty name → timestamp. Existing name
# gets a -HHMMSS suffix instead of overwriting.
# Non-image or empty clipboard: exits silently, nothing typed.
# ponytail: whole-cwd scheme, no repo-subdir path fixing; upgrade if cd'ing
# deeper than the repo root before printing becomes the norm.
set -euo pipefail

pane="${1:?usage: tmux-print.sh <pane_id> [name]}"
cwd="$(tmux display-message -p -t "$pane" '#{pane_current_path}')"

name="${2:-}"
[[ "$name" =~ ^[A-Za-z0-9._-]+$ ]] || name=""
[ -n "$name" ] || name="print-$(date +%m%d-%H%M%S)"
file="$name.png"
if [ -e "$cwd/.clip/$file" ]; then file="${file%.png}-$(date +%H%M%S).png"; fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
wl-paste -t image/png > "$tmp" 2>/dev/null
[ -s "$tmp" ] || exit 0

mkdir -p "$cwd/.clip"
mv "$tmp" "$cwd/.clip/$file"
tmux send-keys -t "$pane" -l "@.clip/$file"
