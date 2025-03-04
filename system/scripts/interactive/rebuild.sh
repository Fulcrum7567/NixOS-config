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
	echo "  --full,    -f                 Rebuild system and home-manager"
    echo "  --home-manager,   -H               Only rebuild home-manager"
    echo "  --system,      -s               Only rebuild system"            
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


rebuild_system() {
    if [ "$debug" = true ]; then
        gum spin --spinner="hamburger" --title="Rebuilding system..." --show-output -- sudo nixos-rebuild switch --flake "$path_to_dotfiles#system"
    else
        gum spin --spinner="hamburger" --title="Rebuilding system..." -- sudo nixos-rebuild switch --flake "$path_to_dotfiles#system"
    fi
}

rebuild_home() {
    if [ "$debug" = true ]; then
        gum spin --spinner="hamburger" --title="Rebuilding home-manager..." --show-output -- sudo -u "$SUDO_USER" home-manager switch --flake "$path_to_dotfiles#user"
    else
        gum spin --spinner="hamburger" --title="Rebuilding home-manager..." -- sudo -u "$SUDO_USER" home-manager switch --flake "$path_to_dotfiles#user"
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
        --full|-f)
            full=true
            rebuild="Full"
            ;;
        --home-manager|-H)
            home_manager=true
            rebuild="Home-manager"
            ;;
        --system|-s)
            system=true
            rebuild="System"
            ;;
        *)
            echo "Error: Unknown argument '$1'."
            print_usage
            exit 1
            ;;
    esac
    shift
done

count=0
[ "$full" = true ] && count=$((count + 1))
[ "$system" = true ] && count=$((count + 1))
[ "$home_manager" = true ] && count=$((count + 1))

if [ "$count" -gt 1 ]; then
    print_error "--full, --home-manager and --system must not be used together!"
    exit 2
fi

if [ -z "$SUDO_USER" ]; then
    echo "Warning: This script needs sudo rights!"
fi

if ! sudo -v 2>/dev/null; then
    echo "Error: This script needs sudo rights!"
    print_usage
    exit 2
fi

if [ "$count" -eq 0 ]; then
    rebuild=$(gum choose Full System Home-manager --header="What part of the system would you like to rebuild?")
    case "$rebuild" in
        Full|System|Home-manager)
            print_debug "Selected \"$rebuild\""
            ;;
        *)
            print_debug "Cancelled"
            exit 1
            ;;
    esac
fi

case "$rebuild" in
    Full)
        rebuild_system
        rebuild_home
        ;;
    System)
        rebuild_system
        ;;
    Home-manager)
        rebuild_home
        ;;
    *)
        print_error "Something went wrong, invalid state!"
        exit 2
        ;;
esac