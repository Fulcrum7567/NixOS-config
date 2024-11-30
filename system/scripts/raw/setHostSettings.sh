#!/bin/sh

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
