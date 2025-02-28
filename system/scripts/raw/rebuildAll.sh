#!/bin/sh

debug=false
no_new_config=false
force=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")
test=false
build=false
no_add=false


print_usage_force() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  --debug, -d         Enable debug mode"
    echo "  --no-new-config     Don't regenerate \"configuration.nix\", \"hardware-configuration.nix\" will always be regenerated."
    echo "  --no-usage, -u      Don't show usage after an error"
    echo "  --help, -h          Display this help message and exit"
    echo
    echo "Examples:"
    echo "  $0 myHost --debug --skip-confirm"
    echo "  $0 myHost -d -s"
    echo "  $0 --help"
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

while [ $# -gt 0 ]; do
    case "$1" in
        --debug|-d)
            debug=true
            ;;
        --no-new-config)
            no_new_config=true
            ;;
        --build|-b)
            build=true
            cmd_build="--build"
            ;;
        --no-usage|-u)
            no_usage=true
            ;;
        --no-add)
            no_add=true
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
    echo "Error: Please call this script with sudo"
    print_usage
    exit 2
fi

if [ "$no_add" = false ]; then
    sudo -u "$SUDO_USER" sh $(realpath "$path_to_dotfiles/system/scripts/raw/gitAddAll.sh")
fi


sudo sh $(realpath "$path_to_dotfiles/system/scripts/raw/rebuildSystem.sh") "$cmd_build"
sudo -u "$SUDO_USER" sh $(realpath "$path_to_dotfiles/system/scripts/raw/rebuildHome.sh") "$cmd_build"