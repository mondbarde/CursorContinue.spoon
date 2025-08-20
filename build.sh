#!/usr/bin/env bash
set -euo pipefail

NAME="CursorContinue"
VERSION="${1:-}"

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$ROOT_DIR/dist"
SPOON_DIR="$ROOT_DIR/${NAME}.spoon"

rm -rf "$OUT_DIR" "$SPOON_DIR"
mkdir -p "$OUT_DIR" "$SPOON_DIR"

# Copy spoon runtime files
cp "$ROOT_DIR/init.lua" "$SPOON_DIR/"
cp "$ROOT_DIR/LICENSE" "$SPOON_DIR/"
cp "$ROOT_DIR/README.md" "$SPOON_DIR/"

# Optional metadata (for Hammerspoon SpoonInstall friendliness)
cat > "$SPOON_DIR/README.json" <<EOF
{
  "name": "${NAME}",
  "version": "${VERSION}",
  "author": "Vincent J Lim & contributors",
  "homepage": "https://github.com/${GITHUB_REPOSITORY:-vincentjlim/go_ahead}",
  "license": "MIT",
  "desc": "Double-Enter to send phrase in Cursor chat"
}
EOF

ZIP_NAME="${NAME}.spoon.zip"
(cd "$ROOT_DIR" && zip -r "dist/${ZIP_NAME}" "${NAME}.spoon" > /dev/null)

echo "Built: $OUT_DIR/$ZIP_NAME"

