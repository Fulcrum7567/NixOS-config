#!/bin/sh

# one-click-installation script

hostname=""

# Clone dotfiles
if [ $# -gt 0 ]
  then
    SCRIPT_DIR=$1
  else
    SCRIPT_DIR=~/.dotfiles
fi

nix-shell -p git --command "git clone https://github.com/Fulcrum7567/NixOS-config.git $SCRIPT_DIR"

sh $(realpath "$SCRIPT_DIR/system/scripts/interactive/registerHost.sh")

if [ ! "$?" = 0 ]; then
	echo "Cancelled..."
	exit -1
fi

if [ -f $(realpath "$SCRIPT_DIR/system/scripts/results/registerHost") ]; then
  hostname=$(cat "$SCRIPT_DIR/system/scripts/results/registerHost")
else
  echo "Error: Host was not configured correctly"
  echo "Cancelling"
  exit 1
fi

sh $(realpath "$SCRIPT_DIR/system/scripts/raw/setCurrentHost.sh") "$hostname"
git update-index --assume-unchanged $SCRIPT_DIR/hosts/currentHost.nix