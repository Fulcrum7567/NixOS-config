#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")

cmd_debug=""
cmd_no_usage=""


print_usage_force() {
    echo "Usage:" 
    echo "  $0 [option?]"
    echo "Or:"
    echo "  $0 --help, -h      Show this message and exit"
    echo ""
    echo "Options:"
	echo "  --name,    	   -n <group name>   Pre set group name"
	echo "  --no-git, 	   -g                Do not add to git"
    echo ""
    echo "  --no-usage, -u                     Don't show usage after an error"
    echo "  --debug,    -d                     Enable debug mode"
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

edit_group() {
    res=$(gum choose Home System Cancel --header="What part of the group do you want to edit?")
    if [ "$res" = "Home" ]; then
        $EDITOR "$path_to_dotfiles/user/packages/groups/$name/home.nix"
    elif [ "$res" = "System" ]; then
        $EDITOR "$path_to_dotfiles/user/packages/groups/$name/system.nix"
    else
        exit 2
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
        --no-edit|-n)
            no_edit=true
            ;;
		--no-git|-g)
			no_git=true
			;;
		--name|-n)
			if [ -n "$2" ]; then
				name="$2"
				shift
			else
				print_error "--name, -n requires a group name"
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


if [ -z "$name" ]; then
	name=$(gum input --prompt="What is the name of the package group? " --placeholder="Enter name...")
fi

if [ -z "$name" ]; then
	exit 1
fi

print_debug "Name set to \"$name\""


if [ -d "$path_to_dotfiles/user/packages/groups/$name" ]; then
    if [ "$overwrite" = false ]; then
        resuslt=$(gum choose Overwrite Edit Cancel --header="There already exists a group with the name \"$name\". Do you want to overwrite or edit it?")
        if [ "$result" = "Edit" ]; then
            edit_group
            no_edit=true
        elif [ "$result" = "Overwrite" ]; then
            overwrite=true
        else
            exit 1
        fi
    fi
    if [ "$overwrite" = true ]; then
        rm -rf "$path_to_dotfiles/user/packages/groups/$name/"
        print_debug "Removed group \"$name\""
    fi
fi

if [ ! -d "$path_to_dotfiles/user/packages/groups/$name" ]; then
    new=true
    mkdir "$path_to_dotfiles/user/packages/groups/$name"
    cp "$path_to_dotfiles/system/scripts/presets/user/packages/system/group.nix" "$path_to_dotfiles/user/packages/groups/$name/system.nix"
    cp "$path_to_dotfiles/system/scripts/presets/user/packages/home/group.nix" "$path_to_dotfiles/user/packages/groups/$name/home.nix"
fi

if [ "$no_edit" = false ]; then
    gum confirm "Do you want to edit the group?"
    result=$?
    if [ "$result" = 0 ]; then
        edit_group
    fi
fi


if [ "$no_git" = false ]; then
    gum confirm "Do you want to add your edits to git?"
    result=$?
    if [ $result -eq 1 ]; then
        no_git=true
    fi
fi

if [ "$no_git" = false ]; then
    git add "$path_to_dotfiles/user/packages/groups/$name/"
    print_debug "Added to git"
    if [ "$new" = true ]; then
        git commit -m "[Auto generated] Added package group \"$name\""
    else
        git commit -m "[Auto generated] Edited package group \"$name\""
    fi
fi


: '

if [ -f "$path_to_dotfiles/user/packages/groups/$name/$type.nix" ]; then
	if [ "$overwrite" = false ]; then
		result=$(gum choose Overwrite Edit Cancel --header="There already exists a group with the name \"$name\". Do you want to overwrite or edit it?")
		if [ "$result" = "Edit" ]; then
			$EDITOR $(realpath "$path_to_dotfiles/user/packages/groups/$name/$type.nix")
			no_edit=true
		elif [ "$result" = "Overwrite" ]; then
			overwrite=true
		else
			exit 1
		fi
	fi
	if [ "$overwrite" = true ]; then
		rm -rf "$path_to_dotfiles/user/packages/groups/$name/$type.nix"
		print_debug "Removed group \"$name\""
	fi
fi

if [ ! -f "$path_to_dotfiles/user/packages/groups/$name/$type.nix" ]; then

	cp $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/$type/group.nix") "$path_to_dotfiles/user/packages/groups/$name/$type.nix"
    print_debug "Copied file"
fi


if [ "$no_edit" = false ]; then
    
	if [ $result -eq 0 ]; then
		$EDITOR $(realpath "$path_to_dotfiles/user/packages/groups/$name/$type.nix")
        print_debug "Edited group"
	fi
fi

if [ "$no_git" = false ]; then
	gum confirm "Do you want to add your edits to git?"
    result=$?
	if [ $result -eq 1 ]; then
		no_git=true
	fi
fi

if [ "$no_git" = false ]; then
	git add "$path_to_dotfiles/user/packages/groups/$name/$type.nix"
    print_debug "Added to git"
	if [ "$new" = true ]; then
		git commit -m "[Auto generated] Added package group \"$name\""
	else
		git commit -m "[Auto generated] Edited package group \"$name\""
	fi
fi
'