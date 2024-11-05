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

nix-shell -p git --command "git clone https://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@github.com/Fulcrum7567/NixOS-config $SCRIPT_DIR"

while [[ -z "$hostname" ]]; do
	read "What is the name of your device? " $hostname
done

sh $SCRIPT_DIR/system/scripts/createNewHost.sh --hostname "$hostname"

if [ -n "$?" = 0 ]; then
	echo "Cancelled..."
	exit -1
fi

sh $SCRIPT_DIR/system/scripts/createNewHost.sh --hostname "$hostname"