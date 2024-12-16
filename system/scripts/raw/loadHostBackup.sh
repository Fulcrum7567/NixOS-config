#!/bin/sh

debug=false
no_usage=false
no_host_config=false
no_host_settings=false
path_to_dotfiles="$PWD/../../../"

print_usage_force() {
    echo "Usage: $0 <hostname> [options]"
    echo
    echo "Options:"
    echo "  --no-configs        Don't restore hostConfigs/"
    echo "  --no-settings       Don't restore hostSettings.nix"
    echo "  --debug, -d         Enable debug mode"
    echo "  --no-usage, -u      Don't show usage after an error"
    echo "  --help, -h          Display this help message and exit"
    echo
    echo "Examples:"
    echo "  $0 myHost --debug"
    echo "  $0 myHost -d"
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



# Check if hostname (first argument) is provided
if [ -z "$1" ]; then
    echo "Error: Missing required argument <hostname>."
    print_usage
    exit 1
fi


hostname="$1"
shift 

while [ $# -gt 0 ]; do
    case "$1" in
        --debug|-d)
            debug=true
            ;;
        --no-usage|-u)
            no_usage=true
            ;;
        --no-configs)
			no_host_config=true
			;;
		--no-settings)
			no_host_settings=true
			;;
        *)
            echo "Error: Unknown argument '$1'."
            print_usage
            exit 1
            ;;
    esac
    shift
done


if [ ! -d $(realpath "$path_to_dotfiles/system/backup/hosts/$hostname/") ]; then
	echo "Error: There is no backup for \"$hostname\""
	print_usage
	exit 1
fi

# Check for permission
if [ -z "$SUDO_USER" ]; then
    echo "Error: Please call this script with sudo"
    print_usage
    exit 2
fi


sudo -u "$SUDO_USER" rsync -a --exclude="hostConfigs/" --exclude="hostSettings.nix" "$(realpath "$path_to_dotfiles/system/backup/hosts/$hostname/")" "$(realpath "$path_to_dotfiles/hosts/")"
print_debug "Copied backup files except for hostConfigs/ and hostSettings.nix"


if [ "$no_host_config" = false ]; then
    sudo -u "$SUDO_USER" mkdir -p $(realpath $path_to_dotfiles/hosts/$hostname/hostConfigs/)
    sudo cp -r "$(realpath $path_to_dotfiles/system/backup/hosts/$hostname/hostConfigs)"/* "$(realpath $path_to_dotfiles/hosts/$hostname/hostConfigs/)"
    print_debug "Copied hostConfigs/"
fi

if [ "$no_host_settings" = false -a -f $(realpath "$path_to_dotfiles/system/backup/hosts/$hostname/hostSettings.nix") ]; then
    sudo -u "$SUDO_USER" cp "$(realpath $path_to_dotfiles/system/backup/hosts/$hostname/hostSettings.nix)" "$(realpath $path_to_dotfiles/hosts/$hostname/)"
    print_debug "Copied hostSettings.nix"
fi