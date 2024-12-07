#!/bin/sh

# Check if the message argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <message> <list of options> --default <value>"
  exit 1
fi

# Parse arguments
message="$1"
shift
options=""
default=""

while [ $# -gt 0 ]; do
  case "$1" in
    --default)
      shift
      default="$1"
      ;;
    *)
      options="$options $1"
      ;;
  esac
  shift
done

# Add the cancel option
options="$options cancel/c"

# Prepare option mappings
option_map=""
index_map=""
i=1
for option in $options; do
  variations=$(echo "$option" | tr '/' ' ')
  for var in $variations; do
    option_map="$option_map $(echo "$var" | tr '[:upper:]' '[:lower:]')=$i"
  done
  index_map="$index_map $i=$(echo "$option")"
  i=$((i + 1))
done

# Default handling
default_index=""
if [ -n "$default" ]; then
  default_key=$(echo "$default" | tr '[:upper:]' '[:lower:]')
  for pair in $option_map; do
    key=$(echo "$pair" | cut -d= -f1)
    value=$(echo "$pair" | cut -d= -f2)
    if [ "$key" = "$default_key" ]; then
      default_index=$value
      break
    fi
  done
  if [ -z "$default_index" ]; then
    echo "Error: Default value '$default' is not a valid option."
    exit 1
  fi
fi

# Function to display options
print_options() {
  echo "$message"
  echo " Options:"
  for pair in $index_map; do
    idx=$(echo "$pair" | cut -d= -f1)
    values=$(echo "$pair" | cut -d= -f2-)
    echo "  - $values"
  done
  if [ -n "$default_index" ]; then
    echo " Default:"
    for pair in $index_map; do
      idx=$(echo "$pair" | cut -d= -f1)
      if [ "$idx" = "$default_index" ]; then
        echo "  $(echo "$pair" | cut -d= -f2-)"
        break
      fi
    done
  fi
}

# Prompt the user
while true; do
  print_options
  echo -n ": "
  read user_input
  user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')

  # Handle default if input is empty
  if [ -z "$user_input" ] && [ -n "$default_index" ]; then
    echo "selected $default_index"
    exit "$default_index"
  fi

  # Check if the input is a valid option
  for pair in $option_map; do
    key=$(echo "$pair" | cut -d= -f1)
    value=$(echo "$pair" | cut -d= -f2)
    if [ "$key" = "$user_input" ]; then
      if [ "$(echo "$index_map" | grep "$value=cancel")" ]; then
	    echo "selected cancel"
        exit 0
      else
	    echo "selected $value"
        exit "$value"
      fi
    fi
  done

  echo "Invalid option. Please try again."
done
