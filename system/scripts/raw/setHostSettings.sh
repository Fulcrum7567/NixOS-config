#!/bin/sh

# Initialize default values for options
debug=false
no_usage=false
path_to_dotfiles="$PWD/../../../"


# Function to display usage
print_usage_force() {
    echo "Usage: $0 <hostName> [--debug|-d] [--force|-f]"
    echo "       $0 [--help|-h]"
    echo
    echo "Arguments:"
    echo "  <hostName>          Host name (required unless --help is used)"
    echo "  --debug, -d         Enable debug mode (optional)"
    echo "  --help, -h          Display this help message"
    exit 0
}

print_usage() {
    if [ "$no_usage" == false ]; then
        print_usage_force
    fi
}

print_debug() {
    if [[ "$debug" == true ]]; then
        echo "[Debug]: $1"
    fi
}


# Check for --help/-h first
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    print_usage_force
fi

# Validate the number of arguments
if [[ $# -lt 1 ]]; then
    echo "Error: Missing required <hostName> argument."
    print_usage
fi

# Parse positional arguments
host_name="$1"
shift # Shift to process other options

# Parse optional flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --debug|-d)
            debug=true
            shift
            ;;
        --no-usage|-u)
            no_usage=true
            shift
            ;;
        *)
            echo "Error: Invalid argument '$1'"
            usage
            ;;
    esac
done

if [ ! -f "$path_to_dotfiles/hosts/$host_name/hostSettings.nix" ]; then
    
fi

# Files
FILE1="outputFile.nix"
FILE2="defaultFile.nix"

# Function to get the value of an option in a Nix file
get_option_value() {
    file="$1"
    option="$2"
    # Extract value, remove quotes, and strip whitespace
    grep "$option = " "$file" | sed -n "s/.*$option = \(.*\);/\1/p" | tr -d '"' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Function to set or update an option in file1
set_option_in_file1() {
    option="$1"
    value="$2"
    if grep -q "$option" "$FILE1"; then
        sed -i "s/$option = .*/$option = \"$value\";/" "$FILE1"
    else
        # Add the new option before the closing bracket
        sed -i "/{/a\  $option = \"$value\";" "$FILE1"
    fi
}

# Extract options from file2
options=$(grep -o "^[[:space:]]*[a-zA-Z0-9_]*[[:space:]]*=" "$FILE2" | sed 's/=.*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

for option in $options; do
    # Get values from both files
    value1=$(get_option_value "$FILE1" "$option")
    value2=$(get_option_value "$FILE2" "$option")

    # Handle null values
    if [ "$value2" = "null" ]; then
        value2=""
    fi

    # Determine default value
    if [ -n "$value1" ]; then
        default="$value1"
    elif [ -n "$value2" ]; then
        default="$value2"
    else
        default=""
    fi

    # Prompt the user
    if [ -n "$default" ]; then
        printf "What value should '%s' be? (default: %s): " "$option" "$default"
        read input
        value="${input:-$default}"
    else
        while :; do
            printf "What value should '%s' be? " "$option"
            read input
            if [ -n "$input" ]; then
                value="$input"
                break
            else
                echo "Invalid input. Please provide a value."
            fi
        done
    fi

    # Update file1
    set_option_in_file1 "$option" "$value"
done

echo "File1 has been updated!"
