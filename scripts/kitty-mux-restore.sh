#!/usr/bin/env bash
# kitty resurrection, restore side (the reboot story):
#   kitty --session ~/.local/share/kitty-mux/session.kitty
# Opens a FRESH kitty instance playing back the saved session — run it after
# a reboot or from any shell. Does not touch the running kitty instance.
set -euo pipefail
file="$HOME/.local/share/kitty-mux/session.kitty"
[ -s "$file" ] || { echo "no session saved yet: run kitty-mux-save.py first"; exit 1; }
# from a dead kitty's window: clean the poisoned env so the new instance
# never inherits a stale KITTY_LISTEN_ON/KITTY_PID.
nohup env -u KITTY_PID -u KITTY_LISTEN_ON kitty --session "$file" >/dev/null 2>&1 &
disown
echo "restoring from $file"
