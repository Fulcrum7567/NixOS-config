#!/bin/bash

# Default values
hostname=""
no_new_config=false
debug=false
skip_confirm=false
path_to_dotfiles="$PWD"/../../../

# Function to display usage
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  --hostname, -n      Specify the hostname"
  echo "  --no-new-config     Disable new config"
  echo "  --debug, -d         Enable debug mode"
  exit 1
}

debugMsg() {
	if [ "$debug" = true ]; then
		echo "$1"
	fi
}

get_confirmation() {
	local prompt_message="$1"
	while true; do
		read -rp "$prompt_message (y/n): " choice
		case "$choice" in
			[yY] | [yY][eE][sS] )
				return 0
				;;
			[nN] | [nN][oO] )
				return 1
				;;
			* )
				echo "Please answer yes or no."
				;;
		esac
	done
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --hostname|-n)
      if [ -n "$2" ]; then
        hostname="$2"
        shift 2
      else
        echo "Error: --hostname or -n requires a name."
        usage
      fi
      ;;
    --no-new-config)
      no_new_config=true
      shift
      ;;
    --debug|-d)
      debug=true
      shift
      ;;
	--skip-confirm)
	  skip_confirm=true
	  shift
	  ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Debugging info if enabled
if [ "$debug" = true ]; then
  echo "Debug mode enabled"
  echo "Hostname: $hostname"
  echo "No new config: $no_new_config"
  echo "skip confirms: $skip_confirm"
fi

# Check if HOSTNAME is provided
while [[ -z "$hostname" ]]; do
	read "What is the name of your device? " $hostname
done



# check whether hostname already exists
if [ -d "$path_to_dotfiles/hosts/$hostname/" ]; then
	if [ "$skip_confirm" = false ]; then
		get_confirmation "The Host $hostname already exists. Do you want to proceed?"
		if [ "$?" = 1 ]; then
			debugMsg "Cancelled by user..."
			echo canceling...
			exit -1
		fi
	fi
else
	cp -r "$path_to_dotfiles/system/scripts/presets/devices/hostName" "$path_to_dotfiles/hosts/$hostname"
	debugMsg "copied files to '$path_to_dotfiles/hosts/$hostname'."
fi

# Create new configs
if [ "$no_new_config" = false ]; then
	sudo rm /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix
	sudo nixos-generate-config
	debugMsg "created new config files"
	
	cp -a "/etc/nixos/." "$path_to_dotfiles/hosts/$hostname"
fi

