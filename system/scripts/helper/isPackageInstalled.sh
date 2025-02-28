#!/bin/sh

path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")
debug=false
package_name=""
no_usage=false
return_path=false

print_usage_force() {
    echo "Usage: $0 <package name> [option]"
    echo
    echo "Returns 0 if not installed, 1 if in group, 2 if as binary"
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

print_path() {
    if [ "$return_path" = true ]; then
        echo "$1"
    fi
}


# Parse arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --help|-h)
            print_usage_force
            exit 0
            ;;
        --debug|-d)
            debug=true
            shift
            ;;
        --no-usage|-u)
            no_usage=true
            shift
            ;;
        --path|-p)
            return_path=true
            shift
            ;;
        *)
            if [ -z "$package_name" ]; then
                package_name=$(echo "$1" | tr 'A-Z' 'a-z')
                shift
            else
                echo "Error: Unexpected argument '$1'."
                exit 1
            fi
            ;;
    esac
done


# check binaries
if [ -f $(realpath "$path_to_dotfiles/user/packages/binaries/$package_name.nix") ]; then
    print_debug "Package \"$package_name\" found as binary"
    print_path $(realpath "$path_to_dotfiles/user/packages/binaries/$package_name.nix")
    exit 2
fi

# check groups
for nix_file in $(realpath "$path_to_dotfiles/user/packages/groups")/*.nix; do
    [ -f "$nix_file" ] || continue  # Skip if no .nix files
    if grep -qE "\b$package_name\b" "$nix_file"; then
        print_debug "Package \"$package_name\" found in \"$nix_file\""
        print_path $nix_file
        exit 1
    fi
done

print_debug "Package \"$package_name\" not found"
echo ""

exit 0

