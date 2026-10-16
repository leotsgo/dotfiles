#!/usr/bin/env bash
# kitty: copy the selection CLEAN of TUI frame glyphs — box borders (│),
# trailing padding, and edge whitespace are rendered art, not content.
# kitty pass_selection_to_program passes the selection as the last
# command-line arg (fallback: stdin). Bound as ctrl+alt+c; kitty's own
# ctrl+shift+c stays the raw glyph copy.
# ponytail: strips legit │ glyphs anywhere (rare); upgrade to per-app
# markup if it ever bites.
set -euo pipefail
if [ "$#" -gt 0 ]; then sel="${@: -1}"; else sel="$(cat)"; fi
sel="${sel//│/}"
printf '%s' "$sel" | sed -E 's/[[:space:]]+$//' | wl-copy
