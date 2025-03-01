# FILE: script_manager.sh
#
# AUTOR: Tahoe
#
# DESCRIPTION: This file manages all that is related to scripts and automation.
#
# COMMANDS: 
# lboi -c : N/A
# lboi -c [CATEGORY] : Enumerate all tools related to given category and await selection.
# lboi -c [TOOL NAME] : If a tool name is given, display all scripts.
#
#!/bin/bash

# Start by making sure that there is a directory for this target
if [[ -n "$T_DIR" ]]; then T_DIR="$DP_DIR/$DP/$T_IP"; mkdir "$T_DIR"; sed -i "s|^T_DIR=.*|T_DIR=\"$T_DIR\"|" "$SETTINGS"; echo "New target directoy at $T_DIR"; source "$SETTINGS"

