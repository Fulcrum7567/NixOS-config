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
        --no-host-config)
			no_host_config=true
			;;
		--no-host-settings)
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


rsync -a --exclude="hostConfigs/" --exclude="hostSettings.nix" $(realpath "$path_to_dotfiles/system/backup/hosts/$hostname/") $(realpath $path_to_dotfiles/hosts/$hostname/)

