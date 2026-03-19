#!/bin/bash

NIRI_CONFIG_DIR="$HOME/.config/niri"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Select an option:"
echo "1: Copy repo's niri config to the user directory (~/.config/niri/config.kdl)"
echo "2: Copy current niri config to the repo"

read choice

if [[ $choice == 1 ]]; then
    mkdir -p "$NIRI_CONFIG_DIR"
    cp "$SCRIPT_DIR/config.kdl" "$NIRI_CONFIG_DIR/config.kdl"
    echo "Copied repo's niri config to $NIRI_CONFIG_DIR/config.kdl"
    echo "Reload niri config with Mod+Shift+C to apply changes."
fi

if [[ $choice == 2 ]]; then
    if [[ -f "$NIRI_CONFIG_DIR/config.kdl" ]]; then
        cp "$NIRI_CONFIG_DIR/config.kdl" "$SCRIPT_DIR/config.kdl"
        echo "Copied $NIRI_CONFIG_DIR/config.kdl to repo"
    else
        echo "Error: $NIRI_CONFIG_DIR/config.kdl not found"
        exit 1
    fi
fi
