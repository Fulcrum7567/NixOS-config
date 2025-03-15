#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")

cmd_debug=""
cmd_no_usage=""

name=""
group=""
group_given=false
binary=false
binary_name=""
no_git=false
state=""
edited_file=""
home=false
system=false


print_usage_force() {
    echo "Usage:" 
    echo "  $0 [option?]"
    echo "Or:"
    echo "  $0 --help, -h                    Show this message and exit"
    echo ""
    echo "Options:"
	echo "  --name,    -n <package name>	              Pre set package name"
    echo "  --group,   -g <group name>                  Pre set group"
    echo "  --state,   -s <Stable | Unstable | Default> Pre set the package state"
    echo "  --home,    -H                               Set as home package"
    echo "  --system,  -S                               Set as system package"
    echo "  --binary,  -b                               Set up package as binary" 
    echo "  --no-git                                    Don't add edits to git"         
    echo ""
    echo "  --no-usage, -u                              Don't show usage after an error"
    echo "  --debug,    -d                              Enable debug mode"
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

add_to_git() {
    if [ "$no_git" = false ]; then
        gum confirm "Would you like to add your changes to git?"
        if [ "$?" = 0 ]; then
            git add "$1"
            git commit -m "[Auto generated] $2"
        fi
    fi
}

choose_group() {
    group=$(find "$path_to_dotfiles/user/packages/groups" -type f -printf "%P\n" | sed 's/\.nix$//' | awk 'END {print "NEW"} {print}' | gum choose --header="What desktop profile do you want to use?")
    if [ "$group" = "NEW" ]; then
        group=$(gum input --prompt="What should the name of the group be? " --placeholder="Enter name...")
        while [ "$group" = "NEW" ]; do
            print_error "The group name \"NEW\" is reserved."
            group=$(gum input --prompt="What should the name of the group be? " --placeholder="Enter name...")
        done
    fi
    if [ -z "$group" ]; then
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
        --binary|-b)
            binary=true
            ;;
        --no-git)
            no_git=true
            ;;
        --home|-H)
            home=true
            ;;
        --system|-S)
            system=true
            ;;
        --state|-s)
            if [ -n "$2" ]; then
                case "$2" in
                    Stable|Unstable|Default)
                        state="$2"
                        ;;
                    *)
                        print_error "Invalid state: \"$2\""
                        exit 2
                        ;;
                esac
            else
                print_error "--state, -s requires a state"
                exit 2
            fi
            ;;
        --group|-g)
            if [ -n "$2" ]; then
                group="$2"
                group_given=true
                shift
            else
                print_error "--group, -g requires a group name"
                print_usage
                exit 1
            fi
            ;;
		--name|-n)
			if [ -n "$2" ]; then
				name="$2"
				shift
			else
				print_error "--name, -n requires a package name"
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

if [ "$binary" = true -a "$group_given" = true ]; then
    print_error "Binary and group must not be used together"
    exit 2
fi

if [ "$system" = true -a "$home" = true ]; then
    print_error "--system and --home must not be used together"
    exit 2
fi


if [ -z "$name" ]; then
    name=$(gum input --prompt="What package would you like to install? " --placeholder="Enter name...")
fi

if [ -z "$name" ]; then
    print_debug "No name set, exiting..."
    exit 1
fi

if [ -z "$state" ]; then
    state=$(gum choose Default Stable Unstable --header="What state should the package be in?")
fi

if [ -z "$state" ]; then
    print_debug "No state selected, exiting"
    exit 1
fi

if [ "$system" = false -a "$home" = false ]; then
    result=$(gum choose Home System --header="As what type would you like to install the package?")
    case "$result" in
        Home)
            home=true
            ;;
        System)
            system=true
            ;;
        *)
            print_debug "Cancelled"
            exit 1
            ;;
    esac
fi

result=""

type=""
if [ "$home" = true ]; then
    type="home"
else
    type="system"
fi


if [ "$binary" = false -a -z "$group" ]; then
    result=$(gum choose Binary Group Cancel --header="Would you install the package as binary or in a group?")
    if [ "$result" = "Binary" ]; then
        binary=true
    elif [ "$result" = "Group" ]; then
        choose_group
    else
        exit 1
    fi
fi

