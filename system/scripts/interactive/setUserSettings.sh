#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")


print_usage_force() {
    echo "Usage:" 
    echo "  $0 [option?]"
    echo "Or:"
    echo "  $0 --help, -h      Show this message and exit"
    echo ""
    echo "Options:"
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
        *)
            echo "Error: Unknown argument '$1'."
            print_usage
            exit 1
            ;;
    esac
    shift
done

displayName=$(gum input --prompt="What is your display name? " --placeholder="Enter name...")
while [ -z "$displayName" ]; do
    print_error "Display name must not be empty"
    displayName=$(gum input --prompt="What is your display name? " --placeholder="Enter name...")
done
print_debug "Set display name to $displayName"


default_name=$(echo "$displayName" | tr '[:upper:]' '[:lower:]')
username=$(gum input --prompt="What is your user name? " --placeholder="Default: $default_name")
if [ -z "$username" ]; then
    username=$default_name
fi
print_debug "Set username to $username"


echo "{
    username = \"$username\";
    displayName = \"$displayName\";
}" > "$path_to_dotfiles/user/userSettings.nix"
