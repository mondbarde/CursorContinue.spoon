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

# Installer script inside the .spoon for double-click install
cat > "$SPOON_DIR/install.command" <<'EOS'
#!/usr/bin/env bash
set -euo pipefail

SPOON_NAME="CursorContinue.spoon"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

TARGET_PARENT="$HOME/.hammerspoon/Spoons"
TARGET_DIR="$TARGET_PARENT/$SPOON_NAME"

mkdir -p "$TARGET_PARENT"
rm -rf "$TARGET_DIR"
cp -R "$SCRIPT_DIR" "$TARGET_DIR"

INIT_LUA="$HOME/.hammerspoon/init.lua"
if [ ! -f "$INIT_LUA" ]; then
  mkdir -p "$HOME/.hammerspoon"
  touch "$INIT_LUA"
fi

if ! grep -q 'hs.loadSpoon("CursorContinue")' "$INIT_LUA"; then
  cat >> "$INIT_LUA" <<'LUA'
-- CursorContinue.spoon
hs.loadSpoon("CursorContinue")
spoon.CursorContinue:start()
LUA
fi

if command -v hs >/dev/null 2>&1; then
  hs -c 'hs.reload()' || true
fi

open -a Hammerspoon || true
echo "Installed to $TARGET_DIR"
echo "If Hammerspoon is running, reload config if not auto-reloaded."
EOS

chmod +x "$SPOON_DIR/install.command"

ZIP_NAME="${NAME}.spoon.zip"
(cd "$ROOT_DIR" && zip -r "dist/${ZIP_NAME}" "${NAME}.spoon" > /dev/null)

echo "Built: $OUT_DIR/$ZIP_NAME"

