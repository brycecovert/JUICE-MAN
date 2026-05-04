#!/usr/bin/env bash
# Local validation script for JUICE-MAN specs
# Usage: ./scripts/validate-spec.sh specs/level_1/v1.md

set -euo pipefail

SPEC_FILE="${1:-}"

if [ -z "$SPEC_FILE" ]; then
  echo "Usage: $0 <spec-file>"
  echo "Example: $0 specs/level_1/v1.md"
  exit 1
fi

if [ ! -f "$SPEC_FILE" ]; then
  echo "ERROR: Spec file not found: $SPEC_FILE"
  exit 1
fi

echo "=== JUICE-MAN Spec Validation ==="
echo "File: $SPEC_FILE"

# Extract level and version from path
if [[ "$SPEC_FILE" =~ ^specs/level_([0-9]+)/v([0-9]+)\.md$ ]]; then
  LEVEL="${BASH_REMATCH[1]}"
  VERSION="${BASH_REMATCH[2]}"
  echo "Level: $LEVEL"
  echo "Version: $VERSION"
else
  echo "ERROR: Invalid spec file path. Expected: specs/level_N/vN.md"
  exit 1
fi

# Check word count
WORD_COUNT=$(wc -w < "$SPEC_FILE")
echo "Word count: $WORD_COUNT"
if [ "$WORD_COUNT" -gt 300 ]; then
  echo "FAIL: Spec exceeds 300 words (found $WORD_COUNT)"
  exit 1
fi
echo "PASS: Word count OK ($WORD_COUNT ≤ 300)"

# Check version matches next_version
NEXT_VERSION_FILE="specs/level_${LEVEL}/next_version"
if [ -f "$NEXT_VERSION_FILE" ]; then
  EXPECTED_VERSION=$(cat "$NEXT_VERSION_FILE" | tr -d '[:space:]')
  echo "Expected version: $EXPECTED_VERSION"
  echo "PR version: $VERSION"
  if [ "$VERSION" != "$EXPECTED_VERSION" ]; then
    echo "FAIL: Version mismatch. Expected v${EXPECTED_VERSION}, got v${VERSION}"
    exit 1
  fi
  echo "PASS: Version match OK"
else
  echo "WARNING: next_version file not found: $NEXT_VERSION_FILE"
fi

# Check for previous version
CANONICAL_FILE="levels/level_${LEVEL}.html"
if [ -f "$CANONICAL_FILE" ]; then
  echo "Previous version found: $CANONICAL_FILE"
else
  echo "WARNING: Previous version not found: $CANONICAL_FILE"
fi

echo ""
echo "=== All validations passed ==="
