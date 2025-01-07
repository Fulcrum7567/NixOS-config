#!/bin/sh

# <package name> --group <group name> 

path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")
debug=false
overwrite=false
no_usage=false
no_edit=false
binary=false
pattern=""
no_add=false


cmd_debug=""
cmd_overwrite=""
cmd_no_usage=""
cmd_name=""
cmd_group=""
cmd_state=""


print_usage_force() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
	echo "  --group, -g <group name>		Pre set group name"
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
    while [ -z "$cmd_name" ]; do
        read -p "What is the name of the package you want to install? " cmd_name
    done
}

get_group() {
    while [ -z "$cmd_group" ]; do
        read -p "What is the name of the group? " cmd_group
    done
}

get_pattern() {
    case "$cmd_state" in
        default)
            pattern=".*home.packages = with pkgs; \[.*"
            ;;
        stable)
            pattern=".*\] \+\+ with pkgs-stable; \[.*"
            ;;
        unstable)
            pattern=".*\] \+\+ with pkgs-unstable; \[.*"
            ;;
        *)
            pattern=""
            ;;
    esac
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
        --binary|-b)
            binary=true
            ;;
        --no-add)
            no_add=true
            ;;
        --group|-g)
            if [ -n "$2" ]; then
                cmd_group="$2"
                shift
            else
                echo "Error: --group / -g requires a name"
                print_usage
                exit 1
            fi
            ;;
		--name|-n)
			if [ -n "$2" ]; then
				cmd_name="$2"
				shift
			else
				echo "Error: --name / -n requires a name."
				print_usage
                exit 1
			fi
			;;
        --state|s)
            if [ -n "$2" ]; then
                cmd_state="$2"
                shift
            else
                echo "Error: --state / -s requires a name."
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



if [ -n "$cmd_group" -a "$binary" = true ]; then
    echo "Error: Group and binary option can not be used together"
    print_usage
    exit 1
fi

if [ -z "$cmd_group" -a "$binary" = false ]; then
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getOption.sh") "Do you want to install the package as binary or in a group?" group/g binary/b
    result="$?"
    if [ "$result" = 1 ]; then
        get_group
    elif [ "$result" = 2 ]; then
        binary=true
    else
        echo "Cancelled..."
        exit 1
    fi
fi

get_name

package_dir=$(sh $(realpath "$path_to_dotfiles/system/scripts/helper/isPackageInstalled.sh") "$cmd_name" --path)

if [ "$binary" = true -a -n "$package_dir" ]; then
    echo "Error: A binary package of \"$cmd_name\" already exists."
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to edit the source file?" --default yes
    if [ "$?" = 0 ]; then
        $EDITOR $package_dir
        exit 0
    fi
    echo "Cancelled..."
    exit 1
fi


if [ "$package_dir" = $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix") ]; then
    echo "Error: The package \"$cmd_name\" is already installed in group \"$cmd_group\"."
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to edit the source file?" --default yes
    if [ "$?" = 0 ]; then
        $EDITOR $package_dir
        exit 0
    fi
    echo "Cancelled..."
    exit 1
fi


if [ -n "$cmd_group" -a ! -f $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix") ]; then
    echo "There is no group with the name \"$cmd_group\"."
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to create the group?" --default yes
    if [ "$?" = 0 ]; then
        sh $(realpath "$path_to_dotfiles/system/scripts/interactive/addPackageGroup.sh") --name "$cmd_group" --no-edit
    else
        echo "Cancelled..."
        exit 1
    fi
fi


if [ -n "$cmd_state" ]; then
    get_pattern
    if [ -z "$pattern" ]; then
        echo "Error: \"$cmd_state\" is not a valid state"
    fi
fi

if [ -z "$pattern" ]; then
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getOption.sh") "What state should the package be?" default/d stable/s unstable/u --default default
    result="$?"
    if [ "$result" = 1 ]; then
        pattern=".*home.packages = with pkgs; \[.*"
        cmd_state="default"
    elif [ "$result" = 2 ]; then
        pattern=".*\] \+\+ with pkgs-stable; \[.*"
        cmd_state="stable"
    elif [ "$result" = 3 ]; then
        PATTERN=".*\] \+\+ with pkgs-unstable; \[.*"
        cmd_state="unstable"
    else
        echo "Cancelled..."
        exit 1
    fi
fi

insertion="\        $cmd_name \n"


if [ -n "$cmd_group" ]; then
    sed -i "/$pattern/a $insertion" $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix")
    print_debug "Package \"$cmd_name\" successfully added to \"$cmd_group\""
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to edit the source file?" --default yes
    if [ "$?" = 0 ]; then
        $EDITOR $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix")
    fi
    git_message="[AM]: Added package \"$cmd_name\" to group \"$cmd_group\"."
fi

if [ "$binary" = true ]; then
    if [ "$cmd_state" = "default" ]; then
        cp $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/defaultBin.nix") $(realpath "$path_to_dotfiles/user/packages/binaries/$cmd_name.nix")
        pattern=".*home.packages = with pkgs; \[.*"
        sed -i "/$pattern/a $insertion" $(realpath "$path_to_dotfiles/user/packages/binaries/$cmd_name.nix")
    elif [ "$cmd_state" = "stable" ]; then
        cp $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/stableBin.nix") $(realpath "$path_to_dotfiles/user/packages/binaries/$cmd_name.nix")
        pattern=".*home.packages = with pkgs-stable; \[.*"
        sed -i "/$pattern/a $insertion" $(realpath "$path_to_dotfiles/user/packages/binaries/$cmd_name.nix")
    elif [ "$cmd_state" = "unstable" ]; then
        cp $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/unstableBin.nix") $(realpath "$path_to_dotfiles/user/packages/binaries/$cmd_name.nix")
        pattern=".*home.packages = with pkgs-unstable; \[.*"
        sed -i "/$pattern/a $insertion" $(realpath "$path_to_dotfiles/user/packages/binaries/$cmd_name.nix")
    fi
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to edit the source file?" --default yes
    if [ "$?" = 0 ]; then
        $EDITOR $(realpath "$path_to_dotfiles/user/packages/binaries/$cmd_name.nix")
    fi
    git_message="[AM]: Added package \"$cmd_name\" as binary."
fi

# Add changes to git
if [ "$no_add" = false ]; then
    sh $(realpath "$path_to_dotfiles/system/scripts/helper/getConfirmation.sh") "Do you want to add your changes to git?" --default yes
    if [ "$?" = 0 ]; then
        git add $(realpath "$path_to_dotfiles/user/packages/groups/$cmd_group.nix")
        git commit -m "$git_message"
    fi
fi




