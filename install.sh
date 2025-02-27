#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/")

cmd_debug=""
cmd_no_usage=""

hostname=""
hostname_given=false
location=""


print_usage_force() {
    echo "Usage:" 
    echo "  $0 [option?]"
    echo "Or:"
    echo "  $0 --help, -h      Show this message and exit"
    echo ""
    echo "Options:"
	echo "  --hostname,    -H <hostName>	  Pre set hostname to create"
	echo "	--location,    -l <dir>			  Pre set location of dotfiles"
    echo ""
    echo "  --no-usage, -u                  Don't show usage after an error"
    echo "  --debug,    -d                  Enable debug mode"
    echo ""
}

print_usage() {
    if [ "$no_usage" = false ]; then
        print_usage_force
    fi
} 

print_debug() {
    if [ "$debug" = true ]; then
        echo "[Debug]: $1"
    fi
}

print_error() {
    echo "[Error]: $1"
}



if [ "$1" = "--help" -o "$1" = "-h" ]; then
    print_usage_force
    exit 0
fi



while [ $# -gt 0 ]; do
    case "$1" in
        --debug|-d)
            debug=true
            cmd_debug="--debug"
            ;;
        --no-usage|-u)
            no_usage=true
            cmd_no_usage="--no-usage"
            ;;
		--hostname|-H)
			if [ -n "$2" ]; then
				hostname="$2"
                hostname_given=true
				shift
			else
				print_error "--hostname, -H requires a hostname"
				print_usage
                exit 1
			fi
			;;
		--location|-l)
			if [ -n "$2" ]; then
				location="$2"
				shift
			else
				print_error "--location, -l requires a location"
				print_usage
                exit 1
			fi
			;;
        *)
            echo "Error: Unknown argument '$1'."
            print_usage
            exit 1
            ;;
    esac
    shift
done


if [ -z "$location" ]; then
	location=$(gum input --prompt="Where do you want to install your dotfiles? " --placeholder="Default: ~/.dotfiles")
fi

if [ -z "$location"]; then
	location="~./dotfiles"
fi

print_debug "Location set to \"$location\""


nix-shell -p git --command "git clone https://github.com/Fulcrum7567/NixOS-config.git $location"
print_debug "Cloned git repo"

output=""

if [ "$hostname_given" = false ]; then
	output=$(sh $(realpath "$SCRIPT_DIR/system/scripts/interactive/registerHost.sh") $cmd_debug $cmd_no_usage)
else
	output=$(sh $(realpath "$SCRIPT_DIR/system/scripts/interactive/registerHost.sh") "--hostname" "$hostname" $cmd_debug $cmd_no_usage)
fi



if [ "$?" = 0 ]; then
	echo $output
fi













' :


# Clone dotfiles
if [ $# -gt 0 ]
  then
    SCRIPT_DIR=$1
  else
    SCRIPT_DIR=~/.dotfiles
fi

nix-shell -p git --command "git clone https://github.com/Fulcrum7567/NixOS-config.git $SCRIPT_DIR"

cd $SCRIPT_DIR

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
sh $(realpath "$SCRIPT_DIR/system/scripts/raw/gitAddAll.sh")
git update-index --assume-unchanged $SCRIPT_DIR/hosts/currentHost.nix
' 