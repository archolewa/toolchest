#!/bin/sh
# A simple bash script that displays the history of changes for the specified file.

git log --follow -p $1
