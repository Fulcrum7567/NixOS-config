#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")
cmd_debug=""
cmd_no_usage=""

hostname=""


print_usage_force() {
    echo "Usage:" 
    echo "  $0 [option?]"
    echo "Or:"
    echo "  $0 --help, -h      Show this message and exit"
    echo ""
    echo "Options:"
    echo "  --hostname,    -H <hostname>      Pre set hostname"
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

hosts=$(find "$path_to_dotfiles/hosts/" -maxdepth 1 -type d ! -name "GLOBAL" ! -name ".*" -printf "%P\n" | grep -v '^$')

if [ -z "$hosts" ]; then
    print_error "No hosts found. Please create one using registerHost.sh"
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

if [ ! -f "$path_to_dotfiles/hosts/currentHost.nix" ]; then
    cp "$path_to_dotfiles/system/scripts/presets/hosts/currentHost.nix" "$path_to_dotfiles/hosts/"
    print_debug "Copied file"
    git add "$path_to_dotfiles/hosts/currentHost.nix"
    git update-index --assume-unchanged "$path_to_dotfiles/hosts/currentHost.nix"
    print_debug "Updated git index"
fi

sed -i 's/currentHost = "[^"]*";/currentHost = "'"$hostname"'";/' "$path_to_dotfiles/hosts/currentHost.nix"
print_debug "Replaced host name with $hostname"