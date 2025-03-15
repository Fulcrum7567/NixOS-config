#!/bin/sh

debug=false
no_usage=false
path_to_dotfiles=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../../")

host=""
no_rebuild=false
state=""


print_usage_force() {
    echo "Usage:" 
    echo "  $0 [option?]"
    echo "Or:"
    echo "  $0 --help, -h      Show this message and exit"
    echo ""
    echo "Options:"
	echo "  --state,      -s <stable | unstable>  Pre set new state"
    echo "  --host,       -H <hotname>            Pre set the host"   
    echo "  --no-rebuild, -r                      Don't ask to rebuild"       
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
        --state|-s)
            if [ -n "$2" ]; then
                case "$2" in
                    stable|unstable)
                        state="$2"
                        shift
                        ;;
                    *)
                    print_debug "Invalid state: \"$2\""
                    ;;
                esac
            else
                print_error "--state, -s requires a state"
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


if [ -z "$state" ]; then
    state=$(gum choose Stable Unstable --header="What state should the default state be?")
    state=$(echo "$state" | tr '[:upper:]' '[:lower:]')
fi

if [ -z "$state" ]; then
    print_debug "No state selected, exiting"
    exit 2
fi

print_debug "State set to \"$state\""

sed -i "s/^\s*defaultPackageState\s*=\s*\"[^\"]*\";/    defaultPackageState = \"$state\";/g" "$path_to_dotfiles/hosts/$host/hostSettings.nix"

print_debug "Set default package state of host \"$host\" to \"$state\""

if [ "$no_rebuild" = false ]; then
    gum confirm "Do you want to rebuild your system?"
    if [ "$?" = 0 ]; then
        sh "$path_to_dotfiles/system/scripts/interactive/rebuild.sh" "--full" $cmd_debug $cmd_no_usage
    fi
fi