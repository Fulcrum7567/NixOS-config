#!/bin/sh

path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")
no_usage=false
debug=false

basic=false
hostname=""

files_to_check="additionalConfig.nix additionalHome.nix hostSettings.nix hostConfigs/configuration.nix hostConfigs/hardware-configuration.nix"

print_usage_force() {
	echo "Usage:"
	echo "	$0 <hostname> [option?]"
	echo "Or:"
	echo "	$0 --help, -h			Show this message and exit"
	echo ""
	echo "Options:"
	echo "	--basic, -b			Only check for the basic dir"
	echo ""
	echo "	--no-usage, -u			Don't show usage after an error"
	echo "	--debug, -d 			Show debug messages"
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

if [ "$#" -lt 1 ]; then
	print_error "No hostname given"
	print_usage
	exit 1
fi

if [ "$1" = "--help" -o "$1" = "-h" ]; then
    print_usage_force
    exit 0
else
	hostname=$1
	shift
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --debug|-d)
            debug=true
            ;;
        --no-usage|-u)
            no_usage=true
            ;;
        --basic|-b)
			basic=true
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
	exit 1
fi

if [ -d "$path_to_dotfiles/hosts/$hostname" -a "$basic" = true ]; then
	exit 0
fi


err=0

for file in $files_to_check; do
	if [ ! -e "$path_to_dotfiles/hosts/$hostname/$file" ]; then
		print_debug "File \"$file\" not found"
		err=1
	fi
done

exit $err