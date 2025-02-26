#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")
cmd_debug=""
cmd_no_usage=""

hostname=""
minimal=false


print_usage_force() {
    echo "Usage:" 
    echo "  $0 [option?]"
    echo "Or:"
    echo "  $0 --help, -h      Show this message and exit"
    echo ""
    echo "Options:"
    echo "  --hostname,    -H <hostname>      Pre set hostname"
    echo "  --minimal,     -m                 Only reset minimum of files"
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

is_hostname_valid() {
    if [ -z "$(echo "$hostname" | xargs)" -o "$hostname" = "GLOBAL" ]; then
        return 1
    fi
    return 0
}

get_hostname() {
    hostname=$(gum input --prompt="What is the name of the host? " --placeholder="Enter name...")
	while ! is_hostname_valid; do
		print_error "Hostname \"$hostname\" is invalid"
        hostname=$(gum input --prompt="What is the name of the host? " --placeholder="Enter name...")
	done
    sh "$path_to_dotfiles/system/scripts/helper/isHostRegistered.sh" "$hostname" "--basic" $cmd_debug $cmd_no_usage
    result=$?
    if [ "$result" -ne 0 ]; then
        print_error "Hostname \"$hostname\" is unknown"
        get_hostname
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
        --minimal|-m)
            minimal=true
            ;;
		--hostname|-H)
			if [ -n "$2" ]; then
				hostname="$2"
				shift
			else
				print_error "--hostname, -H requires a hostname"
				print_usage
			fi
			;;
        *)
            print_error "Unknown argument '$1'."
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
    print_error "This script needs sudo rights!"
    print_usage
    exit 2
fi

if [ -z "$hostname" ]; then
	get_hostname
else
    sh "$path_to_dotfiles/system/scripts/helper/isHostRegistered.sh" "$hostname" "--basic" $cmd_debug $cmd_no_usage
    result=$?
    if [ "$result" -ne 0 ]; then
        get_hostname
    fi
fi

print_debug "Host selected: $hostname"

selected_files="./hostConfigs/hardware-configuration.nix"

if [ "$minimal" = false ]; then
    selected_files=$(find "$path_to_dotfiles/hosts/$hostname" -type f -printf "./%P\n" | gum choose --header="Choose files you want to reset:" --no-limit --selected=./hostConfigs/hardware-configuration.nix)
fi

echo "$selected_files" | xargs -I{} rm "$path_to_dotfiles/hosts/$hostname/{}"
print_debug "Deleted files: 
$selected_files"

if [ -f "$path_to_dotfiles/hosts/$hostname/hostConfigs/hardware-configuration.nix" ]; then
    rm -rf "$path_to_dotfiles/hosts/$hostname/hostConfigs/hardware-configuration.nix"
    print_debug "Removed hardware-configuration.nix file"
fi

hostSettingsRemoved=$([ ! -f "$path_to_dotfiles/hosts/$hostname/hostSettings.nix" ] && echo 1 || echo 0)
print_debug "Host settings removed: $hostSettingsRemoved"

if [ ! -d "$path_to_dotfiles/hosts/$hostname/hostConfigs" ]; then
    mkdir "$path_to_dotfiles/hosts/$hostname/hostConfigs/"
fi

if [ ! -f "$path_to_dotfiles/hosts/$hostname/hostConfigs/configuration.nix" ]; then
    sudo nixos-generate-config --force --dir $(realpath "$path_to_dotfiles/hosts/$hostname/hostConfigs/") 2>/dev/null
    print_debug "Generated configuration and hardware-configuration files"
else
    sudo nixos-generate-config --show-hardware-config > "$path_to_dotfiles/hosts/$hostname/hostConfigs/hardware-configuration.nix" 2>/dev/null
    print_debug "Generated hardware-configuration.nix file"
fi


rsync -a --ignore-existing "$path_to_dotfiles/system/scripts/presets/hosts/hostname/" "$path_to_dotfiles/hosts/$hostname/"
if [ "$?" = 0 ]; then
    print_debug "Successfully copied files"
else
    print_debug "Error copying files"
    exit 1
fi


if [ $hostSettingsRemoved ]; then
    sh "$path_to_dotfiles/system/scripts/interactive/setHostSettings.sh" "--hostname" "$hostname" $cmd_debug $cmd_no_usage
    print_debug "Host settings have been reset"
fi

exit 0