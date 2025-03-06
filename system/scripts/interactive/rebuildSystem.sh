#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")

full=false
home_manager=false
system=false
rebuild=""


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

if [ -z "$SUDO_USER" ]; then
    echo "Warning: This script needs sudo rights!"
fi

if ! sudo -v 2>/dev/null; then
    echo "Error: This script needs sudo rights!"
    print_usage
    exit 2
fi

if [ "$debug" = true ]; then
    gum spin --spinner="hamburger" --title="Rebuilding system..." --show-output -- sudo nixos-rebuild switch --flake "$path_to_dotfiles#system"
else
    gum spin --spinner="hamburger" --title="Rebuilding system..." -- sudo nixos-rebuild switch --flake "$path_to_dotfiles#system"
fi