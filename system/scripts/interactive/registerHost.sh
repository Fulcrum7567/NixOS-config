#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles="$PWD/../../../"



cmd_hostname=""
cmd_debug=""
overwrite_repair=""
cmd_no_new_config=""
cmd_no_usage=""

print_usage_force() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
	echo "  --hostname, -h <hostName>	Pre set host name"
    echo "  --debug, -d         		Enable debug mode"
    echo "  --no-new-config     		Don't regenerate \"configuration.nix\", \"hardware-configuration.nix\" will always be regenerated."
    echo "  --force, -f         		Overwrite host if it already exists"
    echo "  --no-usage, -u      		Don't show usage after an error"
    echo "  --help, -h          		Display this help message and exit"
    echo
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
        --no-new-config)
            cmd_no_new_config="--no-new-config"
            ;;
        --overwrite|-o)
            overwrite_repair="--force"
            ;;

        --no-usage|-u)
            no_usage=true
			cmd_no_usage="--no-usage"
            ;;
		--hostname|-n)
			if [ -n "$2" ]; then
				cmd_hostname="$2"
				shift
			else
				echo "Error: --hostname or -n requires a name."
				print_usage
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


if [ -z "$SUDO_USER" ]; then
    echo "Warning: This script needs sudo rights!"
fi

if ! sudo -v 2>/dev/null; then
    echo "Error: This script needs sudo rights!"
    print_usage
    exit 2
fi

while [ -z "$cmd_hostname" ]; do
    read -p "What is the name of the host? " cmd_hostname
    if [ -z "$cmd_hostname" ]; then
        echo "Error: Hostname must not be empty"
    elif [ "$cmd_hostname" = "GLOBAL" ]; then
        echo "Error: The name \"GLOBAL\" is reserved"
        cmd_hostname=""
    fi
done

if [ -d $(realpath "$path_to_dotfiles/hosts/$cmd_hostname") ]; then
    echo "Warning: A host with the name \"$cmd_hostname\" is already registered"
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getOption.sh") "Do you want to repair or overwrite it? " repair/r overwrite/o --default repair
    result="$?"
    if [ "$result" = 0 ]; then
        print_debug "Cancelled, exiting..."
        exit 1
    elif [ "$result" = 1 ]; then
        print_debug "Repairing host..."
        sh $(realpath "$path_to_dotfiles/system/scripts/interactive/repairHost.sh") --hostname "$cmd_hostname"
        print_debug "Host repaired"
        exit 0
    elif [ "$result" = 2 ]; then
        print_debug "Overwriting host..."
        cmd_force="--force"
    fi
fi


if [ -z "$cmd_no_new_config" ]; then
	sh "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh" "Do you want to copy your existing configuration.nix file from /etc/nixos/?" --default no --no-usage
	if [ "$?" = 0 ]; then
		cmd_no_new_config="--no-new-config"
	fi
fi


exec_command="$(realpath "$path_to_dotfiles/system/scripts/raw/registerHost.sh") $cmd_hostname $cmd_no_new_config $cmd_debug $cmd_force $cmd_no_usage"

print_debug "Executing command: $exec_command"

sudo sh $exec_command