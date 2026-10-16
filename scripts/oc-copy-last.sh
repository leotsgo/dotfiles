#!/usr/bin/env bash
# Copy an assistant message's text from a (remote) OpenCode workspace →
# host clipboard. Native-quality text straight from the server API: no
# terminal-grid glyphs, no TUI selection, no OSC 52, no tmux.
# Usage: oc-copy-last.sh [host] [selector]
#   host      default resume-app.devpod
#   selector
#     (absent)    last assistant message of the newest session
#     1, 2, …     n-th-to-last assistant message of the newest session
#     text        most recent assistant message CONTAINING the text,
#                 newest session first
set -euo pipefail
host="${1:-resume-app.devpod}"
selector="${2:-}"
ses_ids=($(ssh "$host" 'opencode api get /api/session' | jq -r '
  .data | sort_by(.time.updated // .time.created // 0)
  | reverse | map(.id)[]'))
extract() { # $1 = a /message JSON blob, $2 = selector
  if [[ "$2" =~ ^[0-9]+$ ]]; then
    jq -r --argjson n "$2" '
      .data | map(select(.type == "assistant")) as $a
      | $a[($a | length) - $n]
      | .content | map(select(.type == "text" and .text != "") | .text)
      | join("\n\n")' <<<"$1"
  else
    jq -r --arg q "$2" '
      .data | map(select(.type == "assistant")) | to_entries
      | map(select([.value.content[]? | select(.type == "text") | .text]
        | join("\n") | contains($q)))
      | last | .value.content
      | map(select(.type == "text" and .text != "") | .text)
      | join("\n\n")' <<<"$1"
  fi
}
for ses in "${ses_ids[@]}"; do
  msg_blob=$(ssh "$host" "opencode api get /api/session/$ses/message")
  texts=$(extract "$msg_blob" "$selector" || true)
  if [ -n "${texts:-}" ]; then
    printf '%s' "$texts" | wl-copy
    echo "copied from session $ses ($(printf '%s' "$texts" | wc -l) lines)"
    exit 0
  fi
done
echo "no match: selector='$selector' host=$host sessions=${#ses_ids[@]}" >&2
exit 1
