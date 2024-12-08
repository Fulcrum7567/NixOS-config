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

while [[ -z "$hostname" ]]; do
	read "What is the name of your device? " $hostname
done

sh $SCRIPT_DIR/system/scripts/createNewHost.sh --hostname "$hostname"

if [ -n "$?" = 0 ]; then
	echo "Cancelled..."
	exit -1
fi

cp $SCRIPT_DIR/system/scripts/presets/hosts/currentHost.nix $SCRIPT_DIR/hosts
git update-index --assume-unchanged $SCRIPT_DIR/hosts/currentHost.nix