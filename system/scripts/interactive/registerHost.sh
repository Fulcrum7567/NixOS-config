#!/bin/sh

hostname=""
debug=false
no_new_config=false
force=false
no_usage=false
path_to_dotfiles="$PWD/../../../"

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

if [ "$1" = "--help" -o "$1" = "-h" ]; then
    print_usage_force
    exit 0
fi



while [ $# -gt 0 ]; do
    case "$1" in
        --debug|-d)
            debug=true
            ;;
        --no-new-config)
            no_new_config=true
            ;;
        --force|-f)
            force=true
            ;;
        --no-usage|-u)
            no_usage=true
            ;;
		--hostname|-n)
			if [ -n "$2" ]; then
				hostname="$2"
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

repeat=true
while [ $repeat ]; do
	repeat=false
	read -p "What is the name of the host? " $hostname
	if [ -z "$hostname" ]; then
		echo "Error: Hostname must not be empty!"
		repeat=true
	elif [ -d "$path_to_dotfiles/hosts/$hostname/" ]; then
		echo "Warning: A host with the name $hostname is already registered."
		get_confirmation "Do you want to overwrite it?"
		if [ "$?" = 0 ]; then
			force=true
		else
			hostname=""
			force=false
			repeat=true
		fi
	fi
done
	