#!/usr/bin/env bash
# kitty port of the old tmux-print flow (C-a P) — needs kitty remote control
# (allow_remote_control socket-only + listen_on in kitty.conf; kitty
# restarted once after that). The selection name differs: no tmux
# command-prompt here, so filenames are always timestamped.
# Target = the globally focused window at press time (os_focused AND
# tab_focused AND win_focused — `win_focused` alone is just "active window
# of its tab", which marks an unfocused tab's window too). The launch is
# --type=background so it never steals focus. Both save dir (recorded cwd
# — /proc cwd lies for devpod/docker-exec panes) and the send destination
# (--match id:… — the default target is the connection's active window)
# come from that single lookup.
# ponytail: recorded cwd assumes container shells don't emit OSC7 with an
# internal path; if that ever bites, resolve the host mount-table instead.
set -euo pipefail

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
wl-paste -t image/png > "$tmp" 2>/dev/null
[ -s "$tmp" ] || exit 0

# socket: own env first, else newest live socket — a kitty restarted from a
# window of the OLD kitty inherits the dead instance's KITTY_LISTEN_ON and
# passes it to children. kitty-mux-restore launches cleaned, this is the belt.
so="$KITTY_LISTEN_ON"
[ -S "${so#unix:}" ] || so="unix:$(find /tmp -maxdepth 1 -type s -name 'kitty-*' -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)"

out="$(kitten @ --to "$so" ls 2>/dev/null | python3 -c '
import json, sys
res = gid = ""
for o in json.load(sys.stdin):
    if not o["is_focused"]: continue
    for t in o["tabs"]:
        if not t.get("is_focused"): continue
        for w in t["windows"]:
            if w["is_focused"]:
                gid, res = w["id"], w["cwd"]
print(gid)
print(res)' 2>/dev/null)" || out=""
gid="$(sed -n 1p <<<"$out")"
lw="$(sed -n 2p <<<"$out")"
[ -d "$lw" ] || lw="$(pwd)"

name="print-$(date +%m%d-%H%M%S).png"
mkdir -p "$lw/.clip"
mv "$tmp" "$lw/.clip/$name"
[ -n "$gid" ] && kitty @ --to "$so" send-text --match "id:$gid" "@.clip/$name"
