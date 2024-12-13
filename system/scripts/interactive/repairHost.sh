#!/bin/sh


debug=false
no_usage=false
path_to_dotfiles="$PWD/../../../"

cmd_hostname=""
cmd_debug=""
cmd_no_new_config=""
cmd_force=""
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

get_hostname() {
	while [ -z "$cmd_hostname" ]; do
		read -p "What host do you want to repair? " cmd_hostname
	done
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
        --force|-f)
            cmd_force="--force"
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

if [ -z "$cmd_hostname" ]; then
	get_hostname
fi

while [ ! -d $(realpath "$path_to_dotfiles/hosts/$cmd_hostname") ]; do
	echo "Error: There is no host registered with the name \"$cmd_hostname\""
	cmd_hostname=""
	get_hostname
done


