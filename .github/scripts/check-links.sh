#!/usr/bin/env bash
# Fails when a relative Markdown link points at a file that does not exist.
#
# GitBook renders SUMMARY.md and every page from these files, so a moved or
# misspelled page shows up as a dead link in the published docs. External
# URLs and in-page anchors are not checked.
set -euo pipefail

broken=0
while IFS= read -r -d '' file; do
  dir=$(dirname "$file")
  while IFS= read -r target; do
    case "$target" in
      http://* | https://* | mailto:* | '#'*) continue ;;
    esac
    path="${target%%#*}"
    [ -z "$path" ] && continue
    if [ ! -e "$dir/$path" ]; then
      echo "$file: broken link -> $target"
      broken=$((broken + 1))
    fi
  done < <(grep -oE '\]\([^)[:space:]]+\)' "$file" | sed -E 's/^\]\(//; s/\)$//' || true)
done < <(find . -name '*.md' -not -path './.git/*' -not -path './node_modules/*' -print0)

if [ "$broken" -gt 0 ]; then
  echo "$broken broken link(s)"
  exit 1
fi
echo "all relative links resolve"
