#! /bin/sh
# A script that returns the current branch.
git branch | fgrep "*" | cut -d " " -f 2
