#!/bin/bash

# Function to print usage information
usage() {
    echo "Usage: $0 --path-to-dotfiles|-p <path> --hostname|-n <hostname> [--username|-u <username>] [--skip-confirm|-s]"
    exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --path-to-dotfiles|-p) path_to_dotfiles="$2"; shift ;;
        --hostname|-n) hostname="$2"; shift ;;
        --username|-u) username="$2"; shift ;;
        --skip-confirm|-s) skip_confirm=true ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# Ensure required arguments are provided
if [[ -z "$path_to_dotfiles" || -z "$hostname" ]]; then
    echo "Error: --path-to-dotfiles and --hostname are required"
    usage
fi

# Define file paths
host_dir="${path_to_dotfiles}/hosts/${hostname}"
hardware_config_file="${host_dir}/hardware-configuration.nix"
settings_file="${host_dir}/settings.nix"

# Ensure the hardware configuration file exists
if [[ ! -f "$hardware_config_file" ]]; then
    echo "Error: hardware-configuration.nix not found in ${host_dir}"
    exit 1
fi

# Extract the 'system' value from hardware-configuration.nix
system_default=$(grep -oP 'nixpkgs\.hostPlatform = lib\.mkDefault "\K[^"]+' "$hardware_config_file")

# Check if --username is provided, otherwise prompt for it
if [[ -z "$username" ]]; then
    username_default="fulcrum"
    if [[ "$skip_confirm" != true ]]; then
        read -p "What value should user be? (default: ${username_default}): " username
    fi
    username="${username:-$username_default}"
fi

# Ask for confirmation to use default values, unless --skip-confirm is passed
if [[ "$skip_confirm" != true ]]; then
    read -p "What value should system be? (default: ${system_default}): " system
    system="${system:-$system_default}"
else
    system="${system_default}"
fi

# Ensure the host directory exists, create it if it doesn't
mkdir -p "$host_dir"

# Write to the settings.nix file
cat <<EOF > "$settings_file"
{
  system = "$system";
  user = "$username";
}
EOF

echo "settings.nix created at ${settings_file}"
