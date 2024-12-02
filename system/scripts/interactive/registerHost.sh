#!/bin/sh

host_name=""
debug=false
no_new_config=false
force=false
no_usage=false
path_to_dotfiles="$PWD/../../../"

print_usage_force() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
	echo "  --hostname, -h <hostName>	Pre set host name"
    echo "  --debug, -d         		Enable debug mode"
    echo "  --no-new-config     		Don't regenerate \"configuration.nix\", \"hardware-configuration.nix\" will always be regenerated."
    echo "  --force, -f         		Overwrite host if it already exists"
    echo "  --no-usage, -u      		Don't show usage after an error"
    echo "  --help, -h          		Display this help message and exit"
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

if [ "$1" = "--help" -o "$1" = "-h" ]; then
    print_usage_force
    exit 0
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --debug|-d)
            debug=true
            ;;
        --no-new-config)
            no_new_config=true
            ;;
        --force|-f)
            force=true
            ;;
        --no-usage|-u)
            no_usage=true
            ;;
		--hostname|-n)
			if [ -n "$2" ]; then
				host_name="$2"
				shift
			else
				echo "Error: --hostname or -n requires a name."
				print_usage
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

echo $host_name
echo $debug
echo $no_new_config
echo $force
echo $no_usage
