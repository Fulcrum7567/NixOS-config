#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")

cmd_debug=""
cmd_no_usage=""

hostname=""
hostname_given=false
overwrite=false
repair=false
copy_config=false


print_usage_force() {
    echo "Usage:" 
    echo "  $0 [option?]"
    echo "Or:"
    echo "  $0 --help, -h      Show this message and exit"
    echo ""
    echo "Options:"
	echo "  --hostname,    -H <hostName>	  Pre set hostname"
    echo "  --overwrite,   -o               Overwrite host if it already exists"
    echo "  --repair,      -r               Repair host if it already exists"
    echo "  --copy-config, -c               Copy old config from /etc/nixos"              
    echo ""
    echo "  --no-usage, -u                  Don't show usage after an error"
    echo "  --debug,    -d                  Enable debug mode"
    echo ""
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

print_error() {
    echo "[Error]: $1"
}


select_hostname() {
    hostname=$(find "$path_to_dotfiles/hosts/" -maxdepth 1 -type d ! -name "GLOBAL" ! -name ".*" -printf "%P\n" | grep -v '^$' | gum choose)
    if [ -z "$hostname" ]; then
        exit 1
    fi
}

check_abortion() {
    if [ -z "$1" ]; then
        exit 1
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
        --no-usage|-u)
            no_usage=true
            cmd_no_usage="--no-usage"
            ;;
		--hostname|-H)
			if [ -n "$2" ]; then
				hostname="$2"
                hostname_given=true
				shift
			else
				print_error "--hostname, -H requires a hostname"
				print_usage
                exit 1
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

hosts=$(find "$path_to_dotfiles/hosts/" -maxdepth 1 -type d ! -name "GLOBAL" ! -name ".*" -printf "%P\n")
if [ -z "$hosts" ]; then
    print_error "No hosts found! Please create one using registerHost.sh"
    exit 1
fi

if [ -z "$hostname" ]; then
    select_hostname
else
    sh "$path_to_dotfiles/system/scripts/helper/isHostRegistered.sh" "$hostname" "--basic" $cmd_debug $cmd_no_usage
    result=$?
    if [ "$result" -ne 0 ]; then
        print_error "There seems to be an error with the host \"$hostname\". Please repair it"
        select_hostname
    fi
fi

print_debug "Host selected: $hostname"

hc_file="$path_to_dotfiles/hosts/$hostname/hostConfigs/hardware-configuration.nix"
system_type_default=$(grep -oP 'nixpkgs\.hostPlatform = lib\.mkDefault "\K[^"]+' "$hc_file")
system_type=$(gum input --placeholder="Default: $system_type_default" --prompt="What is the type of your system? ")
if [ -z $system_type ]; then
    system_type=$system_type_default
fi
check_abortion $system_type
print_debug "System type set to \"$system_type\""

system_state=$(gum choose stable unstable --header="What state do you want your system to be?")
check_abortion $system_state
print_debug "System state set to \"$system_state\""

default_package_state=$(gum choose stable unstable --header="What state do you want your packages to be on default?")
check_abortion $default_package_state
print_debug "Package default state set to \"$default_package_state\""

gpu_manufacturer=$(gum choose nvidia amd custom... --header="What is the manufacturer of your graphics card?")
if [ "$gpu_manufacturer" = "custom..." ]; then
    gpu_manufacturer=$(gum input --prompt="What is your gpu manufacturer? " --placeholder="Enter name...")
fi
check_abortion $gpu_manufacturer
print_debug "GPU manufacturer set to \"$gpu_manufacturer\""

package_profile=$(find "$path_to_dotfiles/user/packages/profiles" -type f -printf "%P\n" | sed 's/\.nix$//' | gum choose --header="What package profile do you want to use?")
check_abortion $package_profile
print_debug "Package profile set to \"$package_profile\""

desktop=$(find "$path_to_dotfiles/user/desktops/profiles" -type f -printf "%P\n" | sed 's/\.nix$//' | gum choose --header="What desktop profile do you want to use?")
check_abortion $desktop
print_debug "Desktop profile set to \"$desktop\""

theme=$(find "$path_to_dotfiles/user/themes" -type d -printf "%P\n" | grep -v '^$' | gum choose --header="What theme do you want to use?")
check_abortion $theme
print_debug "Theme set to \"$theme\""

echo "{
    system = \"$system_type\";
    systemState = \"$system_state\";
    defaultPackageState = \"$default_package_state\";
    gpuManufacturer = \"$gpu_manufacturer\";
    packageProfile = \"$package_profile\";
    desktop = \"$desktop\";
    theme = \"$theme\";
}" > "$path_to_dotfiles/hosts/$hostname/hostSettings.nix"