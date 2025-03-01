# FILE: datadumps.sh
#
# AUTOR: Tahoe
#
# DESCRIPTION: 
# This file contains every method for lzyboi's datadump management. Datadumps are dirs used to store 
# information like target data and wordlists which are critical to the execution of tools such as 
# nmap or gobuster.
#
# DP stands for datadump.
#
# COMMANDS: 
# lboi -d [PATH] : Assign a directory for lzyboi to use as a location for its datadumps
# lboi -d s*how : Output the contents of the current datadump
# lboi -d e*dit [PARAM] : Executes a command on the current datadump or opens it with vim by default
# lboi -d n*ew : Creates a new datadump within the datadump directory
# lboi -d s*et : Looks for the most recent datadump in the directory or creates and sets a new one
# lboi -d l*ist : Displays a numerated list of all the datadumps in the current directory and reads 
#				   the user input to switch datadumps
# lboi -d g*o : Makes this shit a whole lot faster
#
#!/bin/bash

# This step is crucial, as it defines the path which lzyboi will use to create datadumps which contains
# the data it requires to perform pretty much all of its tasks.
#
# Usage: lboi -d [PATH]
set_DP_directory() { 
	if [ -z $1 ]; then path=$(cd "${SCRIPT_DIR}/datadumps_default/" 2>/dev/null && pwd)
	else path=$(cd "$1" 2>/dev/null && pwd); fi
	if [ -d "$path" ]; then sed -i "s|^DP_DIR=.*|DP_DIR=\"${path%/}\"|" "$CONFIG_FILE"
	else echo "Directory does not exist. If your path starts from root, make sure it's right."; exit 1; fi
}

# You probably won't be using this one manually, as it is faster to just call DP_fresh() or fast_setup().
# However, I am a strong believer in flexibility, so here you go.
#
# Usage: lboi -d n*ew
DP_new() {
    INDEX=$(find "$DP_DIR" -type d -name "lzyboi_datadump_*" | wc -l)
    DATE=$(date +"%d-%m-%y")
    DIRNAME="lzyboi_datadump_${DATE}_$(printf "%03d" "$INDEX")"
    mkdir "$DP_DIR/$DIRNAME"; if [[ $? -eq 1 ]]; then exit 1; fi
    touch "$DP_DIR/$DIRNAME/settings.sh"; echo "New datadump created: /$DIRNAME"
}

# Get the most recent datadump in the directory and set it as the current datadump within the config file
#
# Usage: lboi -d s*et
DP_set() {
    DP=$(find "$DP_DIR" -type d -name "lzyboi_datadump_*" -printf "%T@ %p\n" 2>/dev/null | sort -n | tail -1 | awk '{print $2}')
	sed -i "s|^DP=.*|DP=\"${DP##*/}\"|" "$CONFIG_FILE"
    if [ -n "$DP" ]; then echo "Activated datadump ${DP##*/}"
    else echo "No datadump found. Creating new datadump..."
		# Creation, then recursive call for validation
		DP_new; DP_set; fi
}

# Basically just calling DP_new() and DP_set() in one go, making the process faster, but potentially
# not what you want for some context-specific reason.
#
# Usage: lboi -d f*resh
DP_fresh() {
	# Creation, then set as the current DP
	DP_new; DP_set
}

# Usage: lboi -d l*ist
DP_select() {
    # Get all datadumps (active and inactive) within the directory
    DP_LIST=$(ls $DP_DIR/lzyboi_datadump_* 2>/dev/null)
    if [[ ${#DP_LIST[@]} -eq 0 ]]; then echo "No datadumps found. Creating new datadump..."
        DP_new; return; fi

	# Display an enumerated list of all the datadumps along with their contents
    echo "Available datadumps:"
    for i in "${!DP_LIST[@]}"; do
		source "$DP_DIR/${DP_LIST[$i]}/settings.sh"
        printf "%d) %s\n" "$((i + 1))" "${DP_LIST[$i]}" "$ACTIVE_TARGET"
    done

    # Prompt user to choose a datadump
    echo "Select a datadump to activate (1-${#DP_LIST[@]}):"; read -r input
    if [[ "$input" =~ ^[1-9][0-9]*$ ]] && [[ "$input" >= 1 && "$input" <= ${#DP_LIST[@]} ]]; then
        # Assign the chosen datadump to the global variable within the config file
        CHOSEN="${DP_LIST[$((input - 1))]}"
        sed -i "s|^DP=.*|DP=\"$CHOSEN\"|" "$CONFIG_FILE"
        echo "Activated datadump ${CHOSEN##*/}"
    else echo "Invalid input. No changes made."; fi
}

# "I don't have time for this shit" type shit. Set up a brand new directory with a fresh datadump, 
# 'cause you just hasty like that.
#
# Usage: lboi -d g*o
fast_setup() {
	set_DP_directory; DP_fresh
}

# Executes some command on the current datadump or opens it with vim by default. You could, for
# example, do "rm" on it if you want. (I made it safer by allowing only a few commands)
#
# Usage: lboi -d e*dit [PARAM]
DP_edit() {
	if [ -z $2 ]; then vim "$DP"
	elif [[ -x $(command -v "$2") ]] && [[ "$2" = "rm" || "$2" = "nano" || "$2" = "vim" || "$2" = "cat" ]]; then "$2" "$DP"; fi
}
