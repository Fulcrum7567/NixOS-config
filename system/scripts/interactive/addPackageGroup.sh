#!/bin/sh

path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")
debug=false
overwrite=false
no_usage=false
no_edit=false
no_add=false


cmd_debug=""
cmd_overwrite=""
cmd_no_usage=""
cmd_group=""


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


get_group() {
	cmd_group=""
	while [ -z "$cmd_group" ]; do
		read -p "What is the name of the group? " cmd_group
		if [ -z "$cmd_group" ]; then
			echo "Please enter a valid group name"
		fi
	done
}

add_to_git() {
    if [ "$no_add" = false ]; then
        sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to add your changes to git?" --default yes
        if [ "$?" = 0 ]; then
            git add $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix")
            git commit -m "$1"
        fi
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
				cmd_group="$2"
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

if [ -z "$cmd_group" ]; then
	get_group
fi

while [ -f $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix") -a "$overwrite" = false ]; do
	echo "Warning: A group with the name \"$cmd_group\" already exists"
	sh $(realpath "$path_to_dotfiles/system/scripts/helper/getOption.sh") "Do you want to overwrite or edit the group?" overwrite/o edit/e --default cancel
	result="$?"
	if [ "$result" = 1 ]; then
        overwrite=true
        cmd_overwrite="--force"
    elif [ "$result" = 2 ]; then
        $EDITOR $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix")
        print_debug "File opened for editing"
        add_to_git "[AM]: Edited \"$cmd_group\"."
        exit 1
    else
        get_group
    fi
done

if [ "$overwrite" = true -a -f $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix") ]; then
    rm $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix")
fi


cp $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/group.nix") $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix")


if [ "$no_edit" = false ]; then
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to edit \"$cmd_group\"?"
    if [ "$?" = 0 ]; then
        $EDITOR $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix")
    fi
fi

add_to_git "[AM]: Added package group \"$cmd_group\"."

