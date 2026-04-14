#!/usr/bin/env bash
# Install Alacritty config files from this repo into ~/.config/alacritty.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_ROOT/alacritty"
DEST_DIR="${HOME}/.config/alacritty"

die() { echo "error: $*" >&2; exit 1; }

[[ -d "$SRC_DIR" ]] || die "missing source directory: $SRC_DIR"
[[ -f "$SRC_DIR/alacritty.toml" ]] || die "missing source file: $SRC_DIR/alacritty.toml"
[[ -f "$SRC_DIR/dank-theme.toml" ]] || die "missing source file: $SRC_DIR/dank-theme.toml"

install -d "$DEST_DIR"
install -m 0644 "$SRC_DIR/alacritty.toml" "$DEST_DIR/alacritty.toml"
install -m 0644 "$SRC_DIR/dank-theme.toml" "$DEST_DIR/dank-theme.toml"

echo "Installed Alacritty config to $DEST_DIR"
