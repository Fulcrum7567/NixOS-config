#!/bin/sh


debug=false
no_usage=false
path_to_dotfiles="$PWD/../../../"
full=false
no_new_settings=false

cmd_hostname=""
cmd_debug=""
cmd_no_new_config=""
cmd_force=""
cmd_no_usage=""
cmd_full=""

print_usage_force() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
	echo "  --hostname, -h <hostName>	Pre set host name"
    echo "  --full, -f                  Also repair host settings"
    echo "  --debug, -d         		Enable debug mode"
    echo "  --no-usage, -u      		Don't show usage after an error"
    echo "  --help, -h          		Display this help message and exit"
    echo
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

get_hostname() {
	while [ -z "$cmd_hostname" ]; do
		read -p "What host do you want to repair? " cmd_hostname
	done
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
        --full|-f)
            full=true
            cmd_full="--no-settings"
            ;;
        --no-usage|-u)
            no_usage=true
			cmd_no_usage="--no-usage"
            ;;
        --no-new-settings)
            no_new_settings=true
            ;;
		--hostname|-n)
			if [ -n "$2" ]; then
				cmd_hostname="$2"
				shift
			else
				echo "Error: --hostname or -n requires a name."
				print_usage
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


if [ -z "$SUDO_USER" ]; then
    echo "Warning: This script needs sudo rights!"
fi

if ! sudo -v 2>/dev/null; then
    echo "Error: This script needs sudo rights!"
    print_usage
    exit 2
fi

if [ -z "$cmd_hostname" ]; then
	get_hostname
fi

while [ ! -d $(realpath "$path_to_dotfiles/hosts/$cmd_hostname") ]; do
	echo "Error: There is no host registered with the name \"$cmd_hostname\""
	cmd_hostname=""
	get_hostname
done

if [ -z "$cmd_full" ]; then
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to reset the host settings also?" --default no
    if [ "$?" = 0 ]; then
        cmd_full="--no-settings"
        full=true
    elif [ ! "$?" = 1 ]; then
        print_debug "Cancelled..."
        exit 2
    fi
fi

# create host backup
sudo sh $(realpath "$path_to_dotfiles/system/scripts/raw/createHostBackup.sh") "$cmd_hostname" $cmd_debug --no-usage
print_debug "Host backup generated"

# delete host completely
sudo rm -rf $(realpath "$path_to_dotfiles/hosts/$cmd_hostname/")
print_debug "Host \"$cmd_hostname\" deleted"

# regenerate host
sudo sh $(realpath "$path_to_dotfiles/system/scripts/raw/registerHost.sh") "$cmd_hostname" --force $cmd_debug --no-usage
print_debug "Regenerated host"


sudo sh $(realpath "$path_to_dotfiles/system/scripts/raw/loadHostBackup.sh") "$cmd_hostname" $cmd_debug --no-usage --no-configs $cmd_full
print_debug "Restored host backup"

if [ "$full" = true -a "$no_new_settings" = false ]; then
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to regenerate the host settings?" --default yes
    if [ ! "$?" = 0 ]; then
        exit 0
    fi
    sh $(realpath "$path_to_dotfiles/system/scripts/raw/createBasicHostSettings.sh") "$cmd_hostname" $cmd_debug $cmd_no_usage
    print_debug "Generated basic host settings"
    sh $(realpath "$path_to_dotfiles/system/scripts/raw/setHostSettings.sh") "$cmd_hostname" $cmd_debug $cmd_no_usage
    print_debug "Host settings set for \"$cmd_hostname\""
fi