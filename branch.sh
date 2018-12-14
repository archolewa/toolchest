#! /bin/sh
# Simple shortcut for partially completing a git branch name.
git branch | ag $1 | cut -d "*" -f 2
