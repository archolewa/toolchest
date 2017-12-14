#!/bin/sh
# A simple script that searches for the specified file in the specified
# directory, and opens it in vim.
# Argument order: filename, directory to search in
# If no directory is specified, searches the current directory.
# If neither a directory nor a file is specified, vim opens regularly.

DIRECTORY=$2
FILENAME=$1

if [[ $# -eq 0 ]]; then
    /usr/local/bin/vim
fi

if [[ $FILENAME && -z $DIRECTORY ]]; then
   DIRECTORY=. 
fi

if [[ $DIRECTORY && $FILENAME ]]; then
    /usr/local/bin/vim $(find $DIRECTORY -iname *$FILENAME*)
fi
