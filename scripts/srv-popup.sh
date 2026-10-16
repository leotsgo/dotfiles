#!/usr/bin/env bash
# kitty port of the tmux C-a S popup — NO tmux involved.
# Opens an overlay attached to a PERSISTENT per-project session
# (abduco/dtach socket under ~/.cache/kitty-srv/). Close the overlay freely;
# the session — your dev servers — keeps running. Reopen with the same keys
# to reattach; list live ones with `ls ~/.cache/kitty-srv/*.sock`; retire
# one by closing its shell (Ctrl+D in the session).
# No scrollback server-side: after reattaching, the history you see is what
# kitty buffered while the overlay was open.
# ponytail: backend auto-picks abduco or dtach — both are one-binary
# attach/reattach tools; upgrade to a real supervisor if servers need
# multi-window or scrollback persistence.
set -euo pipefail
p="$(basename "$PWD")"
dir="$HOME/.cache/kitty-srv"
mkdir -p "$dir"
sock="$dir/srv-$p.sock"

if command -v abduco >/dev/null 2>&1; then
  # bash --noprofile --norc = a bare prompt (bash-5.2$), so the overlay is
# VISIBLY distinct from the pane shell behind it (p10k) — this is the
# "you are in the server session" cue. Ctrl+D here = shell exits → closes
# the overlay; the SESSION keeps running detached on its socket.
exec abduco -A "$sock" bash --noprofile --norc
elif command -v dtach >/dev/null 2>&1; then
  exec dtach -A "$sock" zsh
else
  echo "backend missing — install one:"
  echo "  sudo pacman -S abduco    # or: sudo pacman -S dtach"
  exit 1
fi
