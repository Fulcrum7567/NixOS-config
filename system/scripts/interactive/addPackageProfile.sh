#!/bin/sh

path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")
debug=false
overwrite=false
no_usage=false
no_edit=false
no_add=false
name=""


print_usage_force() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
	echo "  --name, -n <group name>		Pre set group name"
    echo "  --overwrite, -o        			Overwrite group if it already exists"
    echo "  --no-edit, -e                   Don't ask to edit after creating new group"
    echo "  --debug, -d         			Enable debug mode"
    echo "  --no-usage, -u      			Don't show usage after an error"
    echo "  --help, -h          			Display this help message and exit"
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


get_name() {
	while [ -z "$name" ]; do
		read -p "What is the name of the profile? " name
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
        --overwrite|-o)
			overwrite=true
            cmd_overwrite="--force"
            ;;

        --no-usage|-u)
            no_usage=true
			cmd_no_usage="--no-usage"
            ;;
        --no-edit|-e)
            no_edit=true
            ;;
        --no-add)
            no_add=true
            ;;
		--name|-n)
			if [ -n "$2" ]; then
				name="$2"
				shift
			else
				echo "Error: --name or -n requires a name."
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


get_name

if [ -f "$path_to_dotfiles/user/packages/profiles/$name.nix" ]; then
	echo "Error: A package profile with the name \"$name\" already exists."
	sh $(realpath "$path_to_dotfiles/system/scripts/helper/getOption.sh") "Do you want to overwrite or edit it?" overwrite/o edit/e --defulat edit
	result="$?"
	if [ "$result" = 1 ]; then
		rm -f $(realpath "$path_to_dotfiles/user/packages/profiles/$name.nix")
	elif [ "$result" = 2 ]; then
		$EDITOR $(realpath "$path_to_dotfiles/user/packages/profiles/$name.nix")
	else
		echo "Cancelled..."
		exit 1
	fi
else
	mkdir -p $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/")
	cp $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/profile.nix") "$path_to_dotfiles/user/packages/profiles/$name.nix"
	sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to edit the file?" --default yes
	if [ "$?" = 0 ]; then
		$EDITOR $(realpath "$path_to_dotfiles/user/packages/profiles/$name.nix")
	fi
fi


