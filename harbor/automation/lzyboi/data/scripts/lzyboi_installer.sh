#!/bin/bash
mkdir -p ~/.local/lzyboi_datastores # Main lzyboi data store
mkdir -p ~/.local/bin
mkdir -p ~/.local/bin/lboi
# fetch the script (lzyboi.sh) and place it in ~/.local/bin/lboi
chmod +x $HOME/.local/my_scripts/lboi
# echo 'export PATH="$PATH:~/.local/my_scripts' >> ~/.bashrc
# echo 'source "$HOME/.local/my_scripts/lzyboi_intercept.sh"' >> ~/.bashrc
source ~/.bashrc

# lzyboi_intercept() {
#   local cmd="$BASH_COMMAND"
#   if [[ "$cmd" =~ ^[[:space:]]+ ]]; then trim="${cmd#"${cmd%%[![:space:]]*}"}"; lboi "$trim" "$2"; return 1; fi
# }