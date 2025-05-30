#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")

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
        *)
            echo "Error: Unknown argument '$1'."
            print_usage
            exit 1
            ;;
    esac
    shift
done

if [ ! -d "$path_to_dotfiles/hosts/$hostname" ]; then
	echo "Error: There is no host registered under the name \"$hostname\"."
	print_usage
	exit 1
fi

# Check for permission
if [ -z "$SUDO_USER" ]; then
    echo "Error: Please call this script with sudo"
    print_usage
    exit 2
fi

sudo -u "$SUDO_USER" mkdir -p "$path_to_dotfiles/system/backup/hosts/$hostname/"
print_debug "Created backup folder at $(realpath "$path_to_dotfiles/system/backup/hosts/$hostname/")"
cp -r "$(realpath $path_to_dotfiles/hosts/$hostname)"/* "$(realpath $path_to_dotfiles/system/backup/hosts/$hostname)"

print_debug "Copied files from "$(realpath $path_to_dotfiles/hosts/$hostname)"/* to $(realpath $path_to_dotfiles/system/backup/hosts/$hostname)"

