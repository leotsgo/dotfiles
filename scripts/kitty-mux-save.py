#!/usr/bin/env python3
"""kitty resurrection, save side — the kitty equivalent of tmux resurrect +
continuum. Dumps the CURRENT kitty (tabs, titles, cwd, commands) to a kitty
session file for `kitty --session` restore.

Runs from a kitty map binding (KITTY_LISTEN_ON set) or discovers the newest
RESPONDING kitty listen socket from anywhere (systemd timer). Restored
windows are rerun: opencode windows get `opencode`, ssh windows get their
ssh line, plain windows get the default shell. Run state beyond the window
itself is not resurrected — same contract as tmux resurrect.
"""
import glob
import json
import os
import subprocess
import sys

OUT = os.path.expanduser("~/.local/share/kitty-mux/session.kitty")


def q(s: str) -> str:
    # launch parses its args shlex-style, so single quotes are correct there
    return "'" + s.replace("'", "'\\''") + "'"


def classify(cmdline):
    cl = " ".join(cmdline) if isinstance(cmdline, list) else str(cmdline)
    if "opencode" in cl:
        return "opencode"
    if cl.startswith("ssh "):
        return cl
    return None  # default shell with the restored cwd


# discover the socket: explicit env first, else probe newest-first and stop
# at the first RESPONDING kitty (stale sockets from dead instances linger)
sock = os.environ.get("KITTY_LISTEN_ON")
raw_out = None
if sock:
    probe = subprocess.run(
        ["kitty", "@", "--to", sock, "ls"], capture_output=True, text=True
    )
    if probe.returncode != 0:
        sys.exit(f"kitty @ ls failed on {sock}: {probe.stderr.strip()}")
    raw_out = probe.stdout
else:
    socks = sorted(glob.glob("/tmp/kitty-*"), key=os.path.getmtime)
    if not socks:
        sys.exit(
            "no kitty socket found — kitty needs a full restart after "
            "listen_on was added to kitty.conf"
        )
    for cand in reversed(socks):
        probe = subprocess.run(
            ["kitty", "@", "--to", "unix:" + cand, "ls"],
            capture_output=True, text=True,
        )
        if probe.returncode == 0:
            raw_out = probe.stdout
            break
    else:
        sys.exit("no RESPONDING kitty socket (all sockets stale)")

lines = []
for osw in json.loads(raw_out):
    first = True
    for tab in osw.get("tabs", []):
        # new_tab parses its title as the RAW line remainder (no quote
        # stripping) — emit it bare; spaces are fine, quotes would be literal
        title = tab.get("title") or ""
        lines.append(("new_tab " + title).strip())
        for w in tab.get("windows", []):
            flags = [] if first else ["--type=window"]
            first = False
            cwd = w.get("cwd") or os.getcwd()
            cmd = classify(w.get("cmdline", []))
            lin = ["launch", *flags, "--cwd", q(cwd)]
            if w.get("title"):
                lin += ["--title", q(w["title"])]
            if cmd:
                lin.append(cmd)
            lines.append(" ".join(lin))

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, "w") as f:
    f.write("\n".join(lines).strip() + "\n")
print(f"saved {OUT} ({sum(1 for l in lines if l.startswith('new_tab'))} tabs)")
