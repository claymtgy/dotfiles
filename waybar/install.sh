#!/bin/bash

WAYBAR_CONFIG_DIR="$HOME/.config/waybar"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Select an option:"
echo "1: Copy repo's waybar configs to the user config directory"
echo "2: Copy current waybar configs to the repo directory"

read choice

if [[ $choice == 1 ]]; then
    mkdir -p "$WAYBAR_CONFIG_DIR"

    cp "$SCRIPT_DIR/config.jsonc" "$WAYBAR_CONFIG_DIR/config.jsonc"
    echo "Copied waybar config to $WAYBAR_CONFIG_DIR/config.jsonc"

    cp "$SCRIPT_DIR/style.css" "$WAYBAR_CONFIG_DIR/style.css"
    echo "Copied waybar style to $WAYBAR_CONFIG_DIR/style.css"

    cp "$SCRIPT_DIR/audio-selector.sh" "$WAYBAR_CONFIG_DIR/audio-selector.sh"
    chmod +x "$WAYBAR_CONFIG_DIR/audio-selector.sh"
    echo "Copied audio-selector.sh to $WAYBAR_CONFIG_DIR/audio-selector.sh"

    echo "Done."
fi

if [[ $choice == 2 ]]; then
    cp "$WAYBAR_CONFIG_DIR/config.jsonc" "$SCRIPT_DIR/config.jsonc"
    echo "Copied $WAYBAR_CONFIG_DIR/config.jsonc to repo"

    cp "$WAYBAR_CONFIG_DIR/style.css" "$SCRIPT_DIR/style.css"
    echo "Copied $WAYBAR_CONFIG_DIR/style.css to repo"

    cp "$WAYBAR_CONFIG_DIR/audio-selector.sh" "$SCRIPT_DIR/audio-selector.sh"
    echo "Copied $WAYBAR_CONFIG_DIR/audio-selector.sh to repo"

    echo "Done."
fi
