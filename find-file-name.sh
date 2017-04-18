#!/bin/sh
# A simple shortcut for finding all files that contain
# specified string starting in the current directory.

find . -iname "*$1*"
