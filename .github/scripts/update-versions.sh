#!/usr/bin/env bash
# Rewrites the DEBOPS_VERSIONS file so it contains the latest
# stable release of the newest $KEEP_SERIES minor series (plus 'main').
# Prints the new value to stdout; edits the versions file in place.
set -euo pipefail

VERSIONS_FILE="${VERSIONS_FILE:-DEBOPS_VERSIONS}"
KEEP_SERIES="${KEEP_SERIES:-3}"
# Optional: file with one tag per line (for testing without network).
TAGS_FILE="${TAGS_FILE:-}"

if [ -n "$TAGS_FILE" ]; then
  TAGS=$(cat "$TAGS_FILE")
else
  TAGS=$(gh api --paginate repos/debops/debops/releases \
    --jq '.[] | select(.prerelease==false and .draft==false) | .tag_name')
fi

# Newest patch of each MAJOR.MINOR series, newest series first.
NEW=$(echo "$TAGS" | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -Vr \
  | awk -F. '!seen[$1"."$2]++' | head -n "$KEEP_SERIES" | tr '\n' ' ')
NEW="main ${NEW% }"

CURRENT=$(cat "$VERSIONS_FILE")
if [ "$CURRENT" = "$NEW" ]; then
  echo "unchanged" >&2
  exit 0
fi

echo "$NEW" > "$VERSIONS_FILE"
echo "$NEW"
