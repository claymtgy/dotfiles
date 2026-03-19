#!/bin/bash
#
# audio-selector.sh — waybar custom module
#
# Outputs the current default PipeWire sink as waybar JSON.
# Left-click cycles to the next available sink.
#
# Waybar config usage:
#   "exec":     "~/.config/waybar/audio-selector.sh"
#   "on-click": "~/.config/waybar/audio-selector.sh --click"

WPCTL=/usr/bin/wpctl

# Returns "ID NAME" pairs, one per line, for all Audio sinks.
# Parses the wpctl status block between "├─ Sinks:" and the next "├─ ".
get_sinks() {
    $WPCTL status 2>/dev/null | awk '
        /├─ Sinks:/        { in_sinks=1; next }
        in_sinks && /├─ /  { in_sinks=0 }
        in_sinks {
            if (match($0, /[0-9]+\./)) {
                id   = substr($0, RSTART, RLENGTH - 1)
                rest = substr($0, RSTART + RLENGTH)
                sub(/^[[:space:]]+/, "", rest)
                sub(/ \[.*$/,        "", rest)
                sub(/[[:space:]]+$/, "", rest)
                print id " " rest
            }
        }
    '
}

# Returns the ID of the current default sink (the line with *).
get_default_id() {
    $WPCTL status 2>/dev/null | awk '
        /├─ Sinks:/        { in_sinks=1; next }
        in_sinks && /├─ /  { in_sinks=0 }
        in_sinks && /\*/ {
            if (match($0, /[0-9]+\./)) {
                print substr($0, RSTART, RLENGTH - 1)
                exit
            }
        }
    '
}

cycle_sink() {
    mapfile -t sink_lines < <(get_sinks)
    local total=${#sink_lines[@]}
    (( total <= 1 )) && exit 0

    local default_id
    default_id=$(get_default_id)

    local current_idx=0
    for i in "${!sink_lines[@]}"; do
        local id="${sink_lines[$i]%% *}"
        if [[ "$id" == "$default_id" ]]; then
            current_idx=$i
            break
        fi
    done

    local next_idx=$(( (current_idx + 1) % total ))
    local next_id="${sink_lines[$next_idx]%% *}"

    # Get the node.name for the next sink (needed for pw-metadata)
    local next_node_name
    next_node_name=$(wpctl inspect "$next_id" 2>/dev/null \
        | awk -F'"' '/node\.name/{print $2}')

    # Set runtime default
    $WPCTL set-default "$next_id"

    # Also write the configured default via pw-metadata so WirePlumber
    # saves it to its state file and stops reverting on policy re-evaluation.
    if [[ -n "$next_node_name" ]]; then
        pw-metadata -n default 0 default.audio.sink \
            "{\"name\":\"$next_node_name\"}" > /dev/null 2>&1
    fi
}

if [[ "$1" == "--click" ]]; then
    cycle_sink
    exit 0
fi

# ── Output ────────────────────────────────────────────────────────────────────

default_id=$(get_default_id)

# Get the full name for the default sink
default_name=$(get_sinks | awk -v id="$default_id" '$1 == id { sub(/^[0-9]+ /, ""); print; exit }')

friendly=$(echo "$default_name" | cut -c1-26)

# Pick a FontAwesome 4 icon based on the sink name (BMP PUA, always available)
if echo "$default_name" | grep -qi "hdmi\|display\|monitor\|digital"; then
    icon=$'\xef\x89\xac'   # U+F26C fa-tv
elif echo "$default_name" | grep -qi "blue\|bt\|airpod\|wireless"; then
    icon=$'\xef\x8a\x93'   # U+F293 fa-bluetooth
else
    icon=$'\xef\x80\xa8'   # U+F028 fa-volume-up
fi

total=$(get_sinks | wc -l)
tooltip="$default_name\nClick to cycle ($total devices)"

printf '{"text": "%s %s", "tooltip": "%s", "class": "audio-selector"}\n' \
    "$icon" "$friendly" "$tooltip"
