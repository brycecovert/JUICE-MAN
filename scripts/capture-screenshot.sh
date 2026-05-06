#!/usr/bin/env bash
# Browser validation script for JUICE-MAN HTML files
# Usage: ./scripts/capture-screenshot.sh levels/level_1.html [output-dir] [output-prefix]

set -euo pipefail

HTML_FILE="${1:-}"
OUTPUT_DIR="${2:-.}"
OUTPUT_PREFIX="${3:-}"

if [ -z "$HTML_FILE" ]; then
  echo "Usage: $0 <html-file> [output-dir] [output-prefix]"
  echo "Example: $0 levels/level_1.html"
  echo "Example: $0 levels/level_1.html screenshots/level_1 level_1_v1"
  exit 1
fi

if [ ! -f "$HTML_FILE" ]; then
  echo "ERROR: HTML file not found: $HTML_FILE"
  exit 1
fi

# Resolve to absolute path for file:// URL
HTML_FILE=$(realpath "$HTML_FILE")
BASENAME=$(basename "$HTML_FILE" .html)

if [ -n "$OUTPUT_PREFIX" ]; then
  SCREENSHOT="${OUTPUT_DIR}/${OUTPUT_PREFIX}.png"
  VIDEO="${OUTPUT_DIR}/${OUTPUT_PREFIX}.webm"
  ERROR_LOG="${OUTPUT_DIR}/${OUTPUT_PREFIX}-errors.txt"
else
  TIMESTAMP=$(date +%s)
  SCREENSHOT="${OUTPUT_DIR}/${BASENAME}-screenshot-${TIMESTAMP}.png"
  VIDEO="${OUTPUT_DIR}/${BASENAME}-video-${TIMESTAMP}.webm"
  ERROR_LOG="${OUTPUT_DIR}/${BASENAME}-errors-${TIMESTAMP}.txt"
fi

mkdir -p "$OUTPUT_DIR"

echo "=== JUICE-MAN Browser Validation ==="
echo "File: $HTML_FILE"
echo "Screenshot: $SCREENSHOT"
echo "Video: $VIDEO"
echo ""

# Clear previous errors
agent-browser errors --clear 2>/dev/null || true

# Open the HTML file
echo "-> Opening in browser..."
agent-browser --allow-file-access open "file://${HTML_FILE}"

# Wait for page to load
echo "-> Waiting for page load..."
agent-browser wait 1000

# Start video recording
echo "-> Starting video recording..."
agent-browser record start "$VIDEO"

# Press Space to start the game
echo "-> Pressing Space to start game..."
agent-browser press " "

# Wait for game to react
echo "-> Waiting for game to start..."
agent-browser wait 1000

# Move right, then down to show gameplay
echo "-> Pressing Right arrow..."
agent-browser press ArrowRight
agent-browser wait 2400
echo "-> Pressing Down arrow..."
agent-browser press ArrowDown
agent-browser wait 1000
agent-browser press ArrowLeft
agent-browser wait 2000

# Stop video recording
echo "-> Stopping video recording..."
agent-browser record stop
echo "Video saved: $VIDEO"

# Take screenshot
echo "-> Capturing screenshot..."
agent-browser screenshot "$SCREENSHOT"
echo "Screenshot saved: $SCREENSHOT"

# Check for JavaScript errors
echo "-> Checking for JavaScript errors..."
ERRORS=$(agent-browser errors 2>&1) || true

if [ -n "$ERRORS" ] && [ "$ERRORS" != "No errors found" ]; then
  echo "$ERRORS" > "$ERROR_LOG"
  echo ""
  echo "FAIL: JavaScript errors detected:"
  echo "$ERRORS"
  echo ""
  echo "Errors saved: $ERROR_LOG"
  exit 1
else
  echo "$ERRORS" > "$ERROR_LOG"
  echo "PASS: No JavaScript errors"
fi

echo ""
echo "=== Validation complete ==="
