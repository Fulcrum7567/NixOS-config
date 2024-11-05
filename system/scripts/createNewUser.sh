#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 -n <new_folder_name> [other_arguments]"
    exit 1
}

# Parse command-line arguments
while getopts ":n:" opt; do
    case ${opt} in
        n )
            new_folder_name=$OPTARG
            ;;
        \? )
            usage
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" >&2
            usage
            ;;
    esac
done

# Remove the processed options from the positional parameters
shift $((OPTIND -1))

# Check if the new folder name is provided
if [ -z "${new_folder_name}" ]; then
    echo "Error: New folder name is required"
    usage
fi

# Directory to copy from (source directory)
src_dir="source_folder"

# Destination directory (where to copy the new folder)
dest_dir="destination_directory"

# Ensure destination directory exists
mkdir -p "${dest_dir}"

# Full path for the new folder
new_folder_path="${dest_dir}/${new_folder_name}"

# Copy the source folder to the destination with the new name
cp -r "${src_dir}" "${new_folder_path}"

# Check if the copy was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy folder"
    exit 1
fi

# Call another script with any additional arguments
if [ "$#" -gt 0 ]; then
    another_script_path="path/to/another_script.sh"
    
    if [ -x "${another_script_path}" ]; then
        "${another_script_path}" "$@"
    else
        echo "Error: Another script is not executable or not found"
        exit 1
    fi
fi

echo "Folder copied successfully to ${new_folder_path}"
