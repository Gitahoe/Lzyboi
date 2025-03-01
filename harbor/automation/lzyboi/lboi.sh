# Lzyboi - Penetration testing profile
#
# Authored by @Tahoe
#!/bin/bash
if [ $# -eq 0 ]; then cat ; exit 1; fi
CONFIG_FILE="$HOME/.local/harbor/automation/lzyboi/config.cfg"
. $CONFIG_FILE
. $LIB/datadumps.sh
if [ -z "$DP_DIR" ]; then echo -n "No datadump directory has been set. Insert a path or leave empty and use default : "; read -r input; set_DP_directory "$input"; DP_set
elif [ -z "$DP" ]; then DP_set; fi
SETTINGS="$DP_DIR/$DP/settings.sh"
. $SETTINGS

# Option-prefixed calls
while getopts ":d:c:w:m:h:s" opt; do
  case $opt in
    d) # Data system controls
	if [[ -z "$OPTARGS" ]]; then display_help_DP; exit 1; fi
	case "$OPTARG" in
		s)
			;;
	 	g)
			;;
		e)
			;;
	 	f)
			;;
	 	l)
			;;
	 	[PATH])
			;;
	 	n)
			;;
	 	*)
			;;
	 esac
	 ;;
    # c) # Script management
	# 	;;
	# p) # Process management
	# 	;;
    w) # Naviguate wordlists for selection
	 ;;
	# m) # Methodology (fzf selection in the directory, open file in new CLI. If .md, open with markdown interpreter)
	# 	;;
    s) # Display settings.sh
 	 echo "$T_HOST"; echo "$T_URL"; echo "$T_CREDS"
	 ;;
    h) cat "$SCRIPT_DIR/help.txt" ;;
#     \?) echo "Invalid option: $opt" ;;
  esac
  exit 0;
done

