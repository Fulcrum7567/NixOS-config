#!/bin/sh

# Function to print help message
print_usage_force() {
    echo "Usage: $0 <message> [--help/-h] [--debug/-d] [--default <yes/no>]"
    echo
    echo "Options:"
    echo "  --help, -h          Show this help message and exit."
    echo "  --debug, -d         Enable debug prints."
	echo "	--no-usage, -u		Don't show usage after an error"
    echo "  --default <yes|no> 	Set the default value to 'yes' or 'no'."
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


# Initialize variables
DEBUG=false
DEFAULT=""
MESSAGE=""
no_usage=false

# Parse arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --help|-h)
            print_usage_force
            exit 0
            ;;
        --debug|-d)
            DEBUG=true
            shift
            ;;
		--no-usage|-u)
			no_usage=true
			shift
			;;
        --default)
            if [ -n "$2" ]; then
                # Normalize to lowercase for validation
                DEFAULT=$(echo "$2" | tr 'A-Z' 'a-z')
                case "$DEFAULT" in
                    y|yes)
                        DEFAULT="yes"
                        shift 2
                        ;;
                    n|no)
                        DEFAULT="no"
                        shift 2
                        ;;
                    *)
                        echo "Error: --default requires a valid 'yes' or 'no' variation."
                        exit 1
                        ;;
                esac
            else
                echo "Error: --default requires 'yes' or 'no' as argument."
                exit 1
            fi
            ;;
        *)
            if [ -z "$MESSAGE" ]; then
                MESSAGE=$1
                shift
            else
                echo "Error: Unexpected argument '$1'."
                exit 1
            fi
            ;;
    esac
done

# Validate message
if [ -z "$MESSAGE" ]; then
    echo "Error: <message> is required."
    print_usage
    exit 1
fi



# Ask the user for input
while true; do
    if [ -n "$DEFAULT" ]; then
        printf "%s (y/n) (default: %s): " "$MESSAGE" "$(echo "$DEFAULT" | cut -c1)"
        read RESPONSE
        RESPONSE=$(echo "$RESPONSE" | tr 'A-Z' 'a-z') # Convert to lowercase

        # Use default if user presses enter
        if [ -z "$RESPONSE" ]; then
            RESPONSE=$DEFAULT
        fi
    else
        printf "%s (y/n): " "$MESSAGE"
        read RESPONSE
        RESPONSE=$(echo "$RESPONSE" | tr 'A-Z' 'a-z') # Convert to lowercase
    fi


    # Validate response
    case "$RESPONSE" in
        y|yes)
            print_debug "User selected yes."
            exit 0
            ;;
        n|no)
            print_debug "User selected no."
            exit 1
            ;;
        *)
            echo "Invalid input. Please answer with 'yes' or 'no'."
            ;;
    esac
done
