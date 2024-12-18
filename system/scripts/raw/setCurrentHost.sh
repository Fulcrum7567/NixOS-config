#!/bin/bash

# Initialize default values for options
debug=false
force=false
no_usage=false
path_to_dotfiles="$PWD/../../../"


# Function to display usage
print_usage_force() {
    echo "Usage: $0 <hostName> [--debug|-d] [--force|-f]"
    echo "       $0 [--help|-h]"
    echo
    echo "Arguments:"
    echo "  <hostName>          Host name (required unless --help is used)"
    echo "  --debug, -d         Enable debug mode (optional)"
    echo "  --force, -f         Force execution (optional)"
    echo "  --help, -h          Display this help message"
    exit 0
}

print_usage() {
    if [ "$no_usage" == false ]; then
        print_usage_force
    fi
}

print_debug() {
    if [[ "$debug" == true ]]; then
        echo "[Debug]: $1"
    fi
}


# Check for --help/-h first
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    print_usage_force
fi

# Validate the number of arguments
if [[ $# -lt 1 ]]; then
    echo "Error: Missing required <hostName> argument."
    print_usage
fi

# Parse positional arguments
host_name="$1"
shift # Shift to process other options

# Parse optional flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --debug|-d)
            debug=true
            shift
            ;;
        --force|-f)
            force=true
            shift
            ;;
        --no-usage|-u)
            no_usage=true
            shift
            ;;
        *)
            echo "Error: Invalid argument '$1'"
            usage
            ;;
    esac
done



if [ -f $(realpath "$path_to_dotfiles/hosts/currentHost.nix") ]; then
    if [ "$force" = false ]; then
        echo "Error: Current host is already set. Use --force / -f to overwrite"
        print_usage
        exit 2
    fi
else
    cp "$path_to_dotfiles/system/scripts/presets/hosts/currentHost.nix" "$path_to_dotfiles/hosts/"
    print_debug "Copied currentHost.nix to \"$(realpath $path_to_dotfiles/hosts/)\""
fi
 

sed -i 's/currentHost = "[^"]*";/currentHost = "'"$host_name"'";/' "$path_to_dotfiles/hosts/currentHost.nix"
print_debug "Replaced host name with $host_name"
