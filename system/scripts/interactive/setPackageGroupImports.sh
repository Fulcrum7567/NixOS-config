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

if [ -n "$name" -a ! -d "$path_to_dotfiles/user/packages/groups/$name" ]; then
    print_error "There is no group with the name \"$name\""
    name=""
fi

if [ -z "$name" ]; then
    name=$(find "$path_to_dotfiles/user/packages/groups" -type d -printf "%P\n" | grep -v '^$' | gum choose --header="What group do you want to edit?")
fi

if [ -z "$name" ]; then
    print_debug "No group selected, exiting"
	exit 1
fi

print_debug "Group set to \"$name\""


homeBinaryImports=""
homeGroupImports=""
systemBinaryImports=""
systemGroupImports=""


while IFS= read -r line; do
    # Remove leading/trailing spaces
    line=$(echo "$line" | sed 's/^ *//;s/ *$//')
    
    # Match binary imports
    case "$line" in
        *"../../binaries/home/"*)
            homeBinaryImports="$homeBinaryImports,$(echo "$line" | sed -n 's|.*../../binaries/home/\([a-zA-Z0-9_-]*\).nix.*|\1|p')"
            ;;
        *"../"*)
            homeGroupImports="$homeGroupImports,$(echo "$line" | sed -n 's|.*../\([a-zA-Z0-9_-]*\)/home.nix.*|\1|p')"
            ;;
    esac
done < "$path_to_dotfiles/user/packages/groups/$name/home.nix"



while IFS= read -r line; do
    # Remove leading/trailing spaces
    line=$(echo "$line" | sed 's/^ *//;s/ *$//')
    
    # Match binary imports
    case "$line" in
        *"../../binaries/system/"*)
            systemBinaryImports="$systemBinaryImports,$(echo "$line" | sed -n 's|.*../../binaries/system/\([a-zA-Z0-9_-]*\).nix.*|\1|p')"
            ;;
        *"../"*)
            systemGroupImports="$systemGroupImports,$(echo "$line" | sed -n 's|.*../\([a-zA-Z0-9_-]*\)/system.nix.*|\1|p')"
            ;;
    esac
done < "$path_to_dotfiles/user/packages/groups/$name/system.nix"

homeBinaryImports=$(echo "$homeBinaryImports" | sed 's/^,//')
homeGroupImports=$(echo "$homeGroupImports" | sed 's/^,//')
systemBinaryImports=$(echo "$systemBinaryImports" | sed 's/^,//')
systemGroupImports=$(echo "$systemGroupImports" | sed 's/^,//')


homeBinarySelected=$(find "$path_to_dotfiles/user/packages/binaries/home" -type f -printf "%P\n" | sed 's/\.nix$//' | gum choose --no-limit --header="What (home) binaries would you like to include?" --selected="$homeBinaryImports")
systemBinarySelected=$(find "$path_to_dotfiles/user/packages/binaries/system" -type f -printf "%P\n" | sed 's/\.nix$//' | gum choose --no-limit --header="What (system) binaries would you like to include?" --selected="$systemBinaryImports")

groupsSelected=$(find "$path_to_dotfiles/user/packages/groups" -type d ! -name "$name" -printf "%P\n" | grep -v '^$' | gum choose --no-limit --header="What groups would you like to inlude?" --selected="$homeGroupImports")


home_imports="imports = ["
for bin in $homeBinarySelected; do
    home_imports="$home_imports\n   ../../binaries/home/$bin.nix"
done

home_imports="$home_imports\n"

for grp in $groupsSelected; do
    home_imports="$home_imports\n   ../$grp/home.nix"
done

home_imports="$home_imports\n];"

tmp_file=$(mktemp)

# Preserve file structure and replace imports while keeping position
awk -v home_imports="$home_imports" 'BEGIN {in_block=0} 
    /imports = \[/ {in_block=1; print home_imports; next} 
    /];/ && in_block {in_block=0; next} 
    !in_block {print}' "$path_to_dotfiles/user/packages/groups/$name/home.nix" > "$tmp_file"

# Move temporary file back to original
mv "$tmp_file" "$path_to_dotfiles/user/packages/groups/$name/home.nix"


system_imports="imports = ["
for bin in $systemBinarySelected; do
    system_imports="$system_imports\n   ../../binaries/system/$bin.nix"
done

system_imports="$system_imports\n"

for grp in $groupsSelected; do
    system_imports="$system_imports\n   ../$grp/system.nix"
done

system_imports="$system_imports\n];"

tmp_file=$(mktemp)

# Preserve file structure and replace imports while keeping position
awk -v system_imports="$system_imports" 'BEGIN {in_block=0} 
    /imports = \[/ {in_block=1; print system_imports; next} 
    /];/ && in_block {in_block=0; next} 
    !in_block {print}' "$path_to_dotfiles/user/packages/groups/$name/system.nix" > "$tmp_file"

# Move temporary file back to original
mv "$tmp_file" "$path_to_dotfiles/user/packages/groups/$name/system.nix"