# Optionless calls
if [[ $# -gt 0 ]]; then
  case "$1" in
    [0-9]*.[0-9]*.[0-9]*.[0-9]*) # IP address
        sed -i "s|^T_IP=.*|T_IP=\"$1\"|" "$SETTINGS"; . $SETTINGS; echo "Target IP set to $T_IP"
        ;;
    [0-9]*) # Port
        if [[ "$1" -ge 1 ]] && [[ "$1" -le 65535 ]]; then sed -i "s|^T_PORT=.*|T_PORT=\"$1\"|" "$SETTINGS"; . $SETTINGS; echo "Target port set to $T_PORT"
        else echo "Invalid port number. Must be between 0 and 65536."; exit 1; fi
        ;;
    u=*) # User
        USER="${1#u=}"; sed -i "s|^T_USER=.*|T_USER=\"$USER\"|" "$SETTINGS"; . $SETTINGS;  echo "Target user set to \"$T_USER\""
        ;;
    p=*) # Password
        PASSWORD="${1#p=}"; sed -i "s|^T_PWD=.*|T_PWD=\"$PASSWORD\"|" "$SETTINGS"; . $SETTINGS; echo "Target password set to \"$T_PWD\""
        ;;
    url+*) # Concatenate to URL
	ADD="${1#url+}"; [ -z "$ADD" ] && exit 1
	sed -i "/^T_URL=/s|\"$|$ADD\"|" "$SETTINGS"; . $SETTINGS; echo "Added \"$ADD\" to target URL ($T_URL)"
        ;;
    url=*) # Change URL
	URL="${T_URL#://*}${1#url=}"; sed -i "s|^T_URL=.*|T_URL=\"$URL\"|" "$SETTINGS"; . $SETTINGS; echo "Target URL set to \"$T_URL\""
        ;;
    url-*) # Subtract X directories from URL
    	SUB="${1#url-}"; NUM_DIRS=$(( $(echo $T_URL | grep -o '/' | wc -l) - 2 )); [[ "$SUB" =~ ^[0-9]+$ ]] && [[ $NUM_DIRS -ge $SUB ]] || exit 1; 
    	NUM_DIRS=$((NUM_DIRS + 2 - SUB)); T_URL=$(echo "$T_URL" | cut -d'/' -f1-$((NUM_DIRS+1)))
	sed -i "s|^T_URL=.*|T_URL=\"$T_URL\"|" "$SETTINGS"; . "$SETTINGS"; echo "Substracted $SUB dirs from target URL ($T_URL)"
        ;;
    url/) # Clear path
        ;;
    urls) # Alter SSL
	if [[ $T_URL == http://* ]]; then T_URL="${T_URL/http/https}"; else T_URL="${T_URL/https/http}"; fi
	sed -i "s|^T_URL=.*|T_URL=\"$T_URL\"|" "$SETTINGS"; . "$SETTINGS"; echo "SSL switched ($T_URL)"
        ;;
    *) # Browse tools
        # if [[ -n "$T_DIR" ]]; then T_DIR="$DP_DIR/$DP/$T_IP"; mkdir "$T_DIR"; sed -i "s|^T_DIR=.*|T_DIR=\"$T_DIR\"|" "$SETTINGS"; echo "New target directoy at $T_DIR"; fi

        # Manage the given parameter. It could be an indexer. You may also wish to browse $tools_dir manually
        param="$TOOLS_DIR/_$1.sh"
        if [[ "$1" == "--tools" ]]; then echo "Tool browser. Shift + M to edit file."; selection=$(ls "$TOOLS_DIR" | fzf --reverse --height 99% --bind "tab:jump" --expect ctrl-m,M); keypress=$(echo "$selection" | head -n 1); selection=$(echo "$selection" | tail -n 1)
                if [[ "$keypress" == "M" ]]; then sudo vim "$TOOLS_DIR/$selection"; exit 0; else param="$TOOLS_DIR/$selection"; fi; fi
        if [[ -f "$param" || "$selection" == _* ]]; then . $param; param="$TOOLS_DIR/${selection%.sh}.sh"
        elif [[ -f "$TOOLS_DIR/$1.sh" ]]; then param="$TOOLS_DIR/$1.sh"; else echo "No match for $param"; exit 1; fi
        source "$param"

        line_number=-1
        select_snippet() {
            # If a number was assigned to $line_number, move cursor to the corresponding line
            echo "$param"
            if [[ "$line_number" -ge 0 ]]; then selected_line=$(printf "%s\n" "$TEMPLATE" | nl -ba | fzf --nth 1 --reverse --height 99% --bind "tab:jump" --query "${line_number}" --expect ctrl-m,M)
            else selected_line=$(printf "%s\n" "$TEMPLATE" | nl -ba | fzf --nth 1 --reverse --height 99% --bind "tab:jump" --expect ctrl-m,M); fi
            if [[ -z "$selected_line" ]]; then echo "Exiting..."; exit 1; fi

	    # Extract keypress from header. "M" opens a new terminal and pastes the command inside that new instance.
            keypress=$(echo "$selected_line" | head -n 1)
	    # Fetch content without header, trim leading/trailing whitespaces
	    line_content=$(echo "$selected_line" | tail -n 1 | awk '{$1=$1}1')
	    #echo "$line_content"
	    line_second_element=$(echo "$line_content" | awk '{print $2}')
	    #echo "$line_second_element"
	    # Validate the line's content to determine what to do next
	    if [[ "$line_second_element" =~ [0-9] ]]; then line_number="$line_second_element"; return 1 # Naviguate to corresponding snippet
	    elif [[ -z "$line_second_element" ]] || ! [[ "$line_second_element" == "$CMD" ]]; then return 1; fi # Invalid selection. Loop
	    line_body=$(echo "$line_content" | cut -d' ' -f3-)
	    snippet=$(echo "$CMD${ADD[$MODE]} $line_body ${SUFFIXES[$MODE]}${PIPES[$MODE]}")
	    echo "$snippet"

            if [[ "$keypress" == "M" ]]; then # Pop new terminal and pre-write snippet
                gnome-terminal -- bash -c "READLINE_LINE='$snippet'; READLINE_POINT=\${#snippet}; exec bash"; return 0
            else # Pre-write snippet in current terminal
                READLINE_LINE="$snippet"; READLINE_POINT=${#snippet}; return 0; fi
        }

        # Navigate content using fzf, only terminate the loop once a valid line has been selected
        while true; do select_snippet
                if [[ $? -eq 0 ]]; then break; fi
        done
        ;;
  esac
fi
