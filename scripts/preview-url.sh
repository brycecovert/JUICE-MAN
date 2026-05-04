#!/usr/bin/env bash
# Generate preview URL for a JUICE-MAN version file
# Usage: ./scripts/preview-url.sh levels/level_1_v1.md

set -euo pipefail

FILE="${1:-}"
BRANCH="${2:-$(git branch --show-current 2>/dev/null || echo 'main')}"
REPO="${3:-brycecovert/JUICE-MAN}"

if [ -z "$FILE" ]; then
  echo "Usage: $0 <file-path> [branch] [repo]"
  echo "Example: $0 levels/level_1_v1.html"
  exit 1
fi

# Convert to raw GitHub URL
RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/${FILE}"

# HTML Preview services
PREVIEW_URL="https://htmlpreview.github.io/?${RAW_URL}"
GITHACK_URL="https://raw.githack.com/${REPO}/${BRANCH}/${FILE}"

echo "=== JUICE-MAN Preview URLs ==="
echo "File: $FILE"
echo "Branch: $BRANCH"
echo ""
echo "HTMLPreview: $PREVIEW_URL"
echo "GitHack:     $GITHACK_URL"
echo "Raw:         $RAW_URL"
