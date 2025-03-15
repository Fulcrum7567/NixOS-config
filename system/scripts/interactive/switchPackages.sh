#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")

name=""
host=""
no_rebuild=false


print_usage_force() {
    echo "Usage:" 
    echo "  $0 [option?]"
    echo "Or:"
    echo "  $0 --help, -h      Show this message and exit"
    echo ""
    echo "Options:"
	echo "  --name,       -n <package profile name>  Pre set name of new theme"
    echo "  --host,       -H <hotname>               Pre set the host"   
    echo "  --no-rebuild, -r                         Don't ask to rebuild"       
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
        --no-rebuild|-r)
            no_rebuild=true
            ;;
        --name|-n)
            if [ -n "$2" ]; then
                name="$2"
                shift
            else
                print_error "--name, -n requires a package profile name"
                print_usage
                exit 1
            fi
            ;;
        --host|-H)
            if [ -n "$2" ]; then
                host="$2"
                shift
            else
                print_error "--host, -H requires a host name"
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

if [ -n "$host" -a ! -d "$path_to_dotfiles/hosts/$host" ]; then
    print_error "There is no host with the name \"$host\""
    host=""
fi


if [ -z "$host" ]; then
    host=$(find "$path_to_dotfiles/hosts/" -maxdepth 1 -type d ! -name "GLOBAL" ! -name ".*" -printf "%P\n" | grep -v '^$' | gum choose --header="For what device do you want to change the theme?")
fi

if [ -z "$host" ]; then
    print_debug "No host selected, exiting"
    exit 2
fi

print_debug "Host set to \"$host\""

if [ -n "$name" -a ! -d "$path_to_dotfiles/user/packages/profiles/$name" ]; then
    print_error "There is no package profile with the name \"$name\""
    name=""
fi

if [ -z "$name" ]; then
    name=$(find "$path_to_dotfiles/user/packages/profiles" -type d -printf "%P\n" | grep -v '^$' | gum choose --header="What theme do you want to use?")
fi

if [ -z "$name" ]; then
    print_debug "No package profile selected, exiting"
    exit 2
fi

print_debug "Package profile set to \"$name\""

sed -i "s/^\s*packageProfile\s*=\s*\"[^\"]*\";/    packageProfile = \"$name\";/g" "$path_to_dotfiles/hosts/$host/hostSettings.nix"

print_debug "Set package profile of host \"$host\" to \"$name\""

if [ "$no_rebuild" = false ]; then
    gum confirm "Do you want to rebuild your system?"
    if [ "$?" = 0 ]; then
        sh "$path_to_dotfiles/system/scripts/interactive/rebuild.sh" "--full" $cmd_debug $cmd_no_usage
    fi
fi