#!/bin/bash
tool_category="_wifi.sh"
# Necessary?
tools_dir="./values/tools"
tool_list=(
    "netcat"
    "curl"
    "wget"
    "python"
    "package-managers"
    "_settings_"
)
echo "Miscellaneous tools. Select \"_settings_\" to alter this category."
selection=$(printf "%s\n" "${tool_list[@]}" | fzf --reverse --height 99% --bind "tab:jump")
if [[ -z "$selection" ]]; then echo "Exiting..."; exit 1; fi
if [[ "$selection" == "_settings_" ]]; then sudo vim "$tools_dir/$tool_category"; exit 0; fi