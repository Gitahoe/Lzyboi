#!/bin/bash
tools_category="_misc.sh"
tool_list=$(cat <<EOF
netcat
curl
wget
python
package-managers
_settings_
EOF
)
echo "Miscellaneous tools. Select \"_settings_\" to alter this category."
selection=$(printf "%s\n" "${tool_list[@]}" | fzf --reverse --height 99% --bind "tab:jump")
if [[ -z "$selection" ]]; then echo "Exiting..."; exit 1; fi
if [[ "$selection" == "_settings_" ]]; then sudo vim "$TOOLS_DIR/$tools_category"; exit 0; fi