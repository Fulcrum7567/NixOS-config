#!/bin/sh

debug=false
no_new_config=false
overwrite=false
no_usage=false
repair=false
path_to_dotfiles="$PWD/../../../"


# Function to print the usage of the script
print_usage_force() {
    echo "Usage: $0 <hostName> [options]"
    echo
    echo "Options:"
    echo "  --debug, -d         Enable debug mode"
    echo "  --no-new-config     Don't regenerate \"configuration.nix\", \"hardware-configuration.nix\" will always be regenerated."
    echo "  --overwrite, -o     Overwrite host if it already exists"
	echo "  --repair, -r		Repair host"
    echo "  --no-usage, -u      Don't show usage after an error"
    echo "  --help, -h          Display this help message and exit"
    echo
    echo "Examples:"
    echo "  $0 myHost --debug --skip-confirm"
    echo "  $0 myHost -d -s"
    echo "  $0 --help"
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


# Check for --help or -h before processing other arguments
if [ "$1" = "--help" -o "$1" = "-h" ]; then
    print_usage_force
    exit 0
fi

# Check if hostName (first argument) is provided
if [ -z "$1" ]; then
    echo "Error: Missing required argument <hostName>."
    print_usage
    exit 1
fi

if [ "$1" = "GLOBAL" ]; then
    echo "Error: Host name \"GLOBAL\" is reserved!"
    print_usage
    exit 2
fi

# Parse the arguments
hostname="$1"
shift # Shift to process optional arguments


while [ $# -gt 0 ]; do
    case "$1" in
        --debug|-d)
            debug=true
            ;;
        --no-new-config)
            no_new_config=true
            ;;
        --overwrite|-o)
            overwrite=true
            ;;
		--repair|-r)
			repair=true
			;;
        --no-usage|-u)
            no_usage=true
            ;;
        *)
            echo "Error: Unknown argument '$1'."
            print_usage
            exit 1
            ;;
    esac
    shift
done

if [ "$repair" = true -a "$overwrite" = true ]; then
	echo "Error: --overwrite and --repair can not be used together."
	print_usage
	exit 2
fi

# Check if host is already registered
if [ -d "$path_to_dotfiles/hosts/$hostname/" -a "$overwrite" = false -a "$repair" = false ]; then
    echo "Error: Host \"$hostname\" already registered. Use -o to overwrite or -r to repair"
    print_usage
    exit 3
fi

# Check for permission
if [ -z "$SUDO_USER" ]; then
    echo "Error: Please call this script with sudo"
    print_usage
    exit 2
fi

# remove config if necessery
if [ -d "$path_to_dotfiles/hosts/$hostname/" ]; then
	if [ "$overwrite" = true ]; then
		sudo rm -rf "$path_to_dotfiles/hosts/$hostname/"
	elif [ "$repair" = true ]; then
		sudo rm -rf "$path_to_dotfiles/hosts/$hostname/hostConfigs/"
		sudo rm "$path_to_dotfiles/hosts/$hostname/hostSettings.nix"
	fi
fi


if [ "$repair" = false ]; then
	# Create host
	#mkdir "$path_to_dotfiles/hosts/$hostname"
	sudo -u "$SUDO_USER" cp -r "$path_to_dotfiles/system/scripts/presets/hosts/hostName" "$path_to_dotfiles/hosts/$hostname"
	print_debug "Copied host presets to \"$(realpath $path_to_dotfiles/hosts/$hostname)\""
fi


if [ ! -d "$path_to_dotfiles/hosts/$hostname/hostConfigs/" ]; then
	mkdir "$path_to_dotfiles/hosts/$hostname/hostConfigs/"
fi

# Regenerate config
if [ "$no_new_config" = true ]; then
    cp "/etc/nixos/configuration.nix" "$path_to_dotfiles/hosts/$hostname/hostConfigs/"
    print_debug "Copied configuration.nix to \"$(realpath $path_to_dotfiles/hosts/$hostname)\""
    sudo nixos-generate-config --show-hardware-config > "$path_to_dotfiles/hosts/$hostname/hostConfigs/hardware-configuration.nix"
    print_debug "Generated hardware-configuration.nix in \"$(realpath $path_to_dotfiles/hosts/$hostname/hostConfigs/)\""
else
    sudo nixos-generate-config --force --dir $(realpath "$path_to_dotfiles/hosts/$hostname/hostConfigs/")
    print_debug "Generated hardware-configuration and configuration.nix in \"$(realpath $path_to_dotfiles/hosts/$hostname/hostConfigs/)\""
fi