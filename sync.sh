#!/usr/bin/env bash
# Propagate edits in this folder out to the two nanoclaw locations the agent
# actually reads from. Works around nanoclaw's session-dir staleness when the
# container reuses an existing session.

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NANOCLAW="$HOME/projects/nanoclaw"
CONTAINER_DEST="$NANOCLAW/container/skills/letterboxd-watchlist"
SESSION_GROUP="${1:-telegram_main}"
SESSION_DEST="$NANOCLAW/data/sessions/$SESSION_GROUP/.claude/skills/letterboxd-watchlist"

FILES=(lb.js SKILL.md README.md package.json)

if [[ ! -d "$NANOCLAW" ]]; then
  echo "nanoclaw not found at $NANOCLAW — aborting." >&2
  exit 1
fi

mkdir -p "$CONTAINER_DEST"
for f in "${FILES[@]}"; do cp "$SRC/$f" "$CONTAINER_DEST/$f"; done
echo "✓ container/skills/letterboxd-watchlist/ updated"

if [[ -d "$NANOCLAW/data/sessions/$SESSION_GROUP" ]]; then
  mkdir -p "$SESSION_DEST"
  for f in "${FILES[@]}"; do cp "$SRC/$f" "$SESSION_DEST/$f"; done
  echo "✓ data/sessions/$SESSION_GROUP/.claude/skills/letterboxd-watchlist/ updated"
else
  echo "(skipped session sync — no session yet for '$SESSION_GROUP')"
fi
