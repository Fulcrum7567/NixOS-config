#!/bin/bash

# Function to print the usage of the script
print_usage() {
    echo "Usage: $0 <hostName> [options]"
    echo
    echo "Options:"
    echo "  --debug, -d           Enable debug mode"
    echo "  --no-new-config       Skip loading a new configuration"
    echo "  --skip-confirm, -s    Skip confirmation prompts"
    echo "  --help, -h            Display this help message and exit"
    echo
    echo "Examples:"
    echo "  $0 myHost --debug --skip-confirm"
    echo "  $0 myHost -d -s"
    echo "  $0 --help"
}

# Check for --help or -h before processing other arguments
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    print_usage
    exit 0
fi

# Check if hostName (first argument) is provided
if [[ -z "$1" ]]; then
    echo "Error: Missing required argument <hostName>."
    print_usage
    exit 1
fi

# Parse the arguments
HOSTNAME="$1"
shift # Shift to process optional arguments

DEBUG=false
NO_NEW_CONFIG=false
SKIP_CONFIRM=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --debug|-d)
            DEBUG=true
            ;;
        --no-new-config)
            NO_NEW_CONFIG=true
            ;;
        --skip-confirm|-s)
            SKIP_CONFIRM=true
            ;;
        *)
            echo "Error: Unknown argument '$1'."
            print_usage
            exit 1
            ;;
    esac
    shift
done