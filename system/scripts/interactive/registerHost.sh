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


is_hostname_valid() {
    if [ -z "$(echo "$hostname" | xargs)" -o "$hostname" = "GLOBAL" ]; then
        return 1
    fi
    return 0
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
        --copy-config|-c)
            copy_config=true
            ;;
        --overwrite|-o)
            overwrite=true
            ;;
        --repair|-r)
            repair=true
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

if [ "$repair" = true -a "$overwrite" = true ]; then
    print_error "--repair and --overwrite can not be used together"
    exit 1
fi

if [ -z "$SUDO_USER" ]; then
    echo "Warning: This script needs sudo rights!"
fi

if ! sudo -v 2>/dev/null; then
    echo "Error: This script needs sudo rights!"
    print_usage
    exit 2
fi


if ! is_hostname_valid && [ "$hostname_given" = true ]; then
    print_error "Hostname \"$hostname\" is invalid"
fi

while ! is_hostname_valid; do
    hostname=$(gum input --prompt="What is the name of the host? " --placeholder="Enter name...")
    if [ -z "$(echo "$hostname" | xargs)" ]; then
        print_error "Hostname must not be empty"
        continue
    fi
    if [ "$hostname" = "GLOBAL" ]; then
        print_error "The hostname \"GLOBAL\" is reserved"
        continue
    fi
done

print_debug "Hostname set to \"$hostname\""


sh "$(realpath "$path_to_dotfiles/system/scripts/helper/isHostRegistered.sh")" "$hostname" "--basic" $cmd_debug $cmd_no_usage
result=$?

if [ $result -eq 0 -a "$repair" = false -a "$overwrite" = false ]; then
    # exists and ok
    echo "A host with the name \"$hostname\" already exists. Do you want to repair or overwrite it?"
    choice=$(gum choose Repair Overwrite Cancel)
    if [ "$choice" = "Repair" ]; then
        repair=true
        sh "$path_to_dotfiles/system/scripts/interactive/repairHost.sh" "--hostname" "$hostname" $cmd_debug $cmd_no_usage
        if [ $? = 0 ]; then
            print_debug "Host repaired"
        else
            print_debug "Repair failed, cancelling..."
            exit 1
        fi
    elif [ "$choice" = "Overwrite" ]; then
        overwrite=true
        print_debug "Overwriting host"
    else
        print_debug "Cancelled"
        exit 1
    fi
fi

if [ -d "$path_to_dotfiles/hosts/$hostname" -a "$overwrite" = true ]; then
    sudo rm -rf "$path_to_dotfiles/hosts/$hostname"
    print_debug "Removed old host"
fi

if [ ! -d "$path_to_dotfiles/hosts/$hostname" ]; then
    mkdir "$path_to_dotfiles/hosts/$hostname"
    rsync -a --ignore-existing "$path_to_dotfiles/system/scripts/presets/hosts/hostname/" "$path_to_dotfiles/hosts/$hostname/"
    print_debug "Copied host files"
    mkdir "$path_to_dotfiles/hosts/$hostname/hostConfigs"
    gum spin -- sudo nixos-generate-config --force --dir $(realpath "$path_to_dotfiles/hosts/$hostname/hostConfigs/") 2>/dev/null
    print_debug "Generated configuration files"
    sh "$path_to_dotfiles/system/scripts/interactive/setHostSettings.sh" "--hostname" "$hostname" $cmd_debug $cmd_no_usage
    if [ "$?" -ne 0 ]; then
        print_error "Setting of host settings has failed! Please retry"
        exit 1
    fi
fi

if [ "$copy_config" = false ]; then
    gum confirm "Do you want to keep your configuration from /etc/nixos?" --default="No"
    if [ "$?" = 0 ]; then
        copy_config=true
    fi
fi

if [ "$copy_config" = true ]; then
    rm -rf "$path_to_dotfiles/hosts/$hostname/hostConfigs/configuration.nix"
    cp "/etc/nixos/configuration.nix" "$path_to_dotfiles/hosts/$hostname/hostConfigs/"
fi

if [ -f "$path_to_dotfiles/hosts/currentHost.nix" ]; then
    gum confirm "Do you want to set $hostname as current host?"
    if [ "$?" = 0 ]; then
        sh "$path_to_dotfiles/system/scripts/interactive/setCurrentHost.sh" "--hostname" "$hostname" $cmd_debug $cmd_no_usage
    fi
fi

echo "Successfully created host \"$hostname\""