insertion=$'\t\t'"$name"
pattern=""
message=""

if [ "$binary" = true ]; then
    binary_name=$(gum input --prompt="Under what name would you like to create a binary file? " --placeholder="Default: $name")
    if [ -z "$binary_name" ]; then
        binary_name="$name"
    fi
    if [ -f "$path_to_dotfiles/user/packages/binaries/$type/$binary_name.nix" ]; then
        gum confirm "A binary file with the name \"$binary_name\" already exists. Do you want to edit it?"
        if [ "$?" -eq 0 ]; then
            $EDITOR "$path_to_dotfiles/user/packages/binaries/$type/$binary_name.nix"
            print_debug "Edited file"
            add_to_git "$path_to_dotfiles/user/packages/binaries/$type/$binary_name.nix" "Edited"
            exit 0
        else
            exit 1
        fi
    fi
    
    case "$state" in
        Stable)
            cp $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/$type/stableBin.nix") $(realpath "$path_to_dotfiles/user/packages/binaries/$type/$binary_name.nix")
            if [ "$home" = true ]; then
                pattern=".*home.packages = with pkgs-stable; \[.*"
            else
                pattern=".*environment.systemPackages = with pkgs-stable; \[.*"
            fi
            ;;
        Unstable)
            cp $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/$type/unstableBin.nix") $(realpath "$path_to_dotfiles/user/packages/binaries/$type/$binary_name.nix")
            if [ "$home" = true ]; then
                pattern=".*home.packages = with pkgs-unstable; \[.*"
            else
                pattern=".*environment.systemPackages = with pkgs-unstable; \[.*"
            fi
            ;;
        Default)
            cp $(realpath "$path_to_dotfiles/system/scripts/presets/user/packages/$type/defaultBin.nix") $(realpath "$path_to_dotfiles/user/packages/binaries/$type/$binary_name.nix")
            if [ "$home" = true ]; then
                pattern=".*home.packages = with pkgs-default; \[.*"
            else
                pattern=".*environment.systemPackages = with pkgs-default; \[.*"
            fi
            ;;
        *)
            print_error "That should not have happened. Invalid state!"
            exit 1
            ;;
    esac
    sed -i "/$pattern/a $insertion" $(realpath "$path_to_dotfiles/user/packages/binaries/$type/$binary_name.nix")
    edited_file="$path_to_dotfiles/user/packages/binaries/$type/$binary_name.nix"
    message="Added package \"$name\" as binary to file \"$binary_name\""
fi


if [ -n "$group" ]; then
    if [ ! -f "$path_to_dotfiles/user/packages/groups/$group/$type.nix" ]; then
        sh "$path_to_dotfiles/system/scripts/interactive/addPackageGroup.sh" "--name" "$group" "--$type" "--no-edit" "--no-git" $cmd_debug $cmd_no_usage
        if [ "$?" -ne 0 ]; then
            print_error "Something went wrong while creating the group"
            exit 2
        fi
    fi
    case "$state" in
        Stable)
            pattern="with pkgs-stable; \["
            ;;
        Unstable)
            pattern="with pkgs-unstable; \["
            ;;
        Default)
            pattern="with pkgs-default; \["
            ;;
        *)
            print_error "That should not have happened. Invalid state!"
            exit 1
            ;;
    esac

    sed -i "/$pattern/ a\\
$insertion" "$path_to_dotfiles/user/packages/groups/$group/$type.nix"

    print_debug "Package \"$name\" successfully added to \"$group\""
    edited_file="$path_to_dotfiles/user/packages/groups/$group/$type.nix"
    message="Added package \"$name\" to group \"$group\""
fi

gum confirm "Do you want to edit the file?"
if [ "$?" -eq 0 ]; then
    $EDITOR "$edited_file"
fi


add_to_git "$edited_file" "$message"
























: '

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
    echo "  --no-edit, -e                   Dont ask to edit after creating new group"
    echo "  --debug, -d         			Enable debug mode"
    echo "  --no-usage, -u      			Dont show usage after an error"
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
            pattern=".*home.packages = with pkgs-default; \[.*"
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
        pattern=".*home.packages = with pkgs-default; \[.*"
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
        pattern=".*home.packages = with pkgs-default; \[.*"
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



'
