#!/bin/bash
tool_category="_wifi.sh"
# Necessary?
tools_dir="./values/tools"
tool_list=(
    "airbase-ng"
    "aircrack-ng"
    "airodump-ng"
    "mdk3"
    "wavemon"
    "_settings_"
)
echo "Popular wifi hacking tools. Select \"_settings_\" to alter this category."
selection=$(printf "%s\n" "${tool_list[@]}" | fzf --reverse --height 99% --bind "tab:jump")
if [[ -z "$selection" ]]; then echo "Exiting..."; exit 1; fi
if [[ "$selection" == "_settings_" ]]; then sudo vim "$TOOLS_DIR/$tool_category"; exit 0; fi