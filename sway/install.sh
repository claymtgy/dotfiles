#!/bin/bash

SWAY_CONFIG_DIR="$HOME/.config/sway"
SWAY_CONF_D_DIR="$SWAY_CONFIG_DIR/config.d"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Select an option:"
echo "1: Copy repo's sway configs to the user config directory"
echo "2: Copy current sway configs to the repo directory"

read choice

if [[ $choice == 1 ]]; then
    mkdir -p "$SWAY_CONFIG_DIR"
    mkdir -p "$SWAY_CONF_D_DIR"

    cp "$SCRIPT_DIR/config" "$SWAY_CONFIG_DIR/config"
    echo "Copied sway config to $SWAY_CONFIG_DIR/config"

    cp "$REPO_ROOT/swaybar/config" "$SWAY_CONF_D_DIR/swaybar"
    echo "Copied swaybar config to $SWAY_CONF_D_DIR/swaybar"

    echo "Done. Reload sway with \$mod+Shift+c to apply changes."
fi

if [[ $choice == 2 ]]; then
    cp "$SWAY_CONFIG_DIR/config" "$SCRIPT_DIR/config"
    echo "Copied $SWAY_CONFIG_DIR/config to repo"

    cp "$SWAY_CONF_D_DIR/swaybar" "$REPO_ROOT/swaybar/config"
    echo "Copied $SWAY_CONF_D_DIR/swaybar to repo"

    echo "Done."
fi
