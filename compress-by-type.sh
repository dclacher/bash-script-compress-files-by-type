#!/bin/bash

path=""
extensions=()

# Function that compresses all files in a directory, by the type(s) provided by the user
compress_files()
{
    # Loop throught the extensions list and use commands find (to get all files with the same extension) + tar/gz (to archive/compress)
    for ext in "${extensions[@]}"
    do
        # If the find command can't find any files of that type, just print a message instead of creating an empty 'tgz' file
        if [[ -z `find $path -maxdepth 1 -type f -name "*.$ext" -print -quit` ]]; then
            echo "No files of type $ext found"
        else
            find $path -maxdepth 1 -type f -name "*.$ext" -print0 | tar cfvz compressed_"$ext"_files.tgz --null -T -
            # -print0 option treats files with white spaces in the name
        fi
    done
}

if [ "$#" == 0 ]; then
    # No arguments provided; show usage with examples
    echo "Usage: $0 [-t target-directory] extension-list"
    echo "Example 1: $0 -t /home/users/bigFoot/ pdf ppt jpg"
    echo "Example 2: $0 pdf ppt jpg"
else
    # Here there's at least one argument provided
    if [ "$1" == "-t" ]; then
        # If the first argument is '-t', at least two more should be provided: path and one extension
        if [ "$#" -lt 3 ]; then
            echo "At least 3 arguments are expected when -t is provided: -t <path> <extension-list>"
            echo "Example: $0 -t /home/users/bigFoot/ pdf ppt jpg"
        else
            # Get the path from the 2nd argument, set the list of extensions to compress and call the compress function
            path="$2"
            shift;
            shift;
            extensions=( "$@" )
            compress_files
        fi
    else
        # If the first argument isn't '-t', treat everything as extensions to be compressed
        path="."
        extensions=( "$@" )
        compress_files
    fi
fi
