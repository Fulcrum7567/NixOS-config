#!/bin/bash

# Initialize variables
add_flag=false
path=""
dotfiles="$PWD/../.."
currentDevice=$CURRENT_DEVICE

#!/bin/bash

# Variables to track the presence of the -a/--add option and the path
add_flag=false
path=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -a|--add)
            add_flag=true
            shift
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            # If it's not an option, treat it as the path
            if [[ -z "$path" ]]; then
                path="$1"
            else
                echo "Unexpected argument: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

# Check if the path argument is provided
if [[ -z "$path" ]]; then
    echo "Error: Path argument is required."
    exit 1
fi

# Check if required arguments are set

if [[ ! -f $dotfiles/additionalConfigs/$1.nix ]]; then
	mkdir -p $(dirname "$dotfiles/additionalConfigs/$1") 
	cp "$PWD/presets/additionalConfigs/newAdditionalConfig.nix" $dotfiles/additionalConfigs/$1.nix
fi

$EDITOR $dotfiles/additionalConfigs/$1.nix

if [ "$add_flag" == true -a ! -z $currentDevice ]; then
	echo adding to $currentDevice
else
	echo didnt add
fi




