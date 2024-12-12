#!/bin/sh

# Initialize default values for options
debug=false
no_usage=false
force=false
path_to_dotfiles="$PWD/../../../"


# Function to display usage
print_usage_force() {
    echo "Usage: $0 <hostName> [--debug|-d] [--force|-f]"
    echo "       $0 [--help|-h]"
    echo
    echo "Arguments:"
    echo "  <hostName>          Host name (required unless --help is used)"
    echo "  --debug, -d         Enable debug mode (optional)"
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
shift

# Parse optional flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --debug|-d)
            debug=true
            shift
            ;;
        --no-usage|-u)
            no_usage=true
            shift
            ;;
		--force|-f)
			force=true
			shift
			;;
        *)
            echo "Error: Invalid argument '$1'"
            usage
            ;;
    esac
done

# check if host exists
if [ ! -d "$path_to_dotfiles/hosts/$host_name/" ]; then
	echo "Error: Host \"$host_name\" is not registered"
	print_usage
	exit 2
fi

# check if host settings already exist
if [ -f "$path_to_dotfiles/hosts/$host_name/hostSettings.nix" -a "$force" == false ]; then
	echo "Error: Host settings already exist for \"host_name\". Use --force to overwrite"
	print_usage
	exit 2
fi

file_to_write="$path_to_dotfiles/hosts/$host_name/hostSettings.nix"
print_debug "file to write set to \"$(realpath $file_to_write)\""
hc_file="$path_to_dotfiles/hosts/$host_name/hostConfigs/hardware-configuration.nix"
print_debug "hardware-configuration.nix file located at \"$(realpath $hc_file)\""

if [ ! -f "$hc_file" ]; then
	echo "Error: \"$host_name\" has no hardware-configuration.nix file."
	exit 3
fi

systemValue=$(grep -oP 'nixpkgs\.hostPlatform = lib\.mkDefault "\K[^"]+' "$hc_file")
print_debug "System value extracted as \"$systemValue\""

if [ -z "$systemValue" ]; then
	echo "Error: Could not extract system from hardware-configuration."
	exit 3
fi

# write file
echo "{" > $file_to_write
print_debug "Created new file"

echo "  system = \"$systemValue\";" >> $file_to_write
print_debug "Wrote system in file"

echo "}" >> $file_to_write
print_debug "Finished writing file"